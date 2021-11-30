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

#ifndef QUERY_ADJUST_H
#define QUERY_ADJUST_H

#include "command_struct.h"

#define QUERY_ADJUST_COMMAND 0b1001
#define QUERY_ADJUST_SIZE 9

void query_adjust_build(command *query_adjust, unsigned char session,
                        unsigned char updn);

// int query_adjust_parse(command *query_adjust, unsigned char *data);

int query_adjust_validate(int packages[], int command_size);

#endif /* QUERY_ADJUST_H */
