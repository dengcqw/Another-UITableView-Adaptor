//
//  StaticTableViewCell.swift
//  TVGuor
//
//  Created by Deng Jinlong on 2018/7/16.
//  Copyright © 2018 xiaoguo. All rights reserved.
//

open class StaticCellModel: TableViewCellViewModel {
    public var buildContentBlock: ((UIView)->Void)? = nil
    public init(height: CGFloat, buildBlock: @escaping (UIView)->Void) {
        super.init()
        buildContentBlock = buildBlock
        cellHeight = height
    }
}

open class StaticCell: TableViewCell {
    override open func renderCell(with cellModel: TableViewCellViewModel, animated: Bool) {
        super.renderCell(with: cellModel, animated: animated)
        if let model = cellModel as? StaticCellModel {
            contentView.subviews.forEach { $0.removeFromSuperview() }
            model.buildContentBlock?(contentView)
        }
    }
}

