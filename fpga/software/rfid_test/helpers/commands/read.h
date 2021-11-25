#ifndef READ_H
#define READ_H

#include "command_struct.h"

#define READ_COMMAND 0b11000010
#define READ_SIZE 57

void read_build(command *read, unsigned char mem_bank, unsigned char word_ptr,
               unsigned char word_count, unsigned short rn, unsigned short crc);

int read_validate(int packages[], int command_size);

#endif /* READ_H */
