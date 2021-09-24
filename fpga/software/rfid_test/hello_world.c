#include "io.h"
#include "system.h"
#include "stdint.h"
#include "helpers/commands/commands.h"
#include "sys/wait.h"
#define MASK_RST (1 << 0)
#define MASK_EN (1 << 1)
#define MASK_CLR_FIFO 1 << 2
#define BASE_REG_SET 0
#define BASE_REG_TARI 1
#define BASE_REG_FIFO 2
#define BASE_REG_STATUS 3
#define BASE_ID 7
#define PACKET_STD_SIZE 12
#define data_package_size 26
#define data_mask_size 6

int tari_test = 0b111110100;
ack command_ack;

int check_fifo_full(){return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE,BASE_REG_STATUS<<3) & 1;}

void send_package(int package){IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, package);}

//int select_package(int commands[], int n ){} // TODO

void mount_package(int command, int size)
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

            while(check_fifo_full()){}

            send_package(to_fifo);

            remain_bits_to_send = remain_bits_to_send - 0x1A;
        }
        else
        {
            int data_to_fifo = remain_package;
            remain_package = remain_package >> last_package_size;
            int32_t to_fifo = data_to_fifo << 6 | last_package_size;

            while(check_fifo_full()){}

            send_package(to_fifo);
            remain_bits_to_send = remain_bits_to_send - last_package_size;
        }
    }
}

int main()
{
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI << 2, tari_test);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN);
    ack_init(&command_ack, 1234);
    ack_build(&command_ack);
    //mount_package(command_ack.result_data, command_ack.size);
    mount_package(0b1111111111111111, 16);
    return 0;
}
