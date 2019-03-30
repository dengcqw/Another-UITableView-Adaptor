//
//  TableViewSectionView.swift
//  TVGuor
//
//  Created by Steven on 9/21/17.
//  Copyright © 2017 xiaoguo. All rights reserved.
//

import Foundation

public protocol TableViewSectionViewProtocol {

    var model: TableViewSectionViewModel { get set }

    func render(model: TableViewSectionViewModel)

}

open class TitleTableViewSectionView: UITableViewHeaderFooterView, TableViewSectionViewProtocol {

    // MARK: - Properties

    public var model: TableViewSectionViewModel = TitleTableViewSectionViewModel()

    private var titleModel: TitleTableViewSectionViewModel {
        return model as! TitleTableViewSectionViewModel
    }

    let label: UILabel = UILabel()

    // MARK: - Init

    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        contentView.backgroundColor = model.backgroundColor
        contentView.addSubview(label)
    }

    // MARK: - Life Cycle

    open override func layoutSubviews() {
        super.layoutSubviews()

        let insets = titleModel.insets
        label.frame = CGRect(x: insets.left,
                             y: insets.top,
                             width: bounds.width - insets.left - insets.right,
                             height: bounds.height - insets.top - insets.bottom)
    }

    public func render(model: TableViewSectionViewModel) {
        guard let titleModel = model as? TitleTableViewSectionViewModel else { return }

        if let attributedTitle = titleModel.attributedTitle {
            label.attributedText = attributedTitle
        } else {
            label.text = titleModel.title
        }

        setNeedsLayout()
    }

}
