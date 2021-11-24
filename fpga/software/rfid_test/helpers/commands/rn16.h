#ifndef RN16_H
#define RN16_H

#define RN_SIZE 16

typedef struct
{
    unsigned short value;
    unsigned int size;
} rn16;

unsigned short rn16_generate(void);

int rn16_validate(int packages[], int quant_packages, int command_size);

#endif /* RN16_H */
