#include "io.h"
#include "system.h"
#include "stdint.h"
#include "helpers/commands/commands.h"
#include "stdio.h"

// REGISTER STATUS
#define BASE_IS_FIFO_FULL (1 << 0)
#define MASK_EMPTY_RECEIVER (1 << 13)

// REGISTER SETTINGS
#define BASE_REG_SET 0
#define MASK_RST (1 << 0)
#define MASK_EN (1 << 1)
#define MASK_RST_RECEIVER (1 << 10)
#define MASK_EN_RECEIVER (1 << 4)
#define MASK_CLR_FIFO (1 << 2)
#define MASK_LOOPBACK (1 << 8)
#define MASK_CLR_FINISHED 1 << 1
// #define MASK_CLR_FINISHED_0  0 << 1
#define SENDER_HAS_GEN 0 << 5
#define SENDER_ENABLE_CTRL 1 << 6
// #define SENDER_ENABLE_CTRL_0 0 << 6
#define SENDER_IS_PREAMBLE 0 << 7
#define MASK_READ_REQ 1 << 12

// RFID - WRITE
#define BASE_REG_TARI 1
#define BASE_REG_FIFO 2
#define BASE_REG_TARI_101 3
#define BASE_REG_TARI_099 4
#define BASE_REG_TARI_1616 5
#define BASE_REG_TARI_1584 6
#define BASE_REG_PW 7
#define BASE_REG_DELIMITER 8
#define BASE_REG_RTCAL 9
#define BASE_REG_TRCAL 10

// RFID - READ
#define BASE_REG_STATUS 3
#define BASE_RECEIVER_DATA 4
#define BASE_SENDER_USEDW 5
#define BASE_RECEIVER_USEDW 6
#define BASE_ID 7
#define MASK_FINISH_SEND (1 << 3)

// package defines
#define data_mask_size 6
#define data_package_size 26
#define eop 0b00000000000000000000000000000000
#define bits6 0b111111;
#define bits26 0b11111111111111111111111111
#define bits32 0b11111111111111111111111111111111

// tudo isso precisa virar input
int tari_test = 0x1f4;
int tari_101 = 0x1f9;
int tari_099 = 0x1EF;
int tari_1616 = 0x328;
int tari_1584 = 0x318;
int pw = 0xFA;
int delimiter = 0x271;
int RTcal = 0x546;
int TRcal = 0x546;

// RFID -----------------------------------------------------------------------------------------------------------
void rfid_set_loopback() { IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_LOOPBACK); }

void rfid_set_tari(int tari_value) { IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI << 2, tari_value); }

void rfid_set_tari_bounderies(int tari_101, int tari_099, int tari_1616, int tari_1584, int pw, int delimiter, int RTcal, int TRcal)
{
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI_101 << 2, tari_101);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI_099 << 2, tari_099);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI_1616 << 2, tari_1616);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TARI_1584 << 2, tari_1584);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_PW << 2, pw);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_DELIMITER << 2, delimiter);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_RTCAL << 2, RTcal);
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_TRCAL << 2, TRcal);
}

int rfid_create_mask_from_value(int value)
{
    int mask = 0;
    for (int i = 0; i < value; i++)
    {
        mask = mask << 1;
        mask = mask | 1;
    }
    return mask;
}

int rfid_check_command(int packages[], int command_size)
{
    if (ack_validate(packages, command_size))
        return ACK_LABEL;
    else if (nak_validate(packages, command_size))
        return NAK_LABEL;
    else if (query_validate(packages, command_size))
        return QUERY_LABEL;
    else if (req_rn_validate(packages, command_size))
        return REQ_RN_LABEL;
    else if (rn_crc_validate(packages, command_size))
        return RN_CRC_LABEL;
    else if (kill_validate(packages, command_size))
        return KILL_LABEL;
    else if (lock_validate(packages, command_size))
        return LOCK_LABEL;
    else if (query_adjust_validate(packages, command_size))
        return QUERY_ADJUST_LABEL;
    else if (query_rep_validate(packages, command_size))
        return QUERY_REP_LABEL;
    else if (read_validate(packages, command_size))
        return READ_LABEL;
    else if (select_validate(packages, command_size))
        return SELECT_LABEL;
    else if (write_validate(packages, command_size))
        return WRITE_LABEL;
    else if (rn16_validate(command_size))
        return RN16_LABEL;
    else
        return -1;
}

