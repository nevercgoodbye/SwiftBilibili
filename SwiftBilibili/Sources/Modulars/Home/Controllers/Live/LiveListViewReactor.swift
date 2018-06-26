//
//  LiveListViewReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/26.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReactorKit
import RxSwift
import Dollar
import RxCocoa

final class LiveListViewReactor: Reactor,OutputRefreshProtocol {

    enum Action {
        case refresh
    }
    
    enum Mutation {
        case setRefresh(LiveTotalModel,[LiveStarShowModel])
        case setRecommend(LiveRecommendModel)
        case setCommonLives(LivePartitionType,[LivePartitionAvModel],Bool)
    }
    
    struct State {
        var sections: [LiveListViewSection]?
        var stopRotate: (IndexPath,Bool)?
    }
    let initialState: State
    let service: HomeServiceType
    var refreshStatus: BehaviorRelay<BilibiliRefreshStatus>

    private var totalModel: LiveTotalModel?
    private var starShows: [LiveStarShowModel]?
    private var partitionAtts: [Int:[LivePartitionAvModel]] = [:]
    private let partitionShowCount = 6
    private var isShowOtherRoom = false
    private var page = 0
    
    init(service:HomeServiceType) {
        defer { _ = self.state }
        self.service = service
        self.initialState = State()
        self.refreshStatus = BehaviorRelay<BilibiliRefreshStatus>(value: .none)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .refresh:
            
           let allRequest = service.livePartitionList().asObservable()
           let recommendRequest = service.liveRecommendList().asObservable()
           return Observable.zip(allRequest, recommendRequest, resultSelector: { (os1, os2) -> Mutation in
                return Mutation.setRefresh(os1,os2)
            })
        }
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setRefresh(totalModel,starShowModels):
            self.refreshStatus.accept(.endHeaderRefresh)
            let starShows = starShowModels.count > 0 ? starShowModels : nil
            self.totalModel = totalModel
            self.starShows = starShows
            isShowOtherRoom = (totalModel.star_show.partition.hidden ?? 1) <= 0
            var sections: [LiveListViewSection] = []
            let rcmdSection = getRcmdSection(totalModel.recommend_data, totalModel.banner, starShows)
            sections.append(rcmdSection)
            if isShowOtherRoom {
                let otherSection = getOtherSection(totalModel.star_show)
                sections.append(otherSection)
                let bannerSection = getBannerSection(totalModel.recommend_data.banner_data[0])
                sections.append(bannerSection)
            }
            let partitionSections = getPartitionSections(totalModel.partitions)
            sections += partitionSections
            state.sections = sections
            
        case .setRecommend(let recommendModel):
            let rcmdSection = getRcmdSection(recommendModel, totalModel!.banner, starShows)
            state.sections?[0] = rcmdSection
            state.stopRotate = (IndexPath(item: 0, section: 0),true)
        case let .setCommonLives(partitionType,commonLives,isRequest):
            
