#include "io.h"
#include "system.h"
#include "stdint.h"
#include "helpers/commands/commands.h"
#include "sys/wait.h"
#include "stdio.h"
// REGISTER STATUS

#define BASE_IS_FIFO_FULL    (1<<1)
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
#define SENDER_HAS_GEN       1 << 5 // DURANTE PACOTE
#define SENDER_ENABLE_CTRL   1 << 6 // PULSE
#define SENDER_ENABLE_CTRL_0 0 << 6 // PULSE
#define SENDER_IS_PREAMBLE   1 << 7
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
#define MASK_EN_LOOPBACK    (1 << 3)
#define BASE_REG_STATUS     3
#define BASE_RECEIVER_DATA  4
#define BASE_RECEIVER_USEDW 6
#define BASE_ID             7
#define MASK_FINISH_SEND    (1 << 2)

// package defines
#define data_mask_size      6
#define data_package_size   26
#define eop                 0b00000000000000000000000000000000
#define bits26              0b11111111111111111111111111

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

void enable_loopback(){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_LOOPBACK);}
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
//void rfid_set_loopback(int EN_LOOPBACK){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, EN_LOOPBACK | MASK_EN | MASK_EN_RECEIVER);}




int  sender_check_fifo_full() { return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 3) & BASE_IS_FIFO_FULL; }
void sender_enable(){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_LOOPBACK | MASK_EN);}
void sender_send_package(int package) { IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, package); }
void sender_send_end_of_package() { IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, eop); }
void sender_Start_Ctrl(){
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN | SENDER_ENABLE_CTRL);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);}

void sender_write_clr_finished_sending(){
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 2, MASK_CLR_FINISHED);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 2, MASK_CLR_FINISHED_0);}
int sender_read_finished_send(){return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 2) & MASK_FINISH_SEND;}
void sender_mount_package(int command, int size)
{
    int remain_bits_to_send = size;
    int remain_package = command;
    int last_package_size = size % data_package_size;
    while (remain_bits_to_send > 0)
    {
        if (remain_bits_to_send > data_package_size)
        {

            int data_to_fifo = remain_package & bits26; // 26 bits, ive tried in hex but got an error might be the conversion
            remain_package = remain_package >> 0x1A;
            int32_t to_fifo = data_to_fifo << 6 | 0x1A;

            while (sender_check_fifo_full())
            {
            }

            sender_send_package(to_fifo);

            remain_bits_to_send = remain_bits_to_send - 0x1A;
        }
        else
        {
            int data_to_fifo = remain_package;
            remain_package = remain_package >> last_package_size;
            int32_t to_fifo = data_to_fifo << 6 | last_package_size;

            while (sender_check_fifo_full())
            {
            }

            sender_send_package(to_fifo);

            remain_bits_to_send = remain_bits_to_send - last_package_size;
        }


    }

    sender_send_end_of_package();
    sender_Start_Ctrl();
    while(!sender_read_finished_send()){
        }
    sender_write_clr_finished_sending();
}
void sender_select_package(int *commands, int size){
    for (int command = 0; command < size; command++)
    {
        // https://stackoverflow.com/questions/29388711/c-how-to-get-length-of-bits-of-a-variable
        unsigned command_size, var = (commands[command] < 0) ? commands[command] : commands[command];
        for (command_size = 0; var != 0; ++command_size)
            var >>= 1;
        sender_mount_package(commands[command], command_size);
    }
}



void sender_has_gen(int usesPreorFrameSync){if(usesPreorFrameSync){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_EN_RECEIVER | SENDER_HAS_GEN);}}

void sender_is_preamble(){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);}

void receiver_enable(){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2 , MASK_EN | MASK_LOOPBACK |MASK_EN_RECEIVER);}

int receiver_get_package(){return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_RECEIVER_DATA);}

int receiver_empty(){return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 3) & MASK_EMPTY_RECEIVER;}
    

int main()
{
	enable_loopback();
    rfid_set_tari(tari_test);
    sender_enable();
    //rfid_set_loopback(MASK_EN_LOOPBACK);
    receiver_enable();
    rfid_set_tari_bounderies(tari_101,tari_099,tari_1616,tari_1584,pw,delimiter,RTcal,TRcal);

    int commands[4];
    commands[0] = 0b110111111111111111111111111111; //32
    commands[1] = 0b101010101010101010101010101;
    commands[2] = 0b111100001111000011110000111;
    int commands_size = sizeof(commands) / sizeof(int);
    sender_has_gen(1);
    sender_is_preamble();

    while(1)
    	sender_send_package(0xFFFFFFF);


    sender_select_package(commands, commands_size);


    int data_received[10];
    int i = 0;
    while(!receiver_empty()){
        data_received[i] = receiver_get_package();
        printf("confirming pack received from IP %04X \n",IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_ID << 2));
        printf("	data received = %04X\n",data_received[i]);
        i++;

    }
    printf("End of Comunication with IP = %04X \n",IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_ID));
    return 0;
}
