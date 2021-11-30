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

#include "rn16.h"

void rn16_build(command *rn16)
{
    rn16->result_data = 0xFD24; // FIXME: implement real rng
    rn16->size = RN16_SIZE;
}

int rn16_validate(int command_size)
{
    if ((command_size != RN16_SIZE) && (command_size != RN16_SIZE + 1))
        return 0;
    return 1;
}
