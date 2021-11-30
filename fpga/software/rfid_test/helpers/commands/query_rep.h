// -----------------------------------------
// --              QUERY REP              --
// -- Projeto Final de Engenharia         --
// -- Professor Orientador: Rafael Corsi  --
// -- Orientador: Shephard                --
// -- Alunos:                             --
// -- 		Alexandre Edington            --
// -- 		Bruno Domingues               --
// -- 		Lucas Leal                    --
// -- 		Rafael Santos                 --
// -----------------------------------------

#ifndef QUERY_REP_H
#define QUERY_REP_H

#include "command_struct.h"

#define QUERY_REP_COMMAND 0b00
#define QUERY_REP_SIZE 4

void query_rep_build(command *query_rep, unsigned char session);

// int query_rep_parse(command *query_rep, unsigned char *data);

int query_rep_validate(int packages[], int command_size);

#endif /* QUERY_REP_H */
