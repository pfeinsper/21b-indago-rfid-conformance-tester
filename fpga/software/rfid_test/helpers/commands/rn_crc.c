#include "rn_crc.h"

unsigned short rn_crc_generate()
{
    int rn = 0xFD24;
    int crc = crc_16_ccitt(rn, 3);
    return rn << 16 | crc;
}

int rn_crc_validate(int packages[], int quant_packages, int command_size)
{
    if (command_size != REQ_RN_RESP_SIZE)
        return 0;

    // | packages[0] |
    // |  rn  |  crc |
    // | X*16 | X*16 |

    int rn = (packages[0] >> 16) & 0xFFFF;
    int crc = packages[0] & 0xFFff;
    int crc_calc = crc_16_ccitt(rn, 3);

    if (crc != crc_calc)
        return 0;

    return 1;
}
