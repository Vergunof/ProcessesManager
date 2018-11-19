//
//  Process.swift
//  ProcessesManager
//
//  Created by Andrew Vergunov on 11/16/18.
//  Copyright © 2018 Andrew Vergunov. All rights reserved.
//

import Foundation

public extension ProcessesService {
    public struct Process: Hashable {
        let pid: pid_t
        let name: String
        let owner: String
    }
}
