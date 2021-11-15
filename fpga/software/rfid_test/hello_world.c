#include "io.h"
#include "system.h"
#include "stdint.h"
#include "helpers/commands/commands.h"
#include "sys/wait.h"
#include "stdio.h"

// REGISTER STATUS
#define BASE_IS_FIFO_FULL    (1 << 0)
#define MASK_EMPTY_RECEIVER  (1 << 13)

// REGISTER SETTINGS
#define BASE_REG_SET          0        // can be read in the same address
#define MASK_RST             (1 << 0)
#define MASK_EN              (1 << 1)
#define MASK_RST_RECEIVER    (1 << 10)
#define MASK_EN_RECEIVER     (1 << 4)
#define MASK_CLR_FIFO        (1 << 2)
#define MASK_LOOPBACK        (1 << 8)
#define MASK_CLR_FINISHED    1 << 1
#define MASK_CLR_FINISHED_0  0 << 1
#define SENDER_HAS_GEN       0 << 5 // DURANTE PACOTE
#define SENDER_ENABLE_CTRL   1 << 6 // PULSE
#define SENDER_ENABLE_CTRL_0 0 << 6 // PULSE
#define SENDER_IS_PREAMBLE   0 << 7

// RFID - WRITE
#define BASE_REG_TARI       1        // can be read in the same address 
#define BASE_REG_FIFO       2
#define BASE_REG_TARI_101   3
#define BASE_REG_TARI_099   4
#define BASE_REG_TARI_1616  5
#define BASE_REG_TARI_1584  6
#define BASE_REG_PW         7
#define BASE_REG_DELIMITER  8
#define BASE_REG_RTCAL      9
#define BASE_REG_TRCAL      10

// RFID - READ
#define BASE_REG_STATUS     3
#define BASE_RECEIVER_DATA  4
#define BASE_SENDER_USEDW      5
#define BASE_RECEIVER_USEDW 6
#define BASE_ID             7
#define MASK_FINISH_SEND    (1 << 3)

// package defines
#define data_mask_size      6
#define data_package_size   26
#define eop                 0b00000000000000000000000000000000
#define bits26              0b11111111111111111111111111
#define bits32              0b11111111111111111111111111111111

// tudo isso precisa virar input
int tari_test = 0x1f4;
int tari_101  = 0x1f9;
int	tari_099  = 0x1EF;
int tari_1616 = 0x328;
int tari_1584 = 0x318;
int pw        = 0xFA;
int delimiter = 0x271;
int RTcal     = 0x546;
int TRcal     = 0x546;



// RFID -----------------------------------------------------------------------------------------------------------
void rfid_set_loopback(){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_LOOPBACK);}

void rfid_set_tari(int tari_value){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI << 2, tari_value);}

void rfid_set_tari_bounderies(int tari_101, int tari_099, int tari_1616, int tari_1584, int pw, int delimiter, int RTcal, int TRcal){
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI_101 << 2, tari_101);
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI_099 << 2, tari_099);
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI_1616 << 2, tari_1616);
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI_1584 << 2, tari_1584);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_PW << 2, pw);
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_DELIMITER << 2, delimiter);
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_RTCAL << 2, RTcal);
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TRCAL << 2, TRcal);}
// SENDER -----------------------------------------------------------------------------------------------------------
int  sender_check_usedw() { return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE,  BASE_SENDER_USEDW <<2 );}

int  sender_check_fifo_full() { return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 2) & BASE_IS_FIFO_FULL; }

void sender_enable(){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_LOOPBACK | MASK_EN);}

void sender_send_package(int package) {
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, package);
	printf("sender_send_package %d \n", package);
}

void sender_send_end_of_package() { IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, eop); }

void sender_start_ctrl(){
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN | SENDER_ENABLE_CTRL);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);}

void sender_write_clr_finished_sending(){
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_CLR_FINISHED | MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_CLR_FINISHED_0 |MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);}

int sender_read_finished_send(){return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 2) & MASK_FINISH_SEND;}

void sender_add_mask(int n, int command_vector_masked[n],unsigned int result_data,unsigned int result_data_size){

    int last_package_size = result_data_size % data_package_size;
    int quant_packages = result_data/data_package_size + 1;

    for(int current_package = 0; current_package < quant_packages; current_package++){

        int quant_bits_this_package;
        if (current_package == quant_packages - 1){
            // case when we cant fill a package with 26 bits
            quant_bits_this_package = last_package_size;
        }
        else {
            // case when data is bigger thant 26 bits
            quant_bits_this_package = 0x1A;
        }

        // deviding package and adding mask to it
        int unmasked_package = result_data & bits26; // 26 bits
        int masked_package = unmasked_package << 6 | quant_bits_this_package;
        command_vector_masked[current_package] = masked_package;

        // shifting result_data to remove bits that are already treated
        result_data = result_data >> quant_bits_this_package;

    }
}

int sender_get_command_ints_size(int size_of_command){
		return (size_of_command/26)+1;
    }

void sender_has_gen(int usesPreorFrameSync){if(usesPreorFrameSync){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_EN_RECEIVER | SENDER_HAS_GEN);}}

void sender_is_preamble(){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);}

// RECEIVER -----------------------------------------------------------------------------------------------------------
void receiver_enable(){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2 , MASK_EN | MASK_LOOPBACK |MASK_EN_RECEIVER);}

int receiver_get_package(){return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_RECEIVER_DATA<<2);}

int receiver_empty(){return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 2) & MASK_EMPTY_RECEIVER;}
//-----------------------------------------------------------------------------------------------------------

int main()
{
    //configurations------------------------------------------------------------------------------
	rfid_set_loopback();
    rfid_set_tari(tari_test);
    sender_enable();
    
    receiver_enable();
    rfid_set_tari_bounderies(tari_101,tari_099,tari_1616,tari_1584,pw,delimiter,RTcal,TRcal);
    sender_has_gen(0);
    //sender_is_preamble();

    // SENDER ----------------------------------------------------------------------------------

    // //ack ------------------------------------------------------------------------------
    unsigned short rn = 1234;
    ack command_ack;
    ack_init(&command_ack, rn);
    ack_build(&command_ack);
    
    int size_with_mask = sender_get_command_ints_size(command_ack.size);

    int command_vector_masked[size_with_mask];

    // ADDING MASKS TO EACH PACKAGE OF THE COMMAND
    sender_add_mask(size_with_mask,command_vector_masked,command_ack.result_data, command_ack.size);

    // WAITING FOR FIFO AND THEN SENDING PACKAGES
    for (int i = 0; i < 1; i++)
    {
        while (sender_check_fifo_full()){}
        sender_send_package(command_vector_masked[i]);
    }
    //sender_send_package(command_ack.result_data);
    sender_send_end_of_package();

    sender_start_ctrl();

    while(!sender_read_finished_send()){}

    sender_write_clr_finished_sending();


    //RECEIVER-------------------------------------------------------------------------------------------------------
    printf("confirming pack received from IP %04X \n",IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_ID << 2));
    while(!receiver_empty()){
       printf("receiver is: %d\n", receiver_empty());
       int dado = receiver_get_package();
       printf("data received = %X\n", dado);
       break;
    }

    printf("End of Communication with IP = %04X \n",IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_ID));
    return 0;
}