int rfid_get_ip_id() { return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_ID << 2); }
// SENDER -----------------------------------------------------------------------------------------------------------
int sender_check_usedw() { return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_SENDER_USEDW << 2) & 0xFF; }

int sender_check_fifo_full() { return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 2) & BASE_IS_FIFO_FULL; }

void sender_enable() { IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_LOOPBACK | MASK_EN); }

void sender_send_package(int package)
{
    IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_FIFO << 2, package);
    //printf("sender_send_package %d \n", package);
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

void sender_add_mask(int n, int command_vector_masked[n], unsigned long long result_data, unsigned int result_data_size)
{
    //printf("result_data is: %d and result_data_size is, %d\n", result_data,result_data_size);
    int last_package_size = result_data_size % data_package_size;
    int quant_packages = result_data_size / data_package_size + 1;
    //printf("last_package_size is: %d and quant_packages is, %d\n", last_package_size,quant_packages);
    for (int current_package = 1; current_package <= quant_packages; current_package++)
    {
        //printf("FOR LOOP current_package is: %d and quant_packages is, %d\n", current_package,quant_packages);
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
        int unmasked_package = result_data & bits26; // 26 bits
        int masked_package = unmasked_package << 6 | quant_bits_this_package;
        command_vector_masked[current_package - 1] = masked_package;

        // shifting result_data to remove bits that are already treated
        result_data = result_data >> quant_bits_this_package;
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

// RECEIVER -----------------------------------------------------------------------------------------------------------
void receiver_enable() { IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_EN | MASK_LOOPBACK | MASK_EN_RECEIVER); }

int receiver_check_usedw() { return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_RECEIVER_USEDW << 2) & 0xFF; }

int receiver_request_package() { return IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_RECEIVER_DATA << 2); }

int receiver_empty()
{
    int is_empty = IORD_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_STATUS << 2) & MASK_EMPTY_RECEIVER;
    //printf(" receiver is empty: %d \n",is_empty);
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

        printf("mask is: %d and data is: %d\n", mask_value, data);

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
}

//-----------------------------------------------------------------------------------------------------------

