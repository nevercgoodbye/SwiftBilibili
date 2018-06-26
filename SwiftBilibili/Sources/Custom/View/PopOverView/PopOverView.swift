//
//  PopOverView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/24.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

class Section<ActionDataType, SectionHeaderDataType> {
    
    open var data: SectionHeaderDataType? {
        get { return _data?.data }
        set { _data = RawData(data: newValue) }
    }
    open var actions = [Action<ActionDataType>]()
    fileprivate var _data: RawData<SectionHeaderDataType>?
    
    public init() {}
}

enum CellSpec<CellType: UITableViewCell,CellDataType> {
    case nibFile(nibName: String, bundle: Bundle?, height: ((CellDataType) -> CGFloat))
    case cellClass(height:((CellDataType) -> CGFloat))
    
    var height: ((CellDataType) -> CGFloat) {
        
        switch self {
        case .nibFile(_, _, let heightCallback):
            return heightCallback
        case .cellClass(let heightCallback):
            return heightCallback
        }
    }
}

enum HeaderSpec<HeaderType: UIView,HeaderDataType> {
    case nibFile(nibName: String, bundle: Bundle?, height: ((HeaderDataType) -> CGFloat))
    case cellClass(height:((HeaderDataType) -> CGFloat))
    
    var height: ((HeaderDataType) -> CGFloat) {
        switch self {
        case .nibFile(_, _, let heightCallback):
            return heightCallback
        case .cellClass(let heightCallback):
            return heightCallback
        }
    }
}

enum FooterSpec<FooterType: UIView,FooterDataType> {
    case nibFile(nibName: String, bundle: Bundle?, height: ((FooterDataType) -> CGFloat))
    case cellClass(height:((FooterDataType) -> CGFloat))
    
    var height: ((FooterDataType) -> CGFloat) {
        switch self {
        case .nibFile(_, _, let heightCallback):
            return heightCallback
        case .cellClass(let heightCallback):
            return heightCallback
        }
    }
}

private enum ReusableViewIds: String {
    case Cell = "Cell"
    case SectionHeader = "SectionHeader"
}

final class RawData<T> {
    var data: T!
    
    init?(data: T?) {
        guard let data = data else { return nil }
        self.data = data
    }
}

class PopOverView<ActionViewType: UITableViewCell,ActionDataType,HeaderViewType:UIView,HeaderDataType,FooterViewType:UIView,FooterDataType,SectionHeaderViewType: UITableViewHeaderFooterView, SectionHeaderDataType> : UIView,UITableViewDataSource,UITableViewDelegate {
    
    private let screenHeight = UIScreen.main.bounds.height
    private let screenWidth = UIScreen.main.bounds.width
    private let keyWindow = UIApplication.shared.keyWindow
    private var isUpward = true
    
    //MARK: - Private properties
    fileprivate var _footerData: RawData<FooterDataType>?
    fileprivate var _headerData: RawData<HeaderDataType>?
    fileprivate var _actions = [Action<ActionDataType>]()
    fileprivate var _sections = [Section<ActionDataType, SectionHeaderDataType>]()
    
    
    //MARK - Public properties
    var headerData: HeaderDataType? {
        set { _headerData = RawData(data: newValue)}
        get { return _headerData?.data}
    }
    
    var footerData: FooterDataType? {
        set { _footerData = RawData(data: newValue)}
        get { return _footerData?.data}
    }
    
    var settings: PopOverViewSettings = PopOverViewSettings.defaultSettings()
    
    var cellSpec: CellSpec<ActionViewType,ActionDataType>?
    var sectionHeaderSpec: HeaderSpec<SectionHeaderViewType, SectionHeaderDataType>?
    var headerSpec: HeaderSpec<HeaderViewType,HeaderDataType>?
    var footerSpec: FooterSpec<FooterViewType,FooterDataType>?
    var onConfigureCellForAction: ((ActionViewType,Action<ActionDataType>,IndexPath) -> ())?
    var onConfigureHeader: ((HeaderViewType,HeaderDataType) -> ())?
    var onConfigureSectionHeader: ((SectionHeaderViewType, SectionHeaderDataType) -> ())?
    var onConfigureFooter: ((FooterViewType,FooterDataType) -> ())?

