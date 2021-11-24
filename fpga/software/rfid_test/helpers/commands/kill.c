#include "kill.h"

void kill_init(kill *kill, unsigned short password, unsigned char rfu,
               unsigned short rn, unsigned short crc)
{
    kill->command = KILL_COMMAND;
    kill->size = KILL_SIZE;

    kill->password = password;
    kill->rfu = rfu;
    kill->rn = rn;
    kill->crc = crc;
}

void kill_build(kill *kill)
{
    kill->result_data = 0;

    kill->result_data |= (kill->command << 51);
    kill->result_data |= (kill->password << 35);
    kill->result_data |= (kill->rfu << 32);
    kill->result_data |= (kill->rn << 16);
    kill->result_data |= kill->crc;
}

int kill_validate(int packages[], int quant_packages, int command_size)
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
