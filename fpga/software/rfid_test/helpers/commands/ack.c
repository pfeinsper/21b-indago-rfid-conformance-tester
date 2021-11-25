#include "ack.h"

void ack_build(command *ack, int rn)
{
    ack->result_data = ((ACK_COMMAND & 0b11) << 16) | (rn & 0xFFFF);
    ack->size = ACK_SIZE;
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
