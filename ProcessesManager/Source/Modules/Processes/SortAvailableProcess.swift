//
//  SortAvailableProcess.swift
//  ProcessesManager
//
//  Created by Andrew Vergunov on 11/19/18.
//  Copyright © 2018 Andrew Vergunov. All rights reserved.
//

import Foundation

public class SortAvailableProcess: NSObject {
    public override func isEqual(_ object: Any?) -> Bool {
        return self.pid == (object as? SortAvailableProcess)?.pid
    }

    @objc let pid: pid_t
    @objc let name: String
    @objc let owner: String
    var process: ProcessesService.Process {
        return ProcessesService.Process(pid: pid, name: name, owner: owner)
    }

    init(process: ProcessesService.Process) {
        self.pid = process.pid
        self.name = process.name
        self.owner = process.owner
    }
}
