//
//  Column.swift
//  ProcessesManager
//
//  Created by Andrew Vergunov on 11/19/18.
//  Copyright © 2018 Andrew Vergunov. All rights reserved.
//

import Foundation

enum Column: CaseIterable {
    case name
    case pid
    case owner

    var identifier: String {
        switch self {
        case .name:
            return "nameIdentifier"
        case .pid:
            return "pidIdentifier"
        case .owner:
            return "ownerIdentifier"
        }
    }

    var title: String {
        switch self {
        case .name:
            return "Name"
        case .pid:
            return "Identifier"
        case .owner:
            return "Owner"
        }
    }

    var sortDescriptor: NSSortDescriptor {
        switch self {
        case .name:
            return NSSortDescriptor(key: "name", ascending: false, selector: #selector(NSString.localizedStandardCompare) as Selector)
        case .pid:
            return NSSortDescriptor(key: "pid", ascending: false)
        case .owner:
            return NSSortDescriptor(key: "owner", ascending: false, selector: #selector(NSString.localizedStandardCompare) as Selector)
        }
    }
}
