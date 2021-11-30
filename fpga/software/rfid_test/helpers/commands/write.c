// -----------------------------------------
// --               WRITE                 --
// -- Projeto Final de Engenharia         --
// -- Professor Orientador: Rafael Corsi  --
// -- Orientador: Shephard                --
// -- Alunos:                             --
// -- 		Alexandre Edington            --
// -- 		Bruno Domingues               --
// -- 		Lucas Leal                    --
// -- 		Rafael Santos                 --
// -----------------------------------------

#include "write.h"

void write_build(command *write, unsigned char mem_bank, unsigned char word_ptr,
                 unsigned short data, unsigned short rn, unsigned short crc)
{
    write->result_data = 0;

    write->result_data |= (WRITE_COMMAND << 49);
    write->result_data |= (mem_bank << 47);
    write->result_data |= (word_ptr << 39);
    write->result_data |= (data << 32);
    write->result_data |= (rn << 16);
    write->result_data |= crc;

    write->size = WRITE_SIZE;
}

int write_validate(int packages[], int command_size)
{
    if (command_size != WRITE_SIZE && command_size != WRITE_SIZE + 1)
        return 0;

    // |     packages[2]    |            packages[1]           | packages[0] |
    // | command | mem_bank | word_ptr | word_ptr | data | rn  | rn   | crc  |
    // |   X*8   |    X*2   | X*EBV(4) | X*EBV(4) | X*16 | X*6 | X*10 | X*16 |

    int command = (packages[2] >> 2) & 0xFF;

    if (command != WRITE_COMMAND)
        return 0;

    return 1;
}
