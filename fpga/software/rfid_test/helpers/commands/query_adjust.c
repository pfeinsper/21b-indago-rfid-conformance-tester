// -----------------------------------------
// --            QUERY ADJUST             --
// -- Projeto Final de Engenharia         --
// -- Professor Orientador: Rafael Corsi  --
// -- Orientador: Shephard                --
// -- Alunos:                             --
// -- 		Alexandre Edington            --
// -- 		Bruno Domingues               --
// -- 		Lucas Leal                    --
// -- 		Rafael Santos                 --
// -----------------------------------------

#include "query_adjust.h"

int query_adjust_command(command *query_adjust, unsigned char session,
                         unsigned char updn)
{
    query_adjust->result_data = 0;

    query_adjust->result_data |= (QUERY_ADJUST_COMMAND << 5);
    query_adjust->result_data |= (session << 3);
    query_adjust->result_data |= updn;

    query_adjust->size = QUERY_ADJUST_SIZE;
}

int query_adjust_validate(int packages[], int command_size)
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
