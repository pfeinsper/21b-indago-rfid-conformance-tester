#include "req_rn.h"

void req_rn_init(req_rn *req_rn, unsigned short rn)
{
    req_rn->command = REQ_RN_COMMAND;
    req_rn->size = REQ_RN_SIZE;

    req_rn->rn = rn;
    req_rn->result_data = 0;
}

void req_rn_build(req_rn *req_rn)
{
    req_rn->result_data = 0;

    req_rn->result_data |= (req_rn->command << 16);
    req_rn->result_data |= (req_rn->rn);
    req_rn->crc = crc_16_ccitt(req_rn->result_data, 3);
    req_rn->result_data <<= 16;
    req_rn->result_data |= req_rn->crc;
}

int req_rn_validate(int *packages, int size, int command_size)
{
    if (command_size != REQ_RN_SIZE && command_size != REQ_RN_SIZE + 1){
        return 0;
    }
    printf("req_rn size: %d\n", command_size);

    printf("a: ");
    for(int i = 0; i < size; i++)
    {
        printf("%X ", packages[i]);
    }
    printf("\n");
    return 1;

    // if (((*command >> 32) & 0b11111111) != REQ_RN_COMMAND)
    // {
    //     return 0;
    // }
    // else if (command_size != REQ_RN_SIZE)
    // {
    //     return 0;
    // }
    // int rr = crc_16_ccitt((*command >> 16), 3);
    // if (rr == (*command & 0xFFFF))
    // {
    //     return 1;
    // }
    // return 0;
}
