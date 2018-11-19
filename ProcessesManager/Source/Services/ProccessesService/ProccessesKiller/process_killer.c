//
//  process_killer.c
//  ProcessesManager
//
//  Created by Andrew Vergunov on 11/18/18.
//  Copyright © 2018 Andrew Vergunov. All rights reserved.
//

#include "process_killer.h"
#include <signal.h>

// https://stackoverflow.com/questions/15692275/how-to-kill-a-process-tree-programmatically-on-linux-using-c/15692619
// http://www.tutorialspoint.com/unix_system_calls/kill.htm

int terminate_proc(pid_t proc) {
    return kill(proc, SIGKILL);
}
