// -----------------------------------------
// --                LOCK                 --
// -- Projeto Final de Engenharia         --
// -- Professor Orientador: Rafael Corsi  --
// -- Orientador: Shephard                --
// -- Alunos:                             --
// -- 		Alexandre Edington            --
// -- 		Bruno Domingues               --
// -- 		Lucas Leal                    --
// -- 		Rafael Santos                 --
// -----------------------------------------
#include "lock.h"

void lock_build(command *lock, unsigned int payload, unsigned short rn,
                unsigned short crc)
{
    lock->result_data = 0;

    lock->result_data |= (LOCK_COMMAND << 52);
    lock->result_data |= (payload << 32);
    lock->result_data |= (rn << 16);
    lock->result_data |= crc;

    lock->size = LOCK_SIZE;
}

int lock_validate(int packages_vector[], int command_size)
{
    //TODO: validate

    return 0;
}
