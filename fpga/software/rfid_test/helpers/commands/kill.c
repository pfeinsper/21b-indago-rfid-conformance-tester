// -----------------------------------------
// --                KILL                 --
// -- Projeto Final de Engenharia         --
// -- Professor Orientador: Rafael Corsi  --
// -- Orientador: Shephard                --
// -- Alunos:                             --
// -- 		Alexandre Edington            --
// -- 		Bruno Domingues               --
// -- 		Lucas Leal                    --
// -- 		Rafael Santos                 --
// -----------------------------------------

#include "kill.h"

void kill_build(command *kill, unsigned short password, unsigned char rfu,
                unsigned short rn, unsigned short crc)
{
    kill->result_data = 0;

    kill->result_data |= (KILL_COMMAND << 51);
    kill->result_data |= (password << 35);
    kill->result_data |= (rfu << 32);
    kill->result_data |= (rn << 16);
    kill->result_data |= crc;

    kill->size = KILL_SIZE;
}

int kill_validate(int packages[], int command_size)
{
    if (command_size != KILL_SIZE && command_size != KILL_SIZE + 1)
        return 0;

    // | packages[2] |            packages[1]           | packages[0] |
    // |   command   | command |   password | rfu | rn  |  rn  | crc  |
    // |     X*7     |    X    |    X*16    | X*3 | X*6 | X*10 | X*16 |

    int command = ((packages[2] & 0xEF) << 1) | ((packages[1] >> 25) & 0x01);

    if (command != KILL_COMMAND)
        return 0;

    int crc = packages[0] & 0xFFFF;

    // FIXME: check crc

    // long without_crc = ((packages[2] & 0xEF) << 26) | (packages[1] << 16) | ((packages[0] >> 16) & 0x3FF);
    // int crc_calculated = crc_16_ccitt(without_crc, sizeof(without_crc));

    return 1;
}
