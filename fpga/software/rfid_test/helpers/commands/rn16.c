#include "rn16.h"

void rn16_init(rn16 *rn16_ptr)
{
    rn16_ptr->result_data = 0xFD24;
    rn16_ptr->size = RN16_SIZE;
}

int rn16_validate(int command_size)
{
    return (command_size != RN16_SIZE) && (command_size != RN16_SIZE + 1);
}
