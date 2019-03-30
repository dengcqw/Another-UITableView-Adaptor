//
//  TableViewCell.swift
//  TVGuor
//
//  Created by dengjinlong on 11/8/16.
//  Copyright © 2016 xiaoguo. All rights reserved.
//

import UIKit

open class TableViewCell: UITableViewCell {
    
    open weak var tableView: UITableView?

    deinit {
        print("deinit: \(self.shortClassName)")
    }
    
    /// 用来标记cellModel和cell的关系
    open var indexPath: IndexPath?
    
    open var cellModel: TableViewCellViewModel?
    
    final func configCell(with cellModel: TableViewCellViewModel) {
        cellModel.reloadDelegate = self
        self.cellModel = cellModel
        
        self.renderCell(with: cellModel)
        self.bindCell(with: cellModel)
    }

    /**
     视图和模型的双向绑定，都放置在这个方法中
     注意cell复用时清除绑定
     
     - parameter viewModel: 视图相关的模型
     */
    open func bindCell(with cellModel: TableViewCellViewModel) {
    }
    
}

// MARK: - cell reload delegate method
extension TableViewCell: CellReloadDeleate {
    
    /// 用来标记cellModel和cell的关系
    public var cellIndexPath: IndexPath {
        get {
            return self.indexPath ?? IndexPath(row: 0, section: Int.max)
        }
    }
    
    /**
     用模型来刷新视图
     通过继承来增加新的设置
     
     - parameter viewModel: 视图相关的模型
     */
    @objc open func renderCell(with cellModel: TableViewCellViewModel, animated: Bool = false) {
        //assert(self.cellModel == cellModel, "Cell model reloadDelegate point to wrong cell, maybe invoke `render` of invisiable cell model")
        
        self.backgroundColor = cellModel.backgroundColor
        self.contentView.backgroundColor = cellModel.backgroundColor
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.clipsToBounds = true
        self.isUserInteractionEnabled = !cellModel.disableSelection
        if (cellModel.disableSelectionStyle) {
            self.selectionStyle = UITableViewCell.SelectionStyle.none
        } else {
            self.selectionStyle = UITableViewCell.SelectionStyle.gray
        }
    
        if (cellModel.showTopLine) {
            self.addLine(.top, insets: cellModel.lineIndent, color: cellModel.lineColor)
        } else {
            self.removeLine(.top)
        }
        if (cellModel.showBottomLine) {
            self.addLine(.bottom, insets: cellModel.lineIndent, color: cellModel.lineColor)
        } else {
            self.removeLine(.bottom)
        }
    }
     
    public func reloadCell(animated: Bool) {
        if let indexPath:IndexPath = self.tableView?.indexPath(for: self) {
            let animation: UITableView.RowAnimation = animated ? .automatic : .none
            self.tableView?.reloadRows(at: [indexPath], with: animation)
        }
    }
    
    public func reloadTableView() {
        self.tableView?.reloadData()
    }
    
}
