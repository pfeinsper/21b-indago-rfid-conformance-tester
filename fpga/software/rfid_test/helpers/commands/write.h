#ifndef WRITE_H
#define WRITE_H

#include "command_struct.h"

#define WRITE_COMMAND 0b11000011
#define WRITE_SIZE 58

void write_build(command *write, unsigned char mem_bank, unsigned char word_ptr,
                unsigned short data, unsigned short rn, unsigned short crc);

int write_validate(int packages[], int command_size);

#endif /* WRITE_H */
