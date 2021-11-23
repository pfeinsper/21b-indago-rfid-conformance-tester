#include "ack.h"

void ack_init(ack *ack, unsigned short rn)
{
    ack->command = ACK_COMMAND;
    ack->size = ACK_SIZE;

    ack->rn = rn;
}

void ack_build(ack *ack)
{
    ack->result_data = 0;

    ack->result_data |= (ack->command << 16);
    ack->result_data |= ack->rn;
}

int ack_validate(int *packages, int quant_packages, int command_size)
{
    return 0;
    // if (((*packages >> 16) & 0b11) != ACK_COMMAND)
    // {
    //     return 0;
    // }
    // else if (command_size != ACK_SIZE)
    // {
    //     return 0;
    // }
    // return 1;
}
