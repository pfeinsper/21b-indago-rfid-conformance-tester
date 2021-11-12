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


// HANDSHAKE COMMANDS
// COMMAND QUERY
unsigned char dr = 1;
unsigned char m = 1;
unsigned char trext = 1;
unsigned char sel = 1;
unsigned char session = 1;
unsigned char target = 1;
unsigned char q = 1;

// query command_query;
// query_init(&command_query, dr, m, trext, sel, session, target, q);
// query_build(&command_query);

// COMMAND ACK

// COMMAND REQ RN
// req_rn command_req_rn;
// req_rn_init(&command_req_rn, rn);
// req_rn_build(&command_req_rn);


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

void *command_to_vector(int *command_vector, int *sizes ,long data, int size){

    int remain_bits_to_send = size;
    int remain_package = data;
    int last_package_size = size % 32;
    
    int i = 0;

    while (remain_bits_to_send > 0)
    {
        if (remain_bits_to_send > 32)
        {

            int data_to_vector = remain_package & bits32; // 26 bits, ive tried in hex but got an error might be the conversion
            

            command_vector[i] = data_to_vector;
            sizes[i] = 32;
            remain_bits_to_send = remain_bits_to_send - 0x20;
        }
        else
        {
            int data_to_vector = remain_package;
            

            command_vector[i] = data_to_vector;

            sizes[i] = last_package_size;
            remain_bits_to_send = remain_bits_to_send - last_package_size;
        }

        i++;
    }
    
}

void sender_send_end_of_package() { IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, eop); }

void sender_start_ctrl(){
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN | SENDER_ENABLE_CTRL);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);}

void sender_write_clr_finished_sending(){
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_CLR_FINISHED | MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_CLR_FINISHED_0 |MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);}

int sender_read_finished_send(){return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 2) & MASK_FINISH_SEND;}

void sender_add_mask(int *command_vector_masked, int command, int size){
    int remain_bits_to_send = size;
    int remain_package = command;
    int last_package_size = size % data_package_size;
    int i = 0;
    while (remain_bits_to_send > 0){
        if (remain_bits_to_send > data_package_size){

            int data_to_fifo = remain_package & bits26; // 26 bits, ive tried in hex but got an error might be the conversion
            remain_package = remain_package >> 0x1A;
            int32_t to_fifo = data_to_fifo << 6 | 0x1A;

            command_vector_masked[i] = to_fifo;
            remain_bits_to_send = remain_bits_to_send - 0x1A;
        }
        else{
            int data_to_fifo = remain_package;
            remain_package = remain_package >> last_package_size;
            int32_t to_fifo = data_to_fifo << 6 | last_package_size;

            command_vector_masked[i] = to_fifo;
            remain_bits_to_send = remain_bits_to_send - last_package_size;
        }
        i++;
    }    
}

int sender_get_masked_command_size(int *vector_of_sizes, int size){
        int add = 0;
        for (int i = 0; i < size; i++)
        {
            if(vector_of_sizes[i]>26){
                add++;
            }
        }
        return add;
    }

int sender_get_command_ints_size(int size_of_command){
        if (size_of_command < 32){return 1;}
        return 2;  
    }

void sender_has_gen(int usesPreorFrameSync){if(usesPreorFrameSync){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_EN_RECEIVER | SENDER_HAS_GEN);}}

void sender_is_preamble(){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);}

void sender_fm0_encoder(int command_data, int command_size){
        int size = sender_get_command_ints_size(command_size);
        int command_vector[size];
        int sizes[size];
        int commands_size = sizeof(command_vector) / sizeof(int);
        command_to_vector(&command_vector, &sizes,command_data,command_size);

        
        int new_ints = sender_get_masked_command_size(&sizes, size);
        int commands_masked_size = size+new_ints;
        int command_vector_masked[commands_masked_size];
        
        // ADDING MASKS TO EACH PACKAGE OF THE COMMAND
        for (int i = 0; i < commands_size; i++)
        {
            sender_add_mask(command_vector_masked, command_vector[i], sizes[i]);
            printf("command_vector[%d], sizes[%d] \n", command_vector[i], sizes[i]);
        }

        // WAITING FOR FIFO AND THEN SENDING PACKAGES
        for (int i = 0; i < commands_masked_size; i++)
        {
            while (sender_check_fifo_full()){}

            sender_send_package(command_vector_masked[i]);
            printf("command_vector_masked %d = %d \n", i,command_vector_masked[i]);
        }

        sender_send_end_of_package();

        sender_start_ctrl();

        while(!sender_read_finished_send()){}

        sender_write_clr_finished_sending();
    }

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

    // Handshake -------------------------------------------------------------------------------

    // SENDER ----------------------------------------------------------------------------------
    // query_rep
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
    sender_fm0_encoder(command_query.result_data,command_query.size);

    //ack ------------------------------------------------------------------------------
    unsigned short rn = 1234;
    ack command_ack;
    ack_init(&command_ack, rn);
    ack_build(&command_ack);
    sender_fm0_encoder(command_ack.result_data,command_ack.size);
    
    //req_rn------------------------------------------------------
    req_rn command_req_rn;
    req_rn_init(&command_req_rn, rn);
    req_rn_build(&command_req_rn);
    sender_fm0_encoder(command_req_rn.result_data,command_req_rn.size);

    //RECEIVER-------------------------------------------------------------------------------------------------------
    printf("confirming pack received from IP %04X \n",IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_ID << 2));
    while(!receiver_empty()){
       printf("receiver is: %d\n", receiver_empty());
       int dado = receiver_get_package();
       printf("data received = %X\n", dado);
       //break;
    }

    // printf("End of Communication with IP = %04X \n",IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_ID));
    return 0;
}
