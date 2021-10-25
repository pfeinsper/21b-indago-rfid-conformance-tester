// Código de comunicação por Lucas Leal
#include "helpers/commands/query.c"
#include "helpers/commands/query_adjust.c"
#include "helpers/commands/query_rep.c"
#include "helpers/commands/ack.c"
#include "helpers/commands/req_rn.c"

int rfid_start_default_communication()
{
    // Este programa inicia uma comunicação com a Tag de acordo com o protocolo
    // nao faço ideia do que seja esses parametros nem pela doc
    unsigned char dr = 1;
    unsigned char m = 1;
    unsigned char trext = 1;
    unsigned char sel = 1;
    unsigned char session = 1;
    unsigned char target = 1;
    unsigned char q = 1;

    query command_query;
    query_init(&command_query, dr, m, trext, sel, session, target, q);
    query_build(&command_query);
    send_package(command_query, command_query.size);

    // WAIT FOR Tag responds with RN16

    unsigned short rn = 1234;
    ack command_ack;
    ack_init(&command_ack, rn);
    ack_build(&command_ack);
    send_package(command_ack, command_ack.size);

    // WAIT FOR: Valid RN16: Tag responds with {PC/XPC, EPC}
    //           Invalid RN16: No reply

    req_rn command_req_rn;
    req_rn_init(&command_req_rn, rn);
    req_rn_build(&command_req_rn);
    send_package(command_req_rn, command_req_rn.size);

    // receiver wait for: Valid RN16: Tag responds with {handle}
    //                    Invalid RN16: No reply

    if (tag_respose)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

void rfid_start_test()
{
    // This function is used to choose manually the disered test
    int commands[4];
    commands[0] = 0b11111111111111111111111111111111; // 32
    commands[1] = 0b00000000;                         // 8
    commands[2] = 0b1111111111111111;                 // 16
    commands[3] = 0b010101010101010101010101010101;   // 30
    int commands_size = sizeof(commands) / sizeof(int);
    sender_send_package(commands, commands_size);
}

int main()
{

    while (1)
    {
        if (rfid_start_default_communication())
        {
            // Test the tag and stores its data or even edit it inside rfid_start_test
            rfid_start_test();
            break;
        }
    }
}//main