    //MARK: - UI
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        backgroundView.backgroundColor = self.settings.overView.coverViewColor
        if self.settings.behavior.hideOnTap {
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(PopOverView.tapGestureDidRecognize(_:)))
            backgroundView.addGestureRecognizer(tapGes)
        }
        return backgroundView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.bounces = self.settings.behavior.bounces
        tableView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        tableView.backgroundColor = UIColor.clear
        tableView.isScrollEnabled = self.settings.behavior.scrollEnable
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = settings.overView.backgroundColor
        self.addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = settings.overView.backgroundColor
        self.addSubview(tableView)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        initializers()
    }
    
    
    private func initializers() {
        
        if let cellSpec = self.cellSpec {
            switch cellSpec {
            case let .nibFile(nibName, bundle, _):
                tableView.register(UINib(nibName: nibName, bundle: bundle), forCellReuseIdentifier: ReusableViewIds.Cell.rawValue)
            case .cellClass:
                tableView.register(ActionViewType.self, forCellReuseIdentifier: ReusableViewIds.Cell.rawValue)
            }
        }
        
        if let headerSpec = headerSpec, let headerData = headerData {
            
            switch headerSpec {
            case let .nibFile(nibName, bundle, _):
                let bundle = bundle == nil ? Bundle.main : bundle
                let headerView = bundle?.loadNibNamed(nibName, owner: nil, options: nil)?.first as? UIView
                tableView.tableHeaderView = headerView
                onConfigureHeader?(headerView as! HeaderViewType,headerData)
            case .cellClass:
                tableView.tableHeaderView = HeaderViewType()
            }
        }
        
        if let footerSpec = footerSpec, let footerData = footerData {
            
            switch footerSpec {
            case let .nibFile(nibName, bundle, _):
                let bundle = bundle == nil ? Bundle.main : bundle
                let footView = bundle?.loadNibNamed(nibName, owner: nil, options: nil)?.first as? UIView
                tableView.tableFooterView = footView
                onConfigureFooter?(footView as! FooterViewType,footerData)
            case .cellClass:
                tableView.tableFooterView = FooterViewType()
            }
        }
        
        if let headerSpec = sectionHeaderSpec {
            switch headerSpec {
            case .cellClass:
                tableView.register(SectionHeaderViewType.self, forHeaderFooterViewReuseIdentifier: ReusableViewIds.SectionHeader.rawValue)
            case let .nibFile(nibName, bundle, _):
                tableView.register(UINib(nibName: nibName, bundle: bundle), forHeaderFooterViewReuseIdentifier: ReusableViewIds.SectionHeader.rawValue)
            }
        }
    }
    
    //MARK: - Public API
    func addAction(_ action: Action<ActionDataType>) {
        if let section = _sections.last {
            section.actions.append(action)
        }else{
            let section = Section<ActionDataType, SectionHeaderDataType>()
            addSection(section)
            section.actions.append(action)
        }
    }
    
    @discardableResult
    open func addSection(_ section: Section<ActionDataType, SectionHeaderDataType>) -> Section<ActionDataType, SectionHeaderDataType> {
        _sections.append(section)
        return section
    }
    
    // MARK: - Helpers
    
    func sectionForIndex(_ index: Int) -> Section<ActionDataType, SectionHeaderDataType>? {
        return _sections[index]
    }
    
    func actionForIndexPath(_ indexPath: IndexPath) -> Action<ActionDataType>? {
        return _sections[(indexPath as NSIndexPath).section].actions[(indexPath as NSIndexPath).item]
    }
    
    func actionIndexPathFor(_ indexPath: IndexPath) -> IndexPath {
        if hasHeader() {
            return IndexPath(item: (indexPath as NSIndexPath).item, section: (indexPath as NSIndexPath).section - 1)
        }
        return indexPath
    }
    
    private func actionSectionIndexFor(_ section: Int) -> Int {
        return hasHeader() ? section - 1 : section
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = CGRect(x: 0, y: isUpward ? settings.arrowView.height : 0, width: self.bounds.width, height: self.bounds.height - settings.arrowView.height)
    }
    
    
    //MARK: - Event handlers
    @objc func tapGestureDidRecognize(_ gesture: UITapGestureRecognizer) {
        dismiss()
    }
    
    //MARK: - Internal helpers
    func hasHeader() -> Bool {
        return headerData != nil && headerSpec != nil
    }
    
    func hasFooter() -> Bool {
        return footerData != nil && footerSpec != nil
    }
    
    private func numberOfSections() -> Int {
        return hasHeader() ? _sections.count + 1 : _sections.count
    }
    
    func show(pointView: UIView,_ completion:(() -> ())? = nil) {
       
        guard let pointViewRect = pointView.superview?.convert(pointView.frame, to: keyWindow) else { return }
        let pointViewUpLenth = pointViewRect.minY
        let pointViewDownLength = screenHeight - pointViewRect.maxY
        // 弹窗箭头指向的点
        var toPoint = CGPoint(x: pointViewRect.midX, y: 0)
        // 弹窗在 pointView 顶部
        if pointViewUpLenth > pointViewDownLength {
            
            if pointViewUpLenth > screenHeight - settings.arrowView.igoreOffest {
                
                toPoint.y = pointViewUpLenth - settings.arrowView.upOffest - settings.arrowView.targetOffest
            }else{
                toPoint.y = pointViewUpLenth - settings.arrowView.targetOffest
            }
            
            isUpward = false
        }else{
            toPoint.y = pointViewRect.maxY + settings.arrowView.targetOffest
            isUpward = true
        }
        
        show(toPoint: toPoint,completion:completion)
    }
    
    func show(tapPoint:CGPoint,completion:(() -> ())? = nil) {
        
        isUpward = tapPoint.y <= screenHeight - tapPoint.y

        show(toPoint: tapPoint,completion:completion)
    }
    
    func dismiss(isNeedAnimation:Bool = true,_ completion: (() -> ())? = nil) {
        
        let duration = isNeedAnimation ? settings.animation.duration : 0
        
        UIView.animate(withDuration: duration, animations: {
            
            self.alpha = 0.0
            self.backgroundView.alpha = 0.0
            self.transform = CGAffineTransform(scaleX: self.settings.animation.scale.width, y: self.settings.animation.scale.height)
        }) { (_) in
            self.backgroundView.removeFromSuperview()
            self.removeFromSuperview()
            if completion != nil {
                completion!()
            }
        }
    }
    
    private func show(toPoint:CGPoint,completion:(() -> ())? = nil) {
        
        //参数
        let edgeAlignment = settings.arrowView.edgeAlignment
        let arrowWidth = settings.arrowView.width
        let arrowHeight = settings.arrowView.height
        let viewCornerRadius = settings.overView.viewCornerRadius
        let arrowCornerRadius = settings.arrowView.arrowCornerRadius
        let arrowBottomCornerRadius = settings.arrowView.arrowBottomCornerRadius
        let horizontalMargin = settings.overView.horizontalMargin
        let verticalMargin = settings.overView.verticalMargin
        let viewWidth = settings.overView.viewWidth
        
        var toPoint = toPoint
        //如果不需要箭头边缘对齐
        if !edgeAlignment {
           
           let minHorizonalEdge = horizontalMargin + viewCornerRadius + arrowWidth/2
           
            if toPoint.x < minHorizonalEdge {
                toPoint.x = minHorizonalEdge
            }
            
            if screenWidth - toPoint.x < minHorizonalEdge {
                toPoint.x = screenWidth - minHorizonalEdge
            }
        }
        
        backgroundView.alpha = 0
        keyWindow!.addSubview(backgroundView)
        
        tableView.reloadData()
        
        let currentW = viewWidth
        var currentH = tableView.contentSize.height
        
        if let headerSpec = headerSpec,let headerData = headerData {
            currentH += headerSpec.height(headerData)
        }
        
        if let footerSpec = footerSpec,let footerData = footerData {
            currentH += footerSpec.height(footerData)
        }
        
        currentH += arrowHeight
        
        // 限制最高高度, 免得选项太多时超出屏幕
        let statusBarFrame = UIApplication.shared.statusBarFrame
        let maxHeight = isUpward ? screenHeight - toPoint.y - verticalMargin : toPoint.y - statusBarFrame.height
        if currentH > maxHeight {
            currentH = maxHeight
            tableView.isScrollEnabled = true
        }
        
        var currentX = toPoint.x - currentW/2 + horizontalMargin
        var currentY = toPoint.y
        
        var isLeft = false
        var isRight = false
    
        if edgeAlignment {
            isLeft = toPoint.x + currentW + horizontalMargin <= screenWidth
            isRight = horizontalMargin + currentW <= toPoint.x
        }else{
            isLeft = toPoint.x <= currentW/2 + horizontalMargin
            isRight = screenWidth - toPoint.x <= currentW/2 + horizontalMargin
        }
        // x: 窗口靠左
        if isLeft {
            currentX = edgeAlignment ? toPoint.x : horizontalMargin
        }
        // x: 窗口靠右
        if isRight {
            currentX = edgeAlignment ? toPoint.x - currentW : screenWidth - horizontalMargin - currentW
        }
        
        if !isUpward {
            currentY = toPoint.y - currentH
        }
        
        self.frame = CGRect(x: currentX, y: currentY, width: currentW, height: currentH)
        
        let arrowPoint = CGPoint(x: toPoint.x - self.frame.minX, y: isUpward ? 0 : currentH)
        let maskTop = isUpward ? arrowHeight : 0
        let maskBottom = isUpward ? currentH : currentH - arrowHeight
        let maskPath = UIBezierPath()

        if edgeAlignment && isLeft && isUpward {
            
            maskPath.move(to: CGPoint(x: 0, y: 0))
            
        }else{
            //左上圆角
            maskPath.move(to: CGPoint(x: 0, y: viewCornerRadius + maskTop))
            maskPath.addArc(withCenter: CGPoint(x: viewCornerRadius, y: viewCornerRadius + maskTop),
                            radius: viewCornerRadius,
                            startAngle: degreesToRadius(180),
                            endAngle: degreesToRadius(270),
                            clockwise: true)
        }
        // 箭头向上时的箭头位置
        if isUpward {
           let upX = edgeAlignment && (isLeft || isRight) ? arrowPoint.x : arrowPoint.x - arrowWidth/2
           maskPath.addLine(to: CGPoint(x: upX, y: arrowHeight))
            
           if edgeAlignment && (isLeft || isRight) {
            
              maskPath.addLine(to: arrowPoint)
              maskPath.addLine(to: CGPoint(x: arrowPoint.x + (isLeft ? arrowWidth/2 : -arrowWidth/2), y: arrowHeight))
            
           }else{
              maskPath.addQuadCurve(to: CGPoint(x: arrowPoint.x - arrowCornerRadius, y: arrowCornerRadius),
                                  controlPoint: CGPoint(x: arrowPoint.x - arrowWidth/2 + arrowBottomCornerRadius, y: arrowHeight))
              maskPath.addQuadCurve(to: CGPoint(x: arrowPoint.x + arrowCornerRadius, y: arrowCornerRadius),
                                  controlPoint: arrowPoint)
            
              maskPath.addQuadCurve(to: CGPoint(x: arrowPoint.x + arrowWidth/2, y: arrowHeight),
                                  controlPoint: CGPoint(x: arrowPoint.x + arrowWidth/2 - arrowBottomCornerRadius, y: arrowHeight))
           }
        }
        
        if edgeAlignment && isRight && isUpward {
            
            maskPath.addLine(to: CGPoint(x: currentW, y: maskTop))
        
        }else{
            //右上圆角
            maskPath.addLine(to: CGPoint(x: currentW - viewCornerRadius, y: maskTop))
            maskPath.addArc(withCenter: CGPoint(x: currentW - viewCornerRadius, y: viewCornerRadius + maskTop),
                            radius: viewCornerRadius,
                            startAngle: degreesToRadius(270),
                            endAngle: degreesToRadius(0),
                            clockwise: true)
        }
        
        if edgeAlignment && isRight && !isUpward {
            
            maskPath.addLine(to: CGPoint(x: currentW, y: currentH - arrowHeight))
            
        }else{
            //右下圆角
            maskPath.addLine(to: CGPoint(x: currentW, y: maskBottom - viewCornerRadius))
            maskPath.addArc(withCenter: CGPoint(x: currentW - viewCornerRadius, y: maskBottom - viewCornerRadius),
                            radius: viewCornerRadius,
                            startAngle: degreesToRadius(0),
                            endAngle: degreesToRadius(90),
                            clockwise: true)
        }
        // 箭头向下时的箭头位置
        if !isUpward {
           let downX = edgeAlignment && (isLeft || isRight) ? arrowPoint.x : arrowPoint.x + arrowWidth/2
           maskPath.addLine(to: CGPoint(x: downX, y: currentH - arrowHeight))
            
           if edgeAlignment && (isLeft || isRight) {
                
              maskPath.addLine(to: arrowPoint)
              maskPath.addLine(to: CGPoint(x: arrowPoint.x - (isLeft ? -arrowWidth/2 : arrowWidth/2), y: currentH - arrowHeight))
                
           }else{
            
              maskPath.addQuadCurve(to: CGPoint(x: arrowPoint.x + arrowCornerRadius, y: currentH - arrowCornerRadius),
                                  controlPoint: CGPoint(x: arrowPoint.x + arrowWidth/2 - arrowBottomCornerRadius, y: currentH - arrowHeight))
              maskPath.addQuadCurve(to: CGPoint(x: arrowPoint.x - arrowCornerRadius, y: currentH - arrowCornerRadius),
                                  controlPoint: arrowPoint)
            
              maskPath.addQuadCurve(to: CGPoint(x: arrowPoint.x - arrowWidth/2, y: currentH - arrowHeight),
                                  controlPoint: CGPoint(x: arrowPoint.x - arrowWidth/2 + arrowBottomCornerRadius, y: currentH - arrowHeight))
           }
        }
        
        if edgeAlignment && isLeft && !isUpward {
            
            maskPath.addLine(to: CGPoint(x: 0, y: currentH - arrowHeight))
            
        }else{
            //左下圆角
            maskPath.addLine(to: CGPoint(x: viewCornerRadius, y: maskBottom))
            maskPath.addArc(withCenter: CGPoint(x:viewCornerRadius, y: maskBottom - viewCornerRadius),
                            radius: viewCornerRadius,
                            startAngle: degreesToRadius(90),
                            endAngle: degreesToRadius(180),
                            clockwise: true)
        }
        maskPath.close()
        // 截取圆角和箭头
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        
        keyWindow!.addSubview(self)
        
        //弹出动画
        let oldFrame = self.frame
        self.layer.anchorPoint = CGPoint(x: arrowPoint.x/currentW, y: isUpward ? 0 : 1)
        self.frame = oldFrame
        self.transform = CGAffineTransform(scaleX: settings.animation.scale.width, y: settings.animation.scale.height)
        
        UIView.animate(withDuration: settings.animation.duration, animations: {
            
            self.transform = CGAffineTransform.identity
            self.backgroundView.alpha = 1
            
        }) { (_) in
            
            if let completion = completion {
                completion()
            }
        }
    }

    private func degreesToRadius(_ angle: CGFloat) -> CGFloat {
        return angle * CGFloat.pi / 180
    }
    
    //MARK: - UITableViewDataSources
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _sections[section].actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let action = actionForIndexPath(indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableViewIds.Cell.rawValue, for: indexPath) as? ActionViewType
        
        self.onConfigureCellForAction?(cell!, action!, indexPath)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 && hasHeader() {
            return nil
        }else{
            let reusableView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableViewIds.SectionHeader.rawValue) as? SectionHeaderViewType
            onConfigureSectionHeader?(reusableView!, sectionForIndex(section)!.data!)
            
            return reusableView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            if let headerData = headerData, let headerSpec = headerSpec {
                return headerSpec.height(headerData)
            }else if let sectionHeaderSpec = sectionHeaderSpec, let section = sectionForIndex(actionSectionIndexFor(section)), let sectionData = section.data {
                return sectionHeaderSpec.height(sectionData)
            }
        }else if let sectionHeaderSpec = sectionHeaderSpec, let section = sectionForIndex(actionSectionIndexFor(section)), let sectionData = section.data {
              return  sectionHeaderSpec.height(sectionData)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let action = actionForIndexPath(indexPath)
        
        if let actionData = action?.data,
           let cellSpec = self.cellSpec {
            
            return cellSpec.height(actionData)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let action = actionForIndexPath(indexPath)!
    
        self.dismiss(isNeedAnimation: settings.animation.tapShouldAnimated) {
            action.handler?(action)
        }
    }
}



