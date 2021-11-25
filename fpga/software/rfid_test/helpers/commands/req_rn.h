#ifndef REQ_RN_H
#define REQ_RN_H

#include "../crc.h"
#include "command_struct.h"

#define REQ_RN_COMMAND 0b11000001
#define REQ_RN_SIZE 40

void req_rn_build(command *req_rn_ptr, int rn);
int req_rn_validate(int packages[], int command_size);

#endif /* REQ_RN_H */
