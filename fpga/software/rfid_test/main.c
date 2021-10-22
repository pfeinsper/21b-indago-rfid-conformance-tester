#include "io.h"
#include "system.h"
#include "stdint.h"
#include "helpers/commands/commands.h"
#include "sys/wait.h"

#define MASK_RST (1 << 0)
#define MASK_EN (1 << 1)
#define MASK_RST_RECEIVER (1<< 10)
#define MASK_EN_RECEIVER (1<< 12)
#define MASK_EMPTY_RECEIVER (1<< 13)
#define BASE_IS_FIFO_FULL (1<<1)
#define MASK_CLR_FIFO 1 << 2
#define BASE_REG_SET 0
#define BASE_REG_TARI 1
#define BASE_REG_TARI_101 3
#define BASE_REG_TARI_099 4
#define BASE_REG_TARI_1616 5
#define BASE_REG_TARI_1584 6
#define BASE_REG_FIFO 2
#define BASE_REG_STATUS 3
#define BASE_RECEIVER_DATA 4
#define BASE_ID 7
#define PACKET_STD_SIZE 12
#define data_package_size 26
#define data_mask_size 6
#define eop 0b00000000000000000000000000000000

int tari_test = 0b0000000111110100;
int tari_101  = 0b0000000111111001;
int	tari_099  = 0b0000000111101111;
int tari_1616 = 0b0000001100101000;
int tari_1584 = 0b0000001100011000;

void rfid_set_tari(int tari_value){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI << 2, tari_value);}

void rfid_set_tari_bounderies(int tari_101, int tari_099, int tari_1616, int tari_1584)
{
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI_101 << 2, tari_101);
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI_099 << 2, tari_099);
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI_1616 << 2, tari_1616);
	IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI_1584 << 2, tari_1584);
}




int  sender_check_fifo_full() { return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 3) & BASE_IS_FIFO_FULL; }
void sender_enable(int EN){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, EN);}
void sender_send_package(int package) { IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, package); }
void sender_send_end_of_package() { IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, eop); }
void sender_mount_package(int command, int size)
{
    int remain_bits_to_send = size;
    int remain_package = command;
    int last_package_size = size % data_package_size;

    while (remain_bits_to_send > 0)
    {
        if (remain_bits_to_send > data_package_size)
        {
            int data_to_fifo = remain_package & 0x1A;
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
}
void sender_select_package(int *commands, int size)
{

    for (int command = 0; command < size; command++)
    {
        // https://stackoverflow.com/questions/29388711/c-how-to-get-length-of-bits-of-a-variable
        unsigned command_size, var = (commands[command] < 0) ? commands[command] : commands[command];
        for (command_size = 0; var != 0; ++command_size)
            var >>= 1;
        sender_mount_package(commands[command], command_size);
    }
}


//void receiver_enable(int EN){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, EN);}

int receiver_get_package(){
    return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_RECEIVER_DATA);
}

int receiver_empty(){
    return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 3) & MASK_EMPTY_RECEIVER;
}
    

int main()
{
    rfid_set_tari(tari_test);
    sender_enable(MASK_EN);

    rfid_set_tari_bounderies(tari_101,tari_099,tari_1616,tari_1584);
    //receiver_enable(MASK_EN_RECEIVER);
    int commands[4];
    commands[0] = 0b11111111111111111111111111111111; //32
    commands[1] = 0b00000000;                         //8
    commands[2] = 0b1111111111111111;                 //16
    commands[3] = 0b010101010101010101010101010101;   //30
    int commands_size = sizeof(commands) / sizeof(int);
    sender_select_package(commands, commands_size);



    int data_received[10];
    int i = 0;
    while(!receiver_empty()){
        data_received[i] = receiver_get_package();
        i++;

    }

    return 0;
}
