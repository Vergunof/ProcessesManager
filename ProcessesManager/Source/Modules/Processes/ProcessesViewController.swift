//
//  ViewController.swift
//  ProcessesManager
//
//  Created by Andrew Vergunov on 11/16/18.
//  Copyright © 2018 Andrew Vergunov. All rights reserved.
//

import Cocoa

class ProcessesViewController: NSViewController {
    @IBOutlet fileprivate var tableViewPresenter: ProcessesTableViewPresenter!

    override func viewDidLoad() {
        tableViewPresenter.setupColumns()
        updateProcesses()
        startTrackingProcesses()
    }

    @IBAction func didPressedTerminate(_ sender: Any) {
        if let process = tableViewPresenter.selectedProcess {
            if let errorDuringTermination = ProcessesService.sharedInstance.kill(proccess: process) {
                showAlert(withError: errorDuringTermination)
            }
        } else {
            showAlert(withTitle: "No process was selected.",
                      andDescription: "Should be selected any process before terminating.")
        }

        updateProcesses()
    }

    // https://developer.apple.com/documentation/appkit/nsalert
    private func showAlert(withTitle: String, andDescription: String) {
        let alert = NSAlert()
        alert.messageText = withTitle
        alert.informativeText = andDescription
        alert.alertStyle = .warning
        alert.runModal()
    }

    private func showAlert(withError: Error) {
        let alert = NSAlert(error: withError)
        alert.runModal()
    }

    // Should be done via kext (KAUTH api) and hooking SYS_execve
    // https://developer.apple.com/library/archive/technotes/tn2050/_index.html

    func startTrackingProcesses() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] (timer) in
            self?.updateProcesses()
        }
    }

    func updateProcesses() {
        let processes = ProcessesService.sharedInstance.currentProcesses
        tableViewPresenter.renew(withProcesses: Array(processes))
    }
}

