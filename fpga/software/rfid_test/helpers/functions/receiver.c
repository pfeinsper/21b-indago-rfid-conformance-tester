#include "receiver.h"

void receiver_enable() { IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER); }

int receiver_check_usedw() { return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_RECEIVER_USEDW << 2) & 0xFF; }

int receiver_request_package() { return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_RECEIVER_DATA << 2); }

int receiver_empty()
{
    int is_empty = IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 2) & MASK_EMPTY_RECEIVER;
    return is_empty >> 13;
}

void receiver_rdreq()
{
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_READ_REQ | MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);
}

int receiver_get_package(int command_vector[], int quant_packages, int *command_size)
{
    int package = 1;
    *command_size = 0;
    int i = 0;
    while (package != 0)
    {
        while (receiver_empty())
        {
        };

        package = receiver_request_package();
        receiver_rdreq();

        int mask_value = package & bits6;
        int mask = rfid_create_mask_from_value(mask_value);

        int data = package >> 6;
        data = data & mask;

        if (data != 0)
        {
            command_vector[i] = data;
            *command_size += mask_value;
            i++;
            if (i > quant_packages)
            {
                printf("receiver_get_package: package size is bigger than expected\n");
                return -1;
            }
        }
        else
        {
            printf("receiver_get_package: received EOP\n");
            return 0;
        }
    };
    return 0;
}