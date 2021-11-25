#ifndef ACK_H
#define ACK_H

#define ACK_COMMAND 0b01
#define ACK_SIZE 18

#include "command_struct.h"

void ack_build(command *comamnd_ptr, int rn);
int ack_validate(int packages[], int command_size);

#endif /* ACK_H */
