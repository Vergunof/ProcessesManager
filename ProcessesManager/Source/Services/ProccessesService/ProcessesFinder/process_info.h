//
//  process_info.h
//  ProcessesManager
//
//  Created by Andrew Vergunov on 11/18/18.
//  Copyright © 2018 Andrew Vergunov. All rights reserved.
//

#ifndef process_info_h
#define process_info_h

#include <stdio.h>

char *get_proc_name(pid_t proc);
char *get_proc_owner(pid_t proc);

#endif /* process_info_h */