            let updateSection = getUpdateSectionForPartition(partitionType, lives: commonLives, isRequest: isRequest)
            let updateSectionIndex = getUpdateSectionIndexForPartition(partitionType)
            state.sections![updateSectionIndex] = updateSection
            state.stopRotate = (IndexPath(item: 0, section: updateSectionIndex),isRequest)
        }
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        
        let eventMutation = LiveTotalModel.event.flatMap {[weak self] liveEvent -> Observable<Mutation> in
            self?.mutate(event: liveEvent) ?? .empty()
        }
        
        return Observable.of(mutation,eventMutation).merge()
    }
    
    //由于分区一次请求的数据是20条，而只显示6条,所以后两次换一换时不需要发起网络请求
    private func mutate(event:LiveTotalModel.Event) -> Observable<Mutation> {
        
        switch event {
        case .refreshRecommendPartition:
            return service.reloadRecommendPartition().asObservable().map{.setRecommend($0)}
        case .refreshCommonPartition(let partitionType):
            
            if partitionType == .beauty {
                page += 1
                //接口参数有问题,多刷两次就没有数据了
                return service.getOtherSourceRoomList(page:page,pageSize:4).asObservable().map{Mutation.setCommonLives(partitionType, $0, true)}
            }else{
                if let storeLives = partitionAtts[partitionType.rawValue],storeLives.count > partitionShowCount {
                    return Observable.just(Mutation.setCommonLives(partitionType, storeLives,false))
                }else{
                    return service.reloadCommonPartition(partitionType: partitionType).asObservable().map{.setCommonLives(partitionType,$0,true)}
                }
            }
        }
    }
    
    private func getRcmdSection(_ rcmdData: LiveRecommendModel,
                                _ banners: [LiveListBannerModel],
                                _ starShows: [LiveStarShowModel]?) -> LiveListViewSection{
        
        let rcmdAvModels = isShowOtherRoom ? Dollar.initial(rcmdData.lives, numElements: rcmdData.lives.count/2) : rcmdData.lives
        
        let rcmdBannerModel = isShowOtherRoom ? nil : rcmdData.banner_data[0]
        
        let sectionReactor = LiveListSectionReactor(rcmdAvModels: rcmdAvModels, rcmdBannerModel: rcmdBannerModel)

        let section = LiveListViewSection(items: sectionReactor.currentState.sectionItems.map{LiveListViewSectionItem.live($0)}, banners: banners, header: rcmdData.partition, starShows: starShows)
        
        return section
    }
    
    private func getOtherSection(_ star_show: LivePartitionModel) -> LiveListViewSection {
        
        let sectionReactor = LiveListSectionReactor(beautyAvModels: star_show.lives)
        let section = LiveListViewSection(items: sectionReactor.currentState.sectionItems.map{LiveListViewSectionItem.live($0)}, header: star_show.partition)
        return section
    }
    
    private func getBannerSection(_ rcmdBanner: LiveRecommendBannerModel) -> LiveListViewSection {
     
        let sectionReactor = LiveListSectionReactor(rcmdBannerModel: rcmdBanner)
        let section = LiveListViewSection(items: sectionReactor.currentState.sectionItems.map{LiveListViewSectionItem.live($0)})
        return section
    }
    
    private func getPartitionSections(_ partitions: [LivePartitionModel]) -> [LiveListViewSection] {
        
        var sections: [LiveListViewSection] = []
        
        for partitionModel in partitions {
            let sectionReactor = LiveListSectionReactor(partitionAvModels: partitionModel.lives)
            let section = LiveListViewSection(items: sectionReactor.currentState.sectionItems.map{LiveListViewSectionItem.live($0)}, header: partitionModel.partition)
            sections.append(section)
        }
        return sections
    }
    
    private func getUpdateSectionForPartition(_ partitionType: LivePartitionType,lives: [LivePartitionAvModel],isRequest: Bool) -> LiveListViewSection {
        
        switch partitionType {
        case .beauty:
            let sectionReactor = LiveListSectionReactor(beautyAvModels: Dollar.initial(lives, numElements: lives.count - 4))
            let section = LiveListViewSection(items: sectionReactor.currentState.sectionItems.map{LiveListViewSectionItem.live($0)}, header: totalModel!.star_show.partition)
            return section
        default:
            let index = partitionType.rawValue
            let livesArray = Dollar.chunk(lives, size: partitionShowCount)
            let showLives = livesArray[0]
            if !isRequest {
                if lives.count > 2 * partitionShowCount {
                    partitionAtts[index] = Dollar.merge(livesArray[1],livesArray[2])
                }else{
                    partitionAtts[index] = Dollar.merge(livesArray[1])
                }
            }else{
                partitionAtts.removeValue(forKey: index)
                partitionAtts[index] = Dollar.merge(livesArray[1],livesArray[2],livesArray[3])
            }
            let sectionReactor = LiveListSectionReactor(partitionAvModels: showLives)
            let section = LiveListViewSection(items: sectionReactor.currentState.sectionItems.map{LiveListViewSectionItem.live($0)}, header: totalModel!.partitions[index - 1].partition)
            return section
        }
    }
    
    private func getUpdateSectionIndexForPartition(_ partitionType: LivePartitionType) -> Int {
        
        if isShowOtherRoom {
            switch partitionType {
            case .beauty:
                return 1
            default:
               return partitionType.rawValue + 2
            }
        }else{
            return partitionType.rawValue
        }
    }
    
}
