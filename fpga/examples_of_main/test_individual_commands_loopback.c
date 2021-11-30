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
	int tari_100  = rfid_tari_2_clock(10e-6, FREQUENCY);
	int pw        = rfid_tari_2_clock(5e-6, FREQUENCY);
	int delimiter = rfid_tari_2_clock(62.5e-6, FREQUENCY);
	int RTcal     = rfid_tari_2_clock(135e-6, FREQUENCY);
	int TRcal     = rfid_tari_2_clock(135e-6, FREQUENCY);
    //configurations------------------------------------------------------------------------------
    rfid_set_loopback();
    rfid_set_tari(tari_100);
    sender_enable();

    receiver_enable();
    rfid_set_tari_boundaries(tari_100 * 1.01, tari_100 * 0.99, tari_100 * 1.616, tari_100 * 1.584, pw, delimiter, RTcal, TRcal);
    sender_has_gen(0);
    //sender_is_preamble(); // NOTE: enable this function if implementing RFID tech

    // TEST SEND COMMAND ------------------------------------------------------------------------
    printf("==============================\n");
    printf("==       TEST COMMAND       ==\n");
    printf("==============================\n");

    const unsigned char dr = 1;
    const unsigned char m = 1;
    const unsigned char trext = 1;
    const unsigned char sel = 1;
    const unsigned char session = 1;
    const unsigned char target = 1;
    const unsigned char q = 1;

    command command_ptr;

    query_build(&command_ptr, dr, m, trext, sel, session, target, q);

    // rn16_build(&command_ptr);

    // ack_build(&command_ptr, 0x1234);

    // rn_crc_build(&command_ptr, 0x1234);

    // req_rn_build(&command_ptr, 0x1234);
    
    sender_send_command(&command_ptr);

    printf("command sent\n\n");

    // WAIT A COMMAND FROM RECEIVER -------------------------------------------------------------
    int quant_packages = 3;
    int command_size = 0;
    int packages[quant_packages];
    printf("waiting for packages\n");
    if (receiver_get_package(packages, quant_packages, &command_size) == -1)
    {
        printf("exiting on receiver\n");
        return 1;
    }
    printf("command_size: %d\n", command_size);
    int label = rfid_check_command(packages, command_size);
    printf("label is: %d\n\n", label);

    return 0;
}
