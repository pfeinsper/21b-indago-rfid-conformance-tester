/************************************************************************/
/* defines                                                              */
/************************************************************************/

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
#define MASK_LOOPBACK (1 << 8) // FIXME: this parameter needs to be 1 or 0 depending on the test. If you are testing in loopback mode set 0 if not set 1
#define MASK_CLR_FINISHED 1 << 1
#define SENDER_HAS_GEN 0 << 5
#define SENDER_ENABLE_CTRL 1 << 6
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
#define bits6  0b111111;
#define bits26 0b11111111111111111111111111
#define bits32 0b11111111111111111111111111111111

#define FREQUENCY 50e6