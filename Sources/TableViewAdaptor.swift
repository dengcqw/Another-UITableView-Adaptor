//
//  TableViewAdaptor.swift
//  TVGuor
//
//  Created by dengjinlong on 11/8/16.
//  Copyright © 2016 xiaoguo. All rights reserved.
//

import UIKit

open class TableViewAdaptor: NSObject {

    /// single section's cellModels
    open var cellModels: [TableViewCellViewModel]? {
        get { return groupModels?.count == 1 ? self.cellModels(atSection: 0) : nil }
        set { groupModels = [TableViewGroupModel(cellModels: newValue)] }
    }

    /// multiple sections' cellModels
    open var groupModels: [TableViewGroupModel]? {
        didSet {
            if Thread.isMainThread {
                tableView?.reloadData()
            } else {
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }
        }
    }

    open weak var tableView: UITableView? {
        willSet {
            if let tableView = newValue {
                tableView.delegate = self
                tableView.dataSource = self
                tableView.tableFooterView = UIView()
                tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
                tableView.backgroundColor = UIColor.clear
                tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCellViewModel.nameOfClass)
            }
        }
    }
    
    /*
     需要处理tableview其他方法，可以设置此值
     Important: 先设置此值，再设置tableView，因为tableview会检查代理实现的方法并缓存
     */
    open weak var tableViewProxyDelegate: UITableViewDelegate? {
        willSet {
            guard self.tableView == nil else {
                assert(false, "set tableViewProxyDelegate before setting tableview")
                return
            }
        }
    }
}

// MARK: - Private

fileprivate extension TableViewAdaptor {

    func cellModels(atSection section: Int) -> [TableViewCellViewModel]? {
        if groupModels != nil && groupModels!.count > section {
            return groupModels![section].cellModels
        } else {
            return nil
        }
    }

    func cellModels(atIndexPath indexPath: IndexPath) -> TableViewCellViewModel? {
        let cellModels = self.cellModels(atSection: indexPath.section)
        if cellModels != nil && cellModels!.count > indexPath.row {
            return cellModels?[indexPath.row]
        } else {
            return nil
        }
    }

    func sectionModel(atSection section: Int) -> TableViewSectionViewModel? {
        if groupModels != nil && groupModels!.count > section {
            return groupModels![section].sectionViewModel
        } else {
            return nil
        }
    }
}

// MARK: - TableView Delegate

extension TableViewAdaptor: UITableViewDelegate, UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return groupModels?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels(atSection: section)?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return sectionModel(atSection: section)?.headerEstimatedHeight ?? 0
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return sectionModel(atSection: section)?.footerEstimatedHeight ?? 0
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionModel(atSection: section)?.headerHeight ?? 0
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sectionModel(atSection: section)?.footerHeight ?? 0
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionModel(atSection: section)?.headerTitle
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sectionModel(atSection: section)?.footerTitle
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionModel = self.sectionModel(atSection: section), let id = sectionModel.headerReuseIdentifier else {
            return nil
        }

        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: id) else {
            assert(false, "View Model [\(id))] was NOT registered as reuse view")
            return nil
        }

        if var sectionView = view as? TableViewSectionViewProtocol {
            sectionView.model = sectionModel
            if !sectionModel.renderWhenWillAppear {
                sectionView.render(model: sectionModel)
            }
        }

        return view
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let sectionModel = self.sectionModel(atSection: section), let id = sectionModel.footerReuseIdentifier else {
            return nil
        }

        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: id) else {
            assert(false, "View Model [\(id))] was NOT registered as reuse view")
            return nil
        }

        if var sectionView = view as? TableViewSectionViewProtocol {
            sectionView.model = sectionModel
            if !sectionModel.renderWhenWillAppear {
                sectionView.render(model: sectionModel)
            }
        }

        return view
    }

    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let sectionView = view as? TableViewSectionViewProtocol,
            let sectionModel = self.sectionModel(atSection: section),
            sectionModel.renderWhenWillAppear else {
            return
        }

        sectionView.render(model: sectionModel)
    }

    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let sectionView = view as? TableViewSectionViewProtocol,
            let sectionModel = self.sectionModel(atSection: section),
            sectionModel.renderWhenWillAppear else {
                return
        }

        sectionView.render(model: sectionModel)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = cellModels(atIndexPath: indexPath) else {
            return UITableViewCell()
        }

        var cell: TableViewCell
        if let reusedCell:TableViewCell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier) as? TableViewCell {
            cell = reusedCell
        } else {
            assert(false, "View Model [\(type(of:cellModel))] not register reuse cell")
            let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "")
            return cell
        }

        if !cellModel.renderWhenWillDisplay {
            cell.tableView = self.tableView
            cell.indexPath = indexPath
            cellModel.indexPath = indexPath
            cell.configCell(with: cellModel)
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TableViewCell, let cellModel = cellModels(atIndexPath: indexPath) else {
            return
        }

        if cellModel.renderWhenWillDisplay {
            cell.tableView = self.tableView
            cell.indexPath = indexPath
            cellModel.indexPath = indexPath
            cell.configCell(with: cellModel)
        }
        cellModel.willDisplayCell?(cell)
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellModel = cellModels(atIndexPath: indexPath) else {
            return 0
        }

        if cellModel.hide == true {
            return 0
        } else {
            if cellModel.preferedCellHeight() == UITableView.automaticDimension {
                return cellModel.estimatedCellHeight
            } else {
                return cellModel.preferedCellHeight()
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellModel = cellModels(atIndexPath: indexPath) else {
            return 0
        }

        if cellModel.hide == true {
            return 0
        } else {
            return cellModel.preferedCellHeight()
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let cellModel = cellModels(atIndexPath: indexPath) else {
            return
        }
        cellModel.didSelectFunc(cellModel)
    }
}

// MARK: - Method Forwarding

extension TableViewAdaptor {

    override open func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let delegate = self.tableViewProxyDelegate {
            if (delegate.responds(to: aSelector)) {
                return self.tableViewProxyDelegate
            }
        }
        return super.forwardingTarget(for: aSelector)
    }
    
    override open func responds(to aSelector: Selector!) -> Bool {
        if let delegate = self.tableViewProxyDelegate {
            if (delegate.responds(to: aSelector)) {
                return true
            }
        }
        return super.responds(to: aSelector)
    }
}
