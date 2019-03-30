//
//  TableViewGroupModel.swift
//  TVGuor
//
//  Created by Steven on 9/20/17.
//  Copyright © 2017 xiaoguo. All rights reserved.
//

import Foundation


/// This type groups a section's section model and cell modes together.

public struct TableViewGroupModel {

    public var sectionViewModel: TableViewSectionViewModel?

    public var cellModels: [TableViewCellViewModel]?

    public init(sectionViewModel: TableViewSectionViewModel? = nil, cellModels: [TableViewCellViewModel]? = nil) {
        self.sectionViewModel = sectionViewModel
        self.cellModels = cellModels
    }
}
