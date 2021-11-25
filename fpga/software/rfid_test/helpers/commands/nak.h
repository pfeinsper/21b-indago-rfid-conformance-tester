#ifndef NAK_H
#define NAK_H

#include "command_struct.h"

#define NAK_COMMAND 0b11000000
#define NAK_SIZE 8

void nak_build(command *nak);
int nak_validate(int packages[], int command_size);

#endif /* NAK_H */
