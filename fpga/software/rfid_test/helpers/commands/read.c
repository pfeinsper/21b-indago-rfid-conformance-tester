// -----------------------------------------
// --                READ                 --
// -- Projeto Final de Engenharia         --
// -- Professor Orientador: Rafael Corsi  --
// -- Orientador: Shephard                --
// -- Alunos:                             --
// -- 		Alexandre Edington            --
// -- 		Bruno Domingues               --
// -- 		Lucas Leal                    --
// -- 		Rafael Santos                 --
// -----------------------------------------

#include "read.h"

void read_build(command *read, unsigned char mem_bank, unsigned char word_ptr,
                unsigned char word_count, unsigned short rn, unsigned short crc)
{
    read->result_data = 0;

    read->result_data |= (READ_COMMAND << 49);
    read->result_data |= (mem_bank << 47);
    read->result_data |= (word_ptr << 39);
    read->result_data |= (word_count << 32);
    read->result_data |= (rn << 16);
    read->result_data |= crc;

    read->size = READ_SIZE;
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
