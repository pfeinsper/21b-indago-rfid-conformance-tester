// -----------------------------------------
// --                RN16                 --
// -- Projeto Final de Engenharia         --
// -- Professor Orientador: Rafael Corsi  --
// -- Orientador: Shephard                --
// -- Alunos:                             --
// -- 		Alexandre Edington            --
// -- 		Bruno Domingues               --
// -- 		Lucas Leal                    --
// -- 		Rafael Santos                 --
// -----------------------------------------

#ifndef RN16_H
#define RN16_H

#include "command_struct.h"

#define RN16_SIZE 16

void rn16_build(command *rn16_ptr);

int rn16_validate(int command_size);

#endif /* RN16_H */
