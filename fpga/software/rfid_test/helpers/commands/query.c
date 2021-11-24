#include "query.h"

void query_init(query *query, unsigned char dr, unsigned char m,
                unsigned char trext, unsigned char sel, unsigned char session,
                unsigned char target, unsigned char q)
{
    query->command = QUERY_COMMAND;
    query->size = QUERY_SIZE;
    query->dr = dr;
    query->m = m;
    query->trext = trext;
    query->sel = sel;
    query->session = session;
    query->target = target;
    query->q = q;
}

void query_build(query *query)
{
    query->result_data = 0;

    query->result_data |= (query->command << 13);
    query->result_data |= (query->dr << 12);
    query->result_data |= (query->m << 10);
    query->result_data |= (query->trext << 9);
    query->result_data |= (query->sel << 7);
    query->result_data |= (query->session << 5);
    query->result_data |= (query->target << 4);
    query->result_data |= query->q;

    query->crc = crc5(query->result_data);

    query->result_data <<= 5;
    query->result_data |= (query->crc);
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
