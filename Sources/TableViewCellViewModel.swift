//
//  TableViewCellViewModel.swift
//  TableviewSwiftDemo
//
//  Created by dengjinlong on 10/31/16.
//  Copyright © 2016 iqiyi. All rights reserved.
//

import UIKit
import ObjectiveC

open class TableViewCellViewModel: NSObject {
    
    open var hide: Bool = false // 如果设为true返回0高度给tableview
    open var showTopLine: Bool = false
    open var showBottomLine: Bool = false
    open var lineIndent: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    open var lineColor: UIColor?
    open var backgroundColor: UIColor = UIColor.white
    open var didSelectFunc: (TableViewCellViewModel)->Void = {_ in }
    open var disableSelectionStyle: Bool = true
    open var disableSelection: Bool = false
    
    open var editing: Bool = false // 编辑状态
    open var selected: Bool = false // 选中状态

    /// if it's true, render cell on tableView(_:willDisplayCell:for:row:)
    open var renderWhenWillDisplay = false

    // MARK: - cell identifier
    open class var reuseIdentifier: String {
        return nameOfClass
    }
    open var reuseIdentifier: String {
        return nameOfClass
    }

    // MARK: - cell height
    open var cellHeight: CGFloat = 45
    open var estimatedCellHeight: CGFloat = 45

    open func preferedCellHeight() -> CGFloat {
        return self.cellHeight
    }
    
    // MARK: - reload cell
    open weak var reloadDelegate: CellReloadDeleate?
    
    deinit {
        print("deinit \(type(of:self))")
    }
    
    /// 用来标记cellModel和cell的关系
    open var indexPath: IndexPath?
    
    // calculate cell height with template cell
    // capture template cell in `calculateHeight`
    open var calculateHeight: ((TableViewCellViewModel) ->  CGFloat)?
    open var isDirty: Bool = false
    
    open var willDisplayCell:((TableViewCell)->Void)?
}

// MARK: - notify cell delegate
extension TableViewCellViewModel {
    /**
     渲染和此model关联的cell，对于需要频繁刷新数据，且不触发tableview代理方法
     此方法对应 `-renderCell` 方法
     */
    @objc
    open func render(animated: Bool = false) {
        if let delegate: CellReloadDeleate = self.reloadDelegate,
            self.indexPath == delegate.cellIndexPath {
            
            delegate.renderCell(with: self, animated: animated)
        }
    }
    
    /**
     触发tableview代理方法，重新加载cell
     此方法对应 `-reloadCell` 方法
     */
    @objc
    open func reload(animated: Bool = true) {
        if let delegate: CellReloadDeleate = self.reloadDelegate,
            self.indexPath == delegate.cellIndexPath {
            
            delegate.reloadCell(animated: animated)
        }
    }
    
    /**
     触发tableview代理方法，刷新所有cell
     此方法对应 `-reloadTableView` 方法
     */
    open func reloadAll() {
        if let delegate = self.reloadDelegate {
            delegate.reloadTableView()
        }
    }
}

extension TableViewCellViewModel {
    public static var nameOfClass: String {
        return String(describing: self)
    }
    public var nameOfClass: String {
        return String(describing: type(of: self))
    }
}

public protocol CellReloadDeleate: NSObjectProtocol {
    func renderCell(with cellModel: TableViewCellViewModel, animated:Bool) -> Void
    func reloadCell(animated: Bool) -> Void
    func reloadTableView() -> Void
    var cellIndexPath: IndexPath {get}
    var tableView: UITableView? { get }
}

extension Array where Element: TableViewCellViewModel {
    // hide first cell topline and last cell bottomline
    func showLinesForGroup() {
        let lastIdx = count - 1
        for (idx, model) in enumerated() {
            if idx != lastIdx {
                model.showBottomLine = true
            }
        }
    }
}
