#include "nak.h"

void nak_build(command *nak)
{
    nak->result_data = NAK_COMMAND;
    nak->size = NAK_SIZE;
}

int nak_validate(int *packages, int command_size)
{
    if (command_size != NAK_SIZE && command_size != NAK_SIZE + 1)
        return 0;

    // | packages[0] |
    // |   command   |
    // |     X*8     |

    int command = packages[0] & 0xFF;
    if (command != NAK_COMMAND)
        return 0;

    return 1;
}
