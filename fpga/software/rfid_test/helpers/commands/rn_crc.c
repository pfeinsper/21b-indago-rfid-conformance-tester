#include "rn_crc.h"

void rn_crc_generate(rn_crc *rn_crc_ptr)
{
    int rn = 0xFD24;
    int crc = crc_16_ccitt(rn, 3);
    rn_crc_ptr->result_data = (rn << 16) | crc;
    rn_crc_ptr->size = RN_CRC_SIZE;
}

int rn_crc_validate(int packages[], int command_size)
{
    if (command_size != RN_CRC_SIZE && command_size != RN_CRC_SIZE + 1)
        return 0;

    // | packages[1] | packages[0] |
    // |     rn      |  rn  |  crc |
    // |     X*6     | X*10 | X*16 |

    int rn = ((packages[1] & 0x3F) << 10) | (packages[0] >> 16) & 0x3FF;
    int crc = packages[0] & 0xFFFF;
    int crc_calc = crc_16_ccitt(rn, 3);

    if (crc != crc_calc)
        return 0;

    return 1;
}
