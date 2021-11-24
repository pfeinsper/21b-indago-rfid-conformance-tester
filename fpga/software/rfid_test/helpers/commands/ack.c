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

int ack_validate(int packages[], int command_size)
{
    if (command_size != ACK_SIZE && command_size != ACK_SIZE + 1)
        return 0;

    // |       packages[0]      |
    // |  command  |  rn/randle  |
    // |    X*2    |     X*16    |

    int command = (packages[0] >> 16) & 0b11;
    if (command != ACK_COMMAND)
        return 0;

    return 1;
}
