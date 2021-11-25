#include "rfid.h"

void rfid_set_loopback(void) { IOWR_32DIRECT(NIOS_RFID_PERIPHERAL_0_BASE, BASE_REG_SET << 2, MASK_LOOPBACK ); }

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

int rfid_tari_2_clock(double tari, double clock) { return (int)(tari * clock); }