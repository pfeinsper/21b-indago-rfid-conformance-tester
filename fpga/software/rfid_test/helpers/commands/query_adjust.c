#include "query_adjust.h"

void query_adjust_init(query_adjust *query_adjust, unsigned char session,
                       unsigned char updn)
{
    query_adjust->command = QUERY_ADJUST_COMMAND;
    query_adjust->size = QUERY_ADJUST_SIZE;

    query_adjust->session = session;
    query_adjust->updn = updn;
}

int query_adjust_command(query_adjust *query_adjust)
{
    query_adjust->result_data = 0;

    query_adjust->result_data |= (query_adjust->command << 5);
    query_adjust->result_data |= (query_adjust->session << 3);
    query_adjust->result_data |= query_adjust->updn;
}

int query_validate(int packages[], int quant_packages, int command_size)
{
    if (command_size != QUERY_ADJUST_SIZE && command_size != QUERY_ADJUST_SIZE + 1)
        return 0;

    // |       packages[0]        |
    // | command | session | UpDn |
    // |   X*4   |   X*2   | X*3  |

    int command = (packages[0] >> 5) & 0xF;

    if (command != QUERY_ADJUST_COMMAND)
        return 0;

    return 1;
}
