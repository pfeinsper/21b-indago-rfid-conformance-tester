#ifndef RN_CRC_H
#define RN_CRC_H

#include "../crc.h"

#define RN_CRC_SIZE 32

typedef struct
{
    unsigned short result_data;
    unsigned int size;
} rn_crc;

void rn_crc_generate(rn_crc *rn_crc_ptr);

int rn_crc_validate(int packages[], int command_size);

#endif /* RN_CRC_H */
