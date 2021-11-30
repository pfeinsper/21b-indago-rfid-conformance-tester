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

#ifndef QUERY_H
#define QUERY_H

#include "../config.h"
#include "../crc.h"
#include "command_struct.h"

#define QUERY_COMMAND 0b1000
#define QUERY_SIZE 22

void query_build(command *query, unsigned char dr, unsigned char m,
                 unsigned char trext, unsigned char sel, unsigned char session,
                 unsigned char target, unsigned char q);

int query_validate(int packages[], int command_size);

#endif /* QUERY_H */
