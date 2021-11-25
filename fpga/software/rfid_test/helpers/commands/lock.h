#ifndef LOCK_H
#define LOCK_H

#include "command_struct.h"

#define LOCK_COMMAND 0b11000101
#define LOCK_SIZE 60


void lock_build(command *lock, unsigned int payload, unsigned short rn,
               unsigned short crc);

int lock_validate(int packages[], int command_size);

#endif /* LOCK_H */
