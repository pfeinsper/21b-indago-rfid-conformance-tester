#include "io.h"
#include "system.h"
#include "stdint.h"
#include "helpers/commands/commands.h"
#define MASK_RST (1 << 0)
#define MASK_EN (1 << 1)
#define MASK_CLR_FIFO 1 << 2
#define BASE_REG_SET 0
#define BASE_REG_TARI 1
#define BASE_REG_FIFO 2
#define BASE_ID 7
#define PACKET_STD_SIZE 12
#define data_package 8
// int package_ack = 0b101101011000;
int tari_test = 0b111110100;

ack command_ack;
unsigned int int_to_int(unsigned int k)
{
  return (k == 0 || k == 1 ? k : ((k % 2) + 10 * int_to_int(k / 2)));
}
void send_package(int pacote, int size)
{
  int remain_bits_to_send = size;
  int remain_package = pacote;
  int last_package_size = size % data_package;
  if (remain_bits_to_send > data_package)
  {
    //int iter = size / 16;
    
    // to_fifo exemple: xxxx dddd dddd mmmm xxxx dddd dddd mmmm
    //int bits_send = 0;
    //for (int i = 0; i < iter; i++)
    while(remain_bits_to_send >= 0)
    {

        if (remain_bits_to_send > data_package && remain_bits_to_send < 16)
        {
          int to_fifo0 = remain_package &  0b11111111;
          //int32_t to_fifo0 = sliced_package & 0xFFFF;
          remain_package = remain_package >> 8;
          int sliced_package2 = remain_package >> last_package_size;
          int mask_package = int_to_int(last_package_size);
          int32_t to_fifo1 = sliced_package2 & 0xFFFF;
          remain_package = remain_package >>last_package_size ;
          int32_t to_fifo2 = (to_fifo0 << data_package) | to_fifo1;
          int32_t command_new_mask = 0b00001111111110000000111111110000 | mask_package;
          to_fifo2 = to_fifo2 & command_new_mask;
          remain_bits_to_send -= (data_package + last_package_size);
          
          IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, to_fifo2);
        }
        else if (remain_bits_to_send > 0 && remain_bits_to_send < data_package)
        {
          int sliced_package = remain_package >> last_package_size;
          remain_package = remain_package >>last_package_size ;
          int mask_package = int_to_int(last_package_size);
          int32_t command_new_mask = 0b00001111111110000000111111110000 | mask_package;
          int32_t to_fifo2 = sliced_package & command_new_mask;
          remain_bits_to_send -= last_package_size;
          IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, to_fifo2);
        }
        else
        {
          int to_fifo0 = remain_package &  0b11111111;
          //int32_t to_fifo0 = remain_package & 0b1111111111111111;
          remain_package = remain_package >> 8;
          int to_fifo1 = remain_package &  0b11111111;
          //int32_t to_fifo1 = sliced_package2 & 0b1111111111111111;
          remain_package = remain_package >> 8;
          int32_t to_fifo2 = (to_fifo0 << data_package) | to_fifo1;
          to_fifo2 = to_fifo2 & 0xb00001111111110000000111111111000;
          remain_bits_to_send -= 16;
          IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, to_fifo2);
        }
      
      
    }
  }
  else
  {
    int sliced_package = remain_package >> last_package_size;
    int mask_package = int_to_int(last_package_size);
    remain_package = remain_package >> last_package_size;
    int32_t command_new_mask = 0b00001111111110000000111111110000 | mask_package;
    int32_t to_fifo2 = sliced_package & command_new_mask;
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, to_fifo2);
  }
}

int main()
{
  IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI << 2, tari_test);
  IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN);
  ack_init(&command_ack, 1234);
  ack_build(&command_ack);
  send_package(command_ack.result_data, command_ack.size);
  //IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, package_ack );
  return 0;
}
