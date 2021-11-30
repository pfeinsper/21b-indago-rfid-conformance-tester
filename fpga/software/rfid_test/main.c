// -----------------------------------------
// --             HELLO WORLD             --
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

    printf("IP connected ID is: %04X \n", rfid_get_ip_id());
    printf("==============================\n");
    printf("==        Hello world       ==\n");
    printf("==============================\n");


    printf("End of Communication with IP = %04X \n", rfid_get_ip_id());
    return 0;
}
