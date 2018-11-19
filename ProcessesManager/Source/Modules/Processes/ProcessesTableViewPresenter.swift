//
//  ProcessesTableViewPresenter.swift
//  ProcessesManager
//
//  Created by Andrew Vergunov on 11/18/18.
//  Copyright © 2018 Andrew Vergunov. All rights reserved.
//

import Cocoa

protocol ProcessesPresenter: class {
    func setupColumns()
    func renew(withProcesses processes: [ProcessesService.Process])
    var selectedProcess: ProcessesService.Process? { get }
}

class ProcessesTableViewPresenter: NSObject, ProcessesPresenter {
    @IBOutlet fileprivate var tableView: NSTableView!
    private var showingProcesses: [SortAvailableProcess] = []
    fileprivate static let tableViewRowIdentifier = NSUserInterfaceItemIdentifier("tableViewRowIdentifier")
    var selectedProcess: ProcessesService.Process?

    func setupColumns() {
        tableView.target = self
        tableView.action = #selector(tableViewDidSelected)
        for column in Column.allCases {
            let columnIdentifier = NSUserInterfaceItemIdentifier(column.identifier)
            let tableColumn = NSTableColumn(identifier: columnIdentifier)
            tableColumn.width = tableView.bounds.size.width / CGFloat(Column.allCases.count)
            tableColumn.title = column.title
            tableColumn.sortDescriptorPrototype = column.sortDescriptor
            tableColumn.isEditable = false
            tableView.addTableColumn(tableColumn)
        }
    }

    func renew(withProcesses processes: [ProcessesService.Process]) {
        let selected = selectedProcess
        showingProcesses = processes.map({ SortAvailableProcess(process: $0) })
        showingProcesses = (self.showingProcesses as NSArray).sortedArray(using: tableView.sortDescriptors) as! [SortAvailableProcess]
        tableView.reloadData()
        if let process = selected,
            let index = showingProcesses.firstIndex(of: SortAvailableProcess(process: process)) {
            let indexSet = IndexSet([index])
            tableView.selectRowIndexes(indexSet, byExtendingSelection: false)
        }
    }

    @objc func tableViewDidSelected() {
        let row = tableView.selectedRow
        if row < 0 && selectedProcess == nil {
            return
        } else if row >= 0 {
            selectedProcess = showingProcesses[row].process
        }
    }

    // MARK: - Private
    fileprivate func cellRect() -> CGRect {
        let cellWidth = tableView.bounds.size.width / CGFloat(Column.allCases.count)
        return CGRect(x: 0,
                      y: 0,
                      width: cellWidth,
                      height: 0)
    }

    fileprivate func column(byTableIdentifier: String?) -> Column? {
        return Column.allCases.first(where: { $0.identifier == byTableIdentifier })
    }
}

extension ProcessesTableViewPresenter: NSTableViewDelegate {
    private func stringValue(tableColumn: NSTableColumn?, row: Int) -> String? {
        if let column = column(byTableIdentifier: tableColumn?.identifier.rawValue) {
            return self.stringValue(forColumn: column, inRow: row)
        }
        return nil
    }

    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        self.showingProcesses = (self.showingProcesses as NSArray).sortedArray(using: tableView.sortDescriptors) as! [SortAvailableProcess]
        self.tableView.reloadData()
        self.tableView.deselectAll(nil)
        if let process = selectedProcess,
            let index = showingProcesses.firstIndex(of: SortAvailableProcess(process: process)) {
            let indexSet = IndexSet([index])
            tableView.selectRowIndexes(indexSet, byExtendingSelection: false)
        }
    }

    private func stringValue(forColumn: Column, inRow: Int) -> String {
        switch forColumn {
        case .name:
            return showingProcesses[inRow].name
        case .pid:
            return String(showingProcesses[inRow].pid)
        case .owner:
            return showingProcesses[inRow].owner
        }
    }
}

extension ProcessesTableViewPresenter: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return showingProcesses.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return self.stringValue(tableColumn: tableColumn, row: row) ?? ""
    }
}
