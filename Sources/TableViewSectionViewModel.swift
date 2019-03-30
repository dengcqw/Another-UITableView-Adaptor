//
//  TableViewSectionViewModel.swift
//  TVGuor
//
//  Created by Steven on 9/20/17.
//  Copyright © 2017 xiaoguo. All rights reserved.
//

import Foundation

// MARK: - TableViewSectionViewModel

/// A view model which provides property and method requirements for section header/footer view of table view.

public protocol TableViewSectionViewModel: SectionViewModel {

    var estimatedHeight: CGFloat { get }

    var title: String? { get }

    var headerEstimatedHeight: CGFloat { get }

    var footerEstimatedHeight: CGFloat { get }

    var headerTitle: String? { get }

    var footerTitle: String? { get }

}


// MARK: - Default Implementations

extension TableViewSectionViewModel {

    public var estimatedHeight: CGFloat {
        return height
    }

    public var title: String? {
        return nil
    }

    public var headerEstimatedHeight: CGFloat {
        return location == .header ? estimatedHeight : 0
    }

    public var footerEstimatedHeight: CGFloat {
        return location == .footer ? estimatedHeight : 0
    }

    public var headerTitle: String? {
        return location == .header ? title : nil
    }

    public var footerTitle: String? {
        return location == .footer ? title : nil
    }

}


// MARK: - Default concrete TableViewSectionViewModel

public struct TitleTableViewSectionViewModel: TableViewSectionViewModel {

    public var height: CGFloat = 44

    var attributedTitle: NSAttributedString?

    var insets: UIEdgeInsets = .zero

    public static var reuseIdentifier: String = TitleTableViewSectionView.shortClassName

    public var reuseIdentifier: String {
        return TitleTableViewSectionViewModel.reuseIdentifier
    }

}
