#ifndef RN_CRC_H
#define RN_CRC_H

#include "../crc.h"
#include "command_struct.h"

#define RN_CRC_SIZE 32

void rn_crc_build(command *rn_crc, int rn);

int rn_crc_validate(int packages[], int command_size);

#endif /* RN_CRC_H */
