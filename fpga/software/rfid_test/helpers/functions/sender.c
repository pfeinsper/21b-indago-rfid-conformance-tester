#include "sender.h"

// SENDER -----------------------------------------------------------------------------------------------------------
int sender_check_usedw() { return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_SENDER_USEDW << 2) & 0xFF; }

int sender_check_fifo_full() { return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 2) & BASE_IS_FIFO_FULL; }

void sender_enable() { IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_LOOPBACK | MASK_EN); }

void sender_send_package(int package)
{
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, package);
}

void sender_send_end_of_package() { IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, eop); }

void sender_start_ctrl()
{
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN | SENDER_ENABLE_CTRL);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);
}

void sender_write_clr_finished_sending()
{
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_CLR_FINISHED | MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN);
}

int sender_read_finished_send() { return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 2) & MASK_FINISH_SEND; }

void sender_add_mask(int n, int command_vector_masked[n], unsigned long long *result_data, unsigned int result_data_size)
{
    int last_package_size = result_data_size % data_package_size;
    int quant_packages = result_data_size / data_package_size + 1;
    for (int current_package = 1; current_package <= quant_packages; current_package++)
    {
        int quant_bits_this_package;
        if (current_package == quant_packages)
        {
            // case when we cant fill a package with 26 bits
            quant_bits_this_package = last_package_size;
        }
        else
        {
            // case when data is bigger thant 26 bits
            quant_bits_this_package = 0x1A;
        }

        // deviding package and adding mask to it
        int unmasked_package = *result_data & bits26; // 26 bits
        int masked_package = unmasked_package << 6 | quant_bits_this_package;
        command_vector_masked[current_package - 1] = masked_package;

        // shifting result_data to remove bits that are already treated
        *result_data = *result_data >> quant_bits_this_package;
    }
}

int sender_get_command_ints_size(int size_of_command)
{
    return (size_of_command / 26) + 1;
}

void sender_has_gen(int usesPreorFrameSync)
{
    if (usesPreorFrameSync)
    {
        IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_EN_RECEIVER | SENDER_HAS_GEN);
    }
}

void sender_is_preamble() { IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER | SENDER_IS_PREAMBLE | SENDER_HAS_GEN); }

void sender_send_command(command *command_ptr)
{
    unsigned long long result_data = command_ptr->result_data;
    int command_size = command_ptr->size;
    const int size_with_mask = sender_get_command_ints_size(command_size);

    int command_vector[size_with_mask];

    // ADDING MASKS TO EACH PACKAGE OF THE COMMAND
    sender_add_mask(size_with_mask, command_vector, &result_data, command_size);

    // WAITING FOR FIFO AND THEN SENDING PACKAGES
    for (int i = 0; i < size_with_mask; i++)
    {
        while (sender_check_fifo_full()){}
        sender_send_package(command_vector[i]);
    }

    sender_send_end_of_package();

    sender_start_ctrl();

    while(!sender_read_finished_send()){}

    sender_write_clr_finished_sending();
}
