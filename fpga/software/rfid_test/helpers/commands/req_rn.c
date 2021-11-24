#include "req_rn.h"

void req_rn_init(req_rn *req_rn, unsigned short rn)
{
    req_rn->command = REQ_RN_COMMAND;
    req_rn->size = REQ_RN_SIZE;

    req_rn->rn = rn;
    req_rn->result_data = 0;
}

void req_rn_build(req_rn *req_rn)
{
    req_rn->result_data = 0;

    req_rn->result_data |= (req_rn->command << 16);
    req_rn->result_data |= (req_rn->rn);
    req_rn->crc = crc_16_ccitt(req_rn->result_data, 3);
    req_rn->result_data <<= 16;
    req_rn->result_data |= req_rn->crc;
}

int req_rn_validate(int packages[], int command_size)
{
    if (command_size != REQ_RN_SIZE && command_size != REQ_RN_SIZE + 1)
        return 0;

    // |    packages[1]    | packages[0] |
    // |  command   |  rn  |  rn  |  crc |
    // |    X*8     | X*6  | X*10 | X*16 |
    int command = (packages[1] >> 6) & 0xFF;

    if (command != REQ_RN_COMMAND)
        return 0;

    int rn = (packages[0] >> 16) & 0xFFFF;
    int crc = packages[0] & 0xFFff;
    int crc_calc = crc_16_ccitt(rn, 3);

    if (crc != crc_calc)
        return 0;

    return 1;
}
