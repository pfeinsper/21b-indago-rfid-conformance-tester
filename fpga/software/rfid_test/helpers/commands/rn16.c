#include "rn16.h"

unsigned short rn16_generate()
{
    return 0xFD24;
}

int rn16_validate(int packages[], int quant_packages, int command_size)
{
    return (command_size != RN_SIZE) && (command_size != RN_SIZE + 1);
}
