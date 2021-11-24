#ifndef RN_CRC_H
#define RN_CRC_H

#define RN_CRC_SIZE 32

typedef struct
{
    unsigned short value;
    unsigned int size;
} rn_crc;

unsigned short rn_crc_generate(void);

int rn_crc_validate(int packages[], int quant_packages, int command_size);

#endif /* RN_CRC_H */
