// -----------------------------------------
// --                QUERY                --
// -- Projeto Final de Engenharia         --
// -- Professor Orientador: Rafael Corsi  --
// -- Orientador: Shephard                --
// -- Alunos:                             --
// -- 		Alexandre Edington            --
// -- 		Bruno Domingues               --
// -- 		Lucas Leal                    --
// -- 		Rafael Santos                 --
// -----------------------------------------

#include "query.h"

void query_build(command *query, unsigned char dr, unsigned char m,
                 unsigned char trext, unsigned char sel, unsigned char session,
                 unsigned char target, unsigned char q)
{
    query->result_data = 0;

    query->result_data |= (QUERY_COMMAND << 13);
    query->result_data |= (dr << 12);
    query->result_data |= (m << 10);
    query->result_data |= (trext << 9);
    query->result_data |= (sel << 7);
    query->result_data |= (session << 5);
    query->result_data |= (target << 4);
    query->result_data |= q;

    const int crc = crc5(query->result_data);

    query->result_data <<= 5;
    query->result_data |= crc;

    query->size = QUERY_SIZE;
}

int query_validate(int packages[], int command_size)
{
    if (command_size != QUERY_SIZE && command_size != QUERY_SIZE + 1)
        return 0;

    // |                           packages[0]                           |
    // | command | dr |  m  | trext | sel | session | target |  q  | crc |
    // |   X*4   | X  | X*2 |   X   | X*2 |   X*2   |    X   | X*4 | X*5 |

    int command = (packages[0] >> 18) & 0xF;
    if (command != QUERY_COMMAND)
        return 0;

    int crc = packages[0] & 0x1F;
    int without_crc = packages[0] >> 5;
    int crc_calculated = crc5(without_crc);
    if (crc != crc_calculated)
        return 0;

    return 1;
}
