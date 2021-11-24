#include "read.h"

void read_init(read *read, unsigned char mem_bank, unsigned char word_ptr,
               unsigned char word_count, unsigned short rn, unsigned short crc)
{
    read->command = READ_COMMAND;
    read->size = READ_SIZE;

    read->mem_bank = mem_bank;
    read->word_ptr = word_ptr;
    read->word_count = word_count;
    read->rn = rn;
    read->crc = crc;
}

void read_build(read *read)
{
    read->result_data = 0;

    read->result_data |= (read->command << 49);
    read->result_data |= (read->mem_bank << 47);
    read->result_data |= (read->word_ptr << 39);
    read->result_data |= (read->word_count << 32);
    read->result_data |= (read->rn << 16);
    read->result_data |= read->crc;
}

int read_validate(int packages[], int command_size)
{
    if (command_size != READ_SIZE && command_size != READ_SIZE + 1)
        return 0;

    // | packages[2] |                     packages[1]                   | packages[0]  |
    // | command     | command | mem_bank | word_ptr | word_count |  rn  |   rn  | crc  |
    // |   X*3       |   x*5   |    X*2   |   X*EBV  |     X*8    | X*6  |  X*10 | X*16 |

    int command = ((packages[2] & 0b111) << 5) | (packages[1] & 0x1F);

    if (command != READ_COMMAND)
        return 0;

    return 1;
}
