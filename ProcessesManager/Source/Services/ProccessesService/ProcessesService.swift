//
//  ProccessesService.swift
//  ProcessesManager
//
//  Created by Andrew Vergunov on 11/16/18.
//  Copyright © 2018 Andrew Vergunov. All rights reserved.
//

import Foundation

public protocol ProcessesServiceDelegate: class {
    func didOpened(process: Process)
    func didClosed(process: Process)
}

public struct ProcessesService {
    public weak var delegate: ProcessesServiceDelegate?
    static var sharedInstance: ProcessesService = ProcessesService()

    public var currentProcesses: Set<Process> {
        return getCurrentProcesses()
    }

    public func kill(proccess: Process) -> Error? {
        let answer = terminate_proc(proccess.pid)
        return error(forTerminateAnswer: answer)
    }

    // MARK: - Private
    private func getCurrentProcesses() -> Set<ProcessesService.Process> {
        let pidsArray = pids()
        let processes = pidsArray.compactMap(mapToProcess)
        let processesSet = Set(processes)
        return processesSet
    }

    private func pids() -> [pid_t] {
        var pids: pid_t = 0
        var pointer: UnsafeMutablePointer<pid_t>? = UnsafeMutablePointer<pid_t>(&pids)
        let pidsPointer: UnsafeMutablePointer<UnsafeMutablePointer<pid_t>?>? = UnsafeMutablePointer<UnsafeMutablePointer<pid_t>?>(&pointer)
        var count: Int = 0
        let countPointer = UnsafeMutablePointer<Int>(&count)
        getProcesses(pidsPointer, countPointer)
        let bufferPointer = UnsafeBufferPointer(start: pointer, count: count)
        let pidsArray = Array(bufferPointer)
        free(pointer)
        return pidsArray
    }

    private func mapToProcess(_ pid: pid_t) -> Process? {
        guard let pidNameCString = get_proc_name(pid) else {
            return nil
        }

        var processName = String(cString: pidNameCString)

        free(pidNameCString)

        if pid == 0 { processName = "kernel" }

        guard let pidOwnerCString = get_proc_owner(pid) else {
            return nil
        }

        let processOwner = String(cString: pidOwnerCString)
        return Process(pid: pid, name: processName, owner: processOwner)
    }

    private func error(forTerminateAnswer answer: Int32) -> Error? {
        let domain = "com.vergunov.terminateError"

        if answer != ERR_SUCCESS {
            let description: String
            if let error = strerror(answer) {
                description = String(cString: error)
            } else {
                description = "Unknown error"
            }

            return NSError(domain: domain,
                           code: Int(answer),
                           userInfo: [NSLocalizedDescriptionKey: description])
        } else {
            return nil
        }
    }
}
