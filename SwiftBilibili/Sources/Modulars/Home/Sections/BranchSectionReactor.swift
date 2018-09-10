//
//  BranchSectionReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/7/11.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import SectionReactor
import RxSwift

final class BranchSectionReactor: SectionReactor {

    enum SectionItem {
        case banner(TogetherBannerCellReactor)
        case special(BranchSpecialCellReactor)
        case av(TogetherAvCellReactor)
        case player(BranchPlayerCellReactor)
        case entrance(BranchEntranceCellReactor)
    }

    enum Action {}

    enum Mutation {}

    struct State: SectionReactorState {
        var sectionItems: [SectionItem]
    }

    let initialState: State

    init(item:BranchItemModel) {
        
        defer { _ = self.state }
        
        var sectionItems: [SectionItem] = []
        
        switch item.goto {
        case .special:
          sectionItems.append(.special(BranchSpecialCellReactor(item: item)))
        case .entrance:
          guard let items = item.item else { break }
          sectionItems.append(.entrance(BranchEntranceCellReactor(items: items)))
        case .banner:
          sectionItems.append(.banner(TogetherBannerCellReactor(banners: item.banner_item ?? [])))
        case .content_rcmd,.tag_rcmd:
          guard let subs = item.item else { break }
          let count = subs.filter{$0.goto == .av}.count
          if count < 2 { break }
          var avSubs = subs.filter{$0.goto == .av}
          if avSubs.count%2 != 0 {
             avSubs = Array(avSubs.dropLast())
          }
          sectionItems += avSubs.map{.av(TogetherAvCellReactor(branch: $0))}
        case .player:
          guard let subs = item.item else { break }
          sectionItems += subs.map{.player(BranchPlayerCellReactor(av: $0))}
        default:break
       }
        self.initialState = State(sectionItems: sectionItems)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }

    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}
