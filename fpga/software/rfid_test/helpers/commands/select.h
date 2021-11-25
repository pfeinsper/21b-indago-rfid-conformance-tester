#ifndef SELECT_H
#define SELECT_H

#include "command_struct.h"

#define SELECT_COMMAND 0b1010
#define SELECT_SIZE 44

void select_build(command *select, unsigned char target, unsigned char action,
                 unsigned char mem_bank, unsigned char pointer,
                 unsigned char length, unsigned char mask,
                 unsigned char truncate, unsigned short crc);

int select_validate(int packages[], int command_size);

#endif /* SELECT_H */
