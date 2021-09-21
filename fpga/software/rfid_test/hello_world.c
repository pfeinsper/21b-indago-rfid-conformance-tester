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

// int package_ack = 0b101101011000;
int tari_test = 0b111110100;

ack command_ack;

void check_command(int pacote, int size)
{

}

void send_package(int pacote, int size)
{
  if (size > 16)
  {
    int iter = size / 32;
    uint32_t sliced_package = pacote & 0xb1111111111111111;
    for (int i = 0; i <= iter; i++)
    {
      IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, sliced_package);
      sliced_package = pacote >> 16;
    }
  }
  else
  {
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, pacote);
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
