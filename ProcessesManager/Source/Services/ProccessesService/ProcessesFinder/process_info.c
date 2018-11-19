//
//  process_info.c
//  ProcessesManager
//
//  Created by Andrew Vergunov on 11/18/18.
//  Copyright © 2018 Andrew Vergunov. All rights reserved.
//

#include "process_info.h"
#include <stdlib.h>
#import <sys/proc_info.h>
#import <libproc.h>
#import <string.h>
#include <pwd.h>
#include <sys/sysctl.h>

//https://stackoverflow.com/questions/3018054/retrieve-names-of-running-processes
//https://stackoverflow.com/questions/12273546/get-name-from-pid/12274588#12274588

char *get_proc_name(pid_t proc) {
    char pathBuffer[PROC_PIDPATHINFO_MAXSIZE];
    bzero(pathBuffer, PROC_PIDPATHINFO_MAXSIZE);
    proc_pidpath(proc, pathBuffer, sizeof(pathBuffer));

    char *nameBuffer = malloc(256 * sizeof(char));
    bzero(nameBuffer, 256);
    unsigned long position = strlen(pathBuffer);
    while(position >= 0 && pathBuffer[position] != '/')
    {
        position--;
    }
    strcpy(nameBuffer, pathBuffer + position + 1);
    return nameBuffer;
}

//https://stackoverflow.com/questions/44445048/macos-how-to-get-process-user-owner-with-pid-using-c-c
//https://stackoverflow.com/questions/6457682/how-to-programatically-get-uid-from-pid-in-osx-using-c
uid_t uidFromPid(pid_t pid);

char *get_proc_owner(pid_t proc) {
    uid_t user_uid = uidFromPid(proc);
    struct passwd *pwd = getpwuid(user_uid);
    return pwd == NULL ? NULL : pwd->pw_name;
}

uid_t uidFromPid(pid_t pid)
{
    uid_t uid = -1;

    struct kinfo_proc process;
    size_t procBufferSize = sizeof(process);

    // Compose search path for sysctl. Here you can specify PID directly.
    const u_int pathLenth = 4;
    int path[pathLenth] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, pid};

    int sysctlResult = sysctl(path, pathLenth, &process, &procBufferSize, NULL, 0);

    // If sysctl did not fail and process with PID available - take UID.
    if ((sysctlResult == 0) && (procBufferSize != 0))
    {
        uid = process.kp_eproc.e_ucred.cr_uid;
    }

    return uid;
}
