//
//  TableViewRow.swift
//  EZSource
//
//  Created by Alex Hmelevski on 2018-06-04.
//

import Foundation

protocol CellProvider: TappableCell,CellDequeuer,CellActionsProvider { }

protocol CellActionsProvider {
    var trailingContextualActions: [UIContextualAction] { get }
    var leadingContextualActions: [UIContextualAction] { get }
}

protocol TappableCell {
   func didTap()
}

protocol CellDequeuer {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) throws -> UITableViewCell
}


public struct TableViewRow<T,C>: CellProvider where C: Configurable & ReusableCell, C.Model == T  {
    let model: T
    let onTap: ((T) -> Void)?
    var traillingActions: [RowAction] = []
    var leadingActions: [RowAction] = []
    
    public init(model: T,
                traillingActions: [RowAction] = [],
                leadingActions: [RowAction] = [],
                onTap: ((T) -> Void)? = nil) {
        self.model = model
        self.onTap = onTap
        self.traillingActions = traillingActions
        self.leadingActions = leadingActions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) throws -> UITableViewCell {
        let cell: C = tableView.dequeueCell(at: indexPath)
        cell.configure(with: model)
        return cell.uiTableViewCell
    }
    
    func didTap() {
        onTap?(model)
    }
    
    var trailingContextualActions: [UIContextualAction] {
        return traillingActions.map({ $0.contextualAction })
    }
    
    var leadingContextualActions: [UIContextualAction] {
        return leadingActions.map({ $0.contextualAction })
    }
    
}


// MARK: - Mutating Methods
extension TableViewRow {
    
    public mutating func addRowTrailingActions(_ actions: [RowAction]) {
        traillingActions.append(contentsOf: actions)
    }
    
    public mutating func addRowLeadingActions(_ actions: [RowAction]) {
        leadingActions.append(contentsOf: actions)
    }
}


// MARK: - Immutable Methods
extension TableViewRow {
    
    public func addedRowTrailingActions(_ actions: [RowAction]) -> TableViewRow {
        var mutable = self
        mutable.addRowTrailingActions(actions)
        return mutable
    }
    
    public func addedRowLeadingActions(_ actions: [RowAction]) -> TableViewRow {
        var mutable = self
        mutable.addRowLeadingActions(actions)
        return mutable
    }
}

