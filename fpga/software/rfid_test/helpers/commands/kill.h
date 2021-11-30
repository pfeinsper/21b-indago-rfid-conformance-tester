// -----------------------------------------
// --                KILL                 --
// -- Projeto Final de Engenharia         --
// -- Professor Orientador: Rafael Corsi  --
// -- Orientador: Shephard                --
// -- Alunos:                             --
// -- 		Alexandre Edington            --
// -- 		Bruno Domingues               --
// -- 		Lucas Leal                    --
// -- 		Rafael Santos                 --
// -----------------------------------------

#ifndef KILL_H
#define KILL_H

#define KILL_COMMAND 0b11000100
#define KILL_SIZE 59

#include "command_struct.h"

void kill_build(command *kill, unsigned short password, unsigned char rfu,
                unsigned short rn, unsigned short crc);

int kill_validate(int packages[], int command_size);

#endif /* KILL_H */
