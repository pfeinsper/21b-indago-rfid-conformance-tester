#include "query_rep.h"

void query_rep_init(query_rep *query_rep, unsigned char session)
{
    query_rep->command = QUERY_REP_COMMAND;
    query_rep->size = QUERY_REP_SIZE;

    query_rep->session = session;
}

void query_rep_build(query_rep *query_rep)
{
    query_rep->result_data = 0;

    query_rep->result_data |= (query_rep->command << 2);
    query_rep->result_data |= query_rep->session;
}

int query_rep_validate(int packages[], int command_size)
{
    if (command_size != QUERY_REP_SIZE && command_size != QUERY_REP_SIZE + 1)
        return 0;

    // |      packages[0]      |
    // |   command   | session |
    // |     X*2     |   X*2   |

    int command = (packages[0] >> 2) & 0x3;

    if (command != QUERY_REP_COMMAND)
        return 0;

    return 1;
}