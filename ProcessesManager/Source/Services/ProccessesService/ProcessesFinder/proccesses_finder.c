//
//  proccesses_finder.c
//  ProcessesManager
//
//  Created by Andrew Vergunov on 11/16/18.
//  Copyright © 2018 Andrew Vergunov. All rights reserved.
//

#import "proccesses_finder.h"

#include <stdlib.h>
#import <string.h>
#import <libproc.h>
#include <pwd.h>


// https://developer.apple.com/library/archive/qa/qa2001/qa1123.html
void getProcesses(pid_t **procList, size_t *procCount) {
    int number_processes = proc_listallpids(NULL, 0);

    pid_t pidList[number_processes];
    bzero(pidList, sizeof(pidList));
    proc_listallpids(pidList, (int)sizeof(pidList));

    pid_t *pids = malloc((number_processes + 1) * sizeof(pid_t));
    int pid_index = 0;

    for (int i = 0; i < number_processes; ++i) {
        pids[pid_index] = pidList[i];
        pid_index++;
    }

    *procCount = number_processes;
    *procList = pids;
}
