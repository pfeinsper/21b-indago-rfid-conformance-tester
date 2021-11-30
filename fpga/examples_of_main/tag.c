// -----------------------------------------
// --                TAG                  --
// -- Projeto Final de Engenharia         --
// -- Professor Orientador: Rafael Corsi  --
// -- Orientador: Shephard                --
// -- Alunos:                             --
// -- 		Alexandre Edington            --
// -- 		Bruno Domingues               --
// -- 		Lucas Leal                    --
// -- 		Rafael Santos                 --
// -----------------------------------------

#include "io.h"
#include "system.h"
#include "stdint.h"
#include "helpers/commands/commands.h"
#include "helpers/functions/functions.h"
#include "stdio.h"
#include "helpers/config.h"

int main()
{
    // Time parameters
    int tari_100 = rfid_tari_2_clock(10e-6, FREQUENCY);
    int pw = rfid_tari_2_clock(5e-6, FREQUENCY);
    int delimiter = rfid_tari_2_clock(62.5e-6, FREQUENCY);
    int RTcal = rfid_tari_2_clock(135e-6, FREQUENCY);
    int TRcal = rfid_tari_2_clock(135e-6, FREQUENCY);
    //configurations------------------------------------------------------------------------------
    rfid_set_loopback();
    rfid_set_tari(tari_100);
    sender_enable();

    receiver_enable();
    rfid_set_tari_boundaries(tari_100 * 1.01, tari_100 * 0.99, tari_100 * 1.616, tari_100 * 1.584, pw, delimiter, RTcal, TRcal);
    sender_has_gen(0);
    //sender_is_preamble(); // NOTE: enable this function if implementing RFID tech

    printf("IP connected ID is: %04X , also starting handshake\n", rfid_get_ip_id());
    printf("==============================\n");
    printf("==           TAG            ==\n");
    printf("==============================\n");

    // HANDSHAKE EXAMPLE TAG -----------------------------------------------------------------------
    // WAIT A QUERY --------------------------------------------------------------------------------
    int quant_packages = 2;
    int command_size_rn = 0;
    int pack_query[quant_packages];
    printf("waiting for query\n");
    if (receiver_get_package(pack_query, quant_packages, &command_size_rn) == -1)
    {
        printf("exiting on RN16\n");
        return 1;
    }
    int label = rfid_check_command(pack_query, command_size_rn);

    if (label != QUERY_LABEL)
    {
        printf("QUERY_LABEL NOT FOUND\n");
        printf("found: %d\n", label);
        return 1;
    }
    printf("found QUERY_LABEL\n\n");

    // SEND AN RN16 ----------------------------------------------------------------------------------
    command rn16;
    rn16_build(&rn16);
    printf("sending RN16\n");
    sender_send_command(&rn16);
    printf("sent RN16\n\n");

    //RECEIVER-------------------------------------------------------------------------------------------------------
    //expecting a ack(RN16)

    quant_packages = 2;
    int command_size_ack = 0;
    int pack_ack[quant_packages];
    printf("waiting for ack(RN16)\n");
    if (receiver_get_package(pack_ack, quant_packages, &command_size_ack) == -1)
    {
        printf("exiting on ack(RN16)\n");
        return 1;
    }
    label = rfid_check_command(pack_ack, command_size_ack);
    if (label != ACK_LABEL)
    {
        printf("ACK_LABEL NOT FOUND\n");
        printf("found: %d\n", label);
        return 1;
    }

    printf("found ACK_LABEL\n\n");

    //PC/XPC, EPC------------------------------------------------------
    command XPC;
    rn_crc_build(&XPC, 0x1234);
    printf("sending PC/XPC, EPC");
    sender_send_command(&XPC);
    printf("sent PC/XPC, EPC\n\n");

    //RECEIVER-------------------------------------------------------------------------------------------------------
    //expecting a req_rn
    quant_packages = 2;
    int command_size_handle = 0;
    int pack_req_rn[quant_packages];
    printf("waiting for req_rn\n");
    if (receiver_get_package(pack_req_rn, quant_packages, &command_size_handle) == -1)
    {
        printf("exiting on req_rn\n");
        return 1;
    }
    label = rfid_check_command(pack_req_rn, command_size_handle);
    if (label != REQ_RN_LABEL)
    {
        printf("REQ_RN_LABEL NOT FOUND\n");
        printf("found: %d\n", label);
        return 1;
    }

    printf("found REQ_RN_LABEL\n\n");

    // REQ_RN_RESPONSE-------------------------------------------------------------------------------------------------------
    command req_rn_resp;
    int handle = 0x7813;
    rn_crc_build(&req_rn_resp, handle);
    printf("sending handle\n");
    sender_send_command(&req_rn_resp);
    printf("sent handle\n\n");

    printf("End of Communication with IP = %04X \n", rfid_get_ip_id());
    return 0;
}