int main()
{
    //configurations------------------------------------------------------------------------------
    // rfid_set_loopback();
    rfid_set_tari(tari_test);
    sender_enable();

    receiver_enable();
    rfid_set_tari_bounderies(tari_101, tari_099, tari_1616, tari_1584, pw, delimiter, RTcal, TRcal);
    sender_has_gen(0);
    //sender_is_preamble();
    printf("IP conneced ID is: %04X \n", rfid_get_ip_id());

    // HANDSHAKE EXAMPLE TAG -----------------------------------------------------------------------
    // WAIT A QUERY --------------------------------------------------------------------------------
    int quant_packages = 2;
    int command_size_rn = 0;
    int pack_query[quant_packages];
    printf("waiting for query\n");
    if (receiver_get_package(pack_query, quant_packages, &command_size_rn) == -1)
    {
        printf("exiting on RN16\n");
        return 1;
    }
    int label = rfid_check_command(pack_query, command_size_rn);
    // printf("label is: %d\n", label);
    if (label != QUERY_LABEL)
    {
        printf("QUERY_LABEL NOT FOUND\n");
        printf("found: %d\n", label);
        return 1;
    }
    printf("found QUERY_LABEL\n");

    // SEND AN RN16 ----------------------------------------------------------------------------------
    rn16 command_rn16;
    rn16_init(&command_rn16);
    printf("command rn16 = %d\n", command_rn16.result_data);
    int size_with_mask_rn16 = sender_get_command_ints_size(command_rn16.size);

    int command_vector_masked_rn16[size_with_mask_rn16];

    // ADDING MASKS TO EACH PACKAGE OF THE COMMAND
    sender_add_mask(size_with_mask_rn16, command_vector_masked_rn16, command_rn16.result_data, command_rn16.size);

    // WAITING FOR FIFO AND THEN SENDING PACKAGES
    for (int i = 0; i < size_with_mask_rn16; i++)
    {
        while (sender_check_fifo_full())
        {
        }
        sender_send_package(command_vector_masked_rn16[i]);
    }

    sender_send_end_of_package();

    sender_start_ctrl();

    while (!sender_read_finished_send())
    {
    }

    sender_write_clr_finished_sending();

    //RECEIVER-------------------------------------------------------------------------------------------------------
    //expecting a ack(RN16)

    quant_packages = 2;
    int command_size_ack = 0;
    int pack_ack[quant_packages];
    printf("waiting for ack(RN16)\n");
    if (receiver_get_package(pack_ack, quant_packages, &command_size_ack) == -1)
    {
        printf("exiting on ack(RN16)\n");
        return 1;
    }
    label = rfid_check_command(pack_ack, command_size_ack);
    if (label != ACK_LABEL)
    {
        printf("ACK_LABEL NOT FOUND\n");
        printf("found: %d\n", label);
        return 1;
    }

    printf("found ACK_LABEL\n");

    //PC/XPC, EPC------------------------------------------------------
    rn_crc command_XPC;
    rn_crc_init(&command_XPC);
    printf("command PC/XPC, EPC = %d\n", command_XPC.size);
    int size_with_mask_req = sender_get_command_ints_size(command_XPC.size);

    int command_vector_masked_req[size_with_mask_req];

    // ADDING MASKS TO EACH PACKAGE OF THE COMMAND
    sender_add_mask(size_with_mask_req, command_vector_masked_req, command_XPC.result_data, command_XPC.size);

    // WAITING FOR FIFO AND THEN SENDING PACKAGES
    for (int i = 0; i < size_with_mask_req; i++)
    {
        while (sender_check_fifo_full())
        {
        }
        sender_send_package(command_vector_masked_req[i]);
    }

    sender_send_end_of_package();

    sender_start_ctrl();

    while (!sender_read_finished_send())
    {
    }

    sender_write_clr_finished_sending();

    //RECEIVER-------------------------------------------------------------------------------------------------------
    //expecting a req_rn
    quant_packages = 2;
    int command_size_handle = 0;
    int pack_req_rn[quant_packages];
    printf("waiting for req_rn\n");
    if (receiver_get_package(pack_req_rn, quant_packages, &command_size_handle) == -1)
    {
        printf("exiting on req_rn\n");
        return 1;
    }
    label = rfid_check_command(pack_req_rn, command_size_handle);
    if (label != REQ_RN_LABEL)
    {
        printf("REQ_RN_LABEL NOT FOUND\n");
        printf("found: %d\n", label);
        return 1;
    }

    printf("found REQ_RN_LABEL\n");

    // REQ_RN_RESPONSE-------------------------------------------------------------------------------------------------------
    rn_crc command_REQ_RN_RESPONSE;
    rn_crc_init(&command_REQ_RN_RESPONSE);
    printf("command rn_crc = %d\n", command_REQ_RN_RESPONSE.size);
    int size_with_mask_req_rn_resp = sender_get_command_ints_size(command_REQ_RN_RESPONSE.size);

    int command_vector_masked_req_rn_resp[size_with_mask_req_rn_resp];

    // ADDING MASKS TO EACH PACKAGE OF THE COMMAND
    sender_add_mask(size_with_mask_req_rn_resp, command_vector_masked_req_rn_resp, command_REQ_RN_RESPONSE.result_data, command_REQ_RN_RESPONSE.size);

    // WAITING FOR FIFO AND THEN SENDING PACKAGES
    for (int i = 0; i < size_with_mask_req_rn_resp; i++)
    {
        while (sender_check_fifo_full())
        {
        }
        sender_send_package(command_vector_masked_req_rn_resp[i]);
    }

    sender_send_end_of_package();

    sender_start_ctrl();

    while (!sender_read_finished_send())
    {
    }

    sender_write_clr_finished_sending();

    printf("End of Communication with IP = %04X \n", rfid_get_ip_id());
    return 0;
}
