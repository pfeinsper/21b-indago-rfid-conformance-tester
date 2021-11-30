// -----------------------------------------
// --               READER                --
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
    printf("==          READER          ==\n");
    printf("==============================\n");

    // HANDSHAKE EXAMPLE READER -----------------------------------------------------------------------
    // SEND A QUERY ----------------------------------------------------------------------------------

    unsigned char dr = 1;
    unsigned char m = 1;
    unsigned char trext = 1;
    unsigned char sel = 1;
    unsigned char session = 1;
    unsigned char target = 1;
    unsigned char q = 1;

    command query;
    query_build(&query, dr, m, trext, sel, session, target, q);
    printf("sending query\n");
    sender_send_command(&query);
    printf("sent query\n\n");

    //WAIT A RANDOM NUMBER-------------------------------------------------------------------------------------------------------
    int quant_packages = 1;
    int command_size_rn = 0;
    int pack_rn[quant_packages];
    printf("waiting for random number\n");
    if (receiver_get_package(pack_rn, quant_packages, &command_size_rn) == -1)
    {
        printf("exiting on RN16\n");
        return 1;
    }
    int label = rfid_check_command(pack_rn, command_size_rn);
    // printf("label is: %d\n", label);
    if (label != RN16_LABEL)
    {
        printf("RN16_LABEL NOT FOUND\n");
        printf("found: %d\n", label);
        return 1;
    }
    printf("found RN16_LABEL\n");
    int RN16 = pack_rn[0] & 0xFF;
    printf("RN16 is: %X\n\n", RN16);

    // SEND AN ACK ------------------------------------------------------------------------------
    command ack;
    ack_build(&ack, RN16);
    printf("sending ack\n");
    sender_send_command(&ack);
    printf("sent ack\n\n");

    //RECEIVER-------------------------------------------------------------------------------------------------------
    //expecting a PC/XPC, EPC

    quant_packages = 2;
    int command_size_rn_crc = 0;
    int pack_rn_crc[quant_packages];
    printf("waiting for PC/XPC, EPC\n");
    if (receiver_get_package(pack_rn_crc, quant_packages, &command_size_rn_crc) == -1)
    {
        printf("exiting on PC/XPC, EPC\n");
        return 1;
    }
    label = rfid_check_command(pack_rn_crc, command_size_rn_crc);
    if (label != RN_CRC_LABEL)
    {
        printf("RN_CRC_LABEL NOT FOUND\n");
        printf("found: %d\n", label);
        return 1;
    }

    printf("found RN_CRC_LABEL\n\n");

    //req_rn------------------------------------------------------
    command req_rn;
    req_rn_build(&req_rn, RN16);

    printf("sending req_rn\n");
    sender_send_command(&req_rn);
    printf("sent req_rn\n\n");

    //RECEIVER-------------------------------------------------------------------------------------------------------
    quant_packages = 2;
    int command_size_handle = 0;
    int pack_handle[quant_packages];
    printf("waiting for PC/XPC, EPC\n");
    if (receiver_get_package(pack_handle, quant_packages, &command_size_handle) == -1)
    {
        printf("exiting on PC/XPC, EPC\n");
        return 1;
    }
    label = rfid_check_command(pack_handle, command_size_handle);
    if (label != RN_CRC_LABEL)
    {
        printf("RN_CRC_LABEL NOT FOUND\n");
        printf("found: %d\n", label);
        return 1;
    }

    printf("found RN_CRC_LABEL\n\n");
    int handle = ((pack_handle[1] & 0x3F) << 10) | ((pack_handle[0] >> 16) & 0x3FF);
    printf("handle is: %X\n", handle);

    printf("End of Communication with IP = %04X \n", rfid_get_ip_id());
    return 0;
}
