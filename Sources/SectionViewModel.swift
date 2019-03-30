//
//  SectionViewModel.swift
//  TVGuor
//
//  Created by Steven on 9/21/17.
//  Copyright © 2017 xiaoguo. All rights reserved.
//

import Foundation

// MARK: - SectionViewLocation

public enum SectionViewLocation {
    case header
    case footer
}


// MARK: - SectionViewModel


/// A view model which provides common property and method requirements for section header/footer view of table/collection view.

public protocol SectionViewModel {

    var height: CGFloat { get }

    var backgroundColor: UIColor { get }

    static var reuseIdentifier: String { get }

    var reuseIdentifier: String { get }

    var location: SectionViewLocation { get }

    var renderWhenWillAppear: Bool { get }

    func viewWillDisplay()

    var headerHeight: CGFloat { get }

    var footerHeight: CGFloat { get }

    var headerReuseIdentifier: String? { get }

    var footerReuseIdentifier: String? { get }

}


// MARK: - SectionViewModel Default Implementations

public extension SectionViewModel {

    var backgroundColor: UIColor {
        return .white
    }

    var location: SectionViewLocation {
        return .header
    }

    var renderWhenWillAppear: Bool {
        return true
    }
    
    func viewWillDisplay() { }

    var headerHeight: CGFloat {
        return location == .header ? height : 0
    }

    var footerHeight: CGFloat {
        return location == .footer ? height : 0
    }

    var headerReuseIdentifier: String? {
        return location == .header ? reuseIdentifier : nil
    }

    var footerReuseIdentifier: String? {
        return location == .footer ? reuseIdentifier : nil
    }
}

