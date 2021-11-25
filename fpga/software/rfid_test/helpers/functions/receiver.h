#ifndef RECEIVER_H
#define RECEIVER_H

#include "../config.h"
#include "system.h"
#include "../commands/commands.h"
#include "stdio.h"
#include "io.h"
#include "rfid.h"

void receiver_enable(void);

int receiver_check_usedw(void);

int receiver_request_package(void);

int receiver_empty(void);

void receiver_rdreq(void);

int receiver_get_package(int[], int, int *);
#endif /* RECEIVER_H */
