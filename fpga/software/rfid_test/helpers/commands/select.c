#include "select.h"


void select_build(command *select, unsigned char target, unsigned char action,
                 unsigned char mem_bank, unsigned char pointer,
                 unsigned char length, unsigned char mask,
                 unsigned char truncate, unsigned short crc)
{
    select->result_data = 0;

    select->result_data |= (SELECT_COMMAND << 40);
    select->result_data |= (target << 37);
    select->result_data |= (action << 34);
    select->result_data |= (mem_bank << 32);
    select->result_data |= (pointer << 24);
    select->result_data |= (length << 16);
    select->result_data |= (mask << 2);
    select->result_data |= (truncate << 2);
    select->result_data |= crc;

    select->size = SELECT_SIZE;

}

int select_validate(int packages[], int command_size)
{
    if (command_size < SELECT_SIZE)
        return 0;

    // | command | target | action | mem_bank | pointer | length | mask | truncate | crc  |
    // |   X*4   |   X*3  |   X*3  |    X*2   |  X*EBV  |   X*8  |  X*? |    X*1   | X*16 |

    // TODO: implement select_validate

    return 0;
}
