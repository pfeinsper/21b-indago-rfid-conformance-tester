// -----------------------------------------
// --               REQ RN                --
// -- Projeto Final de Engenharia         --
// -- Professor Orientador: Rafael Corsi  --
// -- Orientador: Shephard                --
// -- Alunos:                             --
// -- 		Alexandre Edington            --
// -- 		Bruno Domingues               --
// -- 		Lucas Leal                    --
// -- 		Rafael Santos                 --
// -----------------------------------------

#include "req_rn.h"

void req_rn_build(command *req_rn_ptr, int rn)
{
    long long without_crc = ((REQ_RN_COMMAND & 0xFF) << 16) | (rn & 0xFFFF);
    const int crc = crc_16_ccitt(without_crc, 3);
    without_crc = without_crc << 16;
    req_rn_ptr->result_data = without_crc | crc;
    req_rn_ptr->size = REQ_RN_SIZE;
}

int req_rn_validate(int packages[], int command_size)
{
    if (command_size != REQ_RN_SIZE && command_size != REQ_RN_SIZE + 1)
        return 0;

    // |    packages[1]    | packages[0] |
    // |  command   |  rn  |  rn  |  crc |
    // |    X*8     | X*6  | X*10 | X*16 |
    const int command = (packages[1] >> 6) & 0xFF;
    if (command != REQ_RN_COMMAND)
        return 0;

    const int rn = (packages[0] >> 16) & 0xFFFF;

    const int without_crc = (command << 16) | (rn & 0xFFFF);

    const int crc = packages[0] & 0xFFFF;
    const int crc_calc = crc_16_ccitt(without_crc, 3);

    if (crc != crc_calc)
        return 0;

    return 1;
}
