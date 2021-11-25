# Software

Below is an axplanation of the software code of our project, the NIOS II soft processor.

## [NIOS II](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/hello_world.c)

The NIOS II is a soft processor, which means that, unlike discrete processors, such as those in conventional computers, its peripherals and addressing can be reconfigured on demand. This enables the development of a specialized and efficient processor, reducing the costs and time of producing a prototype since it is dynamically generated inside the FPGA without the need to produce a new processor.

Communication between the NIOS II and the peripheral IP-Rfid is done via the Avalon data bus, which is a memory-mapped peripheral. The addressing works as in a common memory, having write, read, and address signals, as well as the input and output vectors of this bus.

The NIOS II function is to write the commands and tests in the register banks present in the IP peripheral, so that it can communicate with the TAG. This processor can be viewed as the conductor and all other components as the orchestra, as it is responsible for enabling, configuring, reading, and writing data from the Avalon memory to the IP-Rfid.

Throughout this project, the group breaks commands into packages for ease of use. Details on how this is done can be found [here](hardware.md)

### Starting Variables

**Register Status**

```c
//READ ONLY
define BASE_IS_FIFO_FULL    (1 << 0)
define MASK_EMPTY_RECEIVER  (1 << 13)
```

- `BASE_IS_FIFO_FULL`   - Indicates the necessary shift for the is_FIFO_full flag
- `MASK_EMPTY_RECEIVER` - Indicates the necessary shift for the is_receiver_empty flag


**Register Settings**

```c
//READ/WRITE
define BASE_REG_SET         (0)        
define MASK_RST             (1 << 0)
define MASK_EN              (1 << 1)
define MASK_RST_RECEIVER    (1 << 10)
define MASK_EN_RECEIVER     (1 << 4)
define MASK_CLR_FIFO        (1 << 2)
define MASK_LOOPBACK        (1 << 8)
define MASK_CLR_FINISHED    (1 << 1)
define SENDER_HAS_GEN       (0 << 5)
define SENDER_ENABLE_CTRL   (1 << 6)
define SENDER_IS_PREAMBLE   (0 << 7)
define MASK_READ_REQ        (1 << 12)
define MASK_FINISH_SEND     (1 << 3)

```

- `BASE_REG_SET`       - Memory address for the REGISTER_SETTINGS
- `MASK_RST`           - Indicates the necessary shift for the sender_reset flag
- `MASK_EN`            - Indicates the necessary shift for the sender_enable flag
- `MASK_RST_RECEIVER`  - Indicates the necessary shift for the receiver_reset flag
- `MASK_EN_RECEIVER`   - Indicates the necessary shift for the receiver_enable flag
- `MASK_CLR_FIFO`      - Indicates the necessary shift for the sender_clear_FIFO flag
- `MASK_LOOPBACK`      - Indicates the necessary shift for the RFID_loopback flag
- `MASK_CLR_FINISHED`  - Indicates the necessary shift for the sender_clear_finished flag
- `SENDER_HAS_GEN`     - Indicates the necessary shift for the sender_has_generator flag
- `SENDER_ENABLE_CTRL` - Indicates the necessary shift for the sender_enable_controller flag
- `SENDER_IS_PREAMBLE` - Indicates the necessary shift for the sender_is_preamble flag
- `MASK_READ_REQ`      - Indicates the necessary shift for the receiver_read_request flag
- `MASK_FINISH_SEND`   - Indicates the necessary shift for the mask_finish_send flag

**RFID- Addresses**

```c
define BASE_REG_TARI       (1)      
define BASE_REG_FIFO       (2)
define BASE_REG_TARI_101   (3)
define BASE_REG_TARI_099   (4)
define BASE_REG_TARI_1616  (5)
define BASE_REG_TARI_1584  (6)
define BASE_REG_PW         (7)
define BASE_REG_DELIMITER  (8)
define BASE_REG_RTCAL      (9)
define BASE_REG_TRCAL      (10)
define BASE_REG_STATUS     (3)
define BASE_RECEIVER_DATA  (4)
define BASE_SENDER_USEDW   (5)
define BASE_RECEIVER_USEDW (6)
define BASE_ID             (7)
```

- `BASE_REG_TARI`       - R/W - address of the tari 
- `BASE_REG_FIFO`       - R/W - address of FIFO R/W
- `BASE_REG_TARI_101`   - W   - address of tari_101
- `BASE_REG_TARI_099`   - W   - address of tari_099
- `BASE_REG_TARI_1616`  - W   - address of tari_1616
- `BASE_REG_TARI_1584`  - W   - address of tari_1584
- `BASE_REG_PW`         - W   - address of pw
- `BASE_REG_DELIMITER`  - W   - address of delimiter
- `BASE_REG_RTCAL`      - W   - address of receiver transmitter callibration
- `BASE_REG_TRCAL`      - W   - address of transmitter receiver callibrtation
- `BASE_REG_STATUS`     - R   - address of REGISTER_STATUS
- `BASE_RECEIVER_DATA`  - R   - address of receiver data
- `BASE_SENDER_USEDW`   - R   - address of sender_FIFO_actual_size
- `BASE_RECEIVER_USEDW` - R   - address of receiver_FIFO_actual_size
- `BASE_ID`             - R   - address of IP_rfid

**RFID- Command specifications**

```c
// package defines
define data_mask_size      (6)
define data_package_size   (26)
define eop                 (0b00000000000000000000000000000000)
define bits6               (0b111111)
define bits26              (0b11111111111111111111111111)
define bits32              (0b11111111111111111111111111111111)
```

- `data_mask_size`    - defines the number of bits reserved for the mask
- `data_package_size` - defines the number of bits reserved for the data
- `eop`               - defines the END_OF_PACKAGE format
- `bits6`             - mask for full package mask
- `bits26`            - mask for full package data
- `bits32`            - mask for full package

**RFID- Start of Communication Values**

```c
int tari = 0x1f4;
int tari_101  = 0x1f9;
int tari_099  = 0x1EF;
int tari_1616 = 0x328;
int tari_1584 = 0x318;
int pw        = 0xFA;
int delimiter = 0x271;
int RTcal     = 0x546;
int TRcal     = 0x546;
```

- `tari`        - tari time parameter
- `tari_101`    - 1% above tari limit
- `tari_099`    - 1% below tari limit
- `tari_1616`   - 1% above 1.6 tari limit
- `tari_1584`   - 1% below 1.6 tari limit
- `pw`          - pw parameter
- `delimiter`   - Delimiter parameter
- `RTcal`       - Receiver transmitter callibration parameter
- `TRcal`       - Transmitter receiver callibration parameter

### Functions

**RFID functions**

```c
void rfid_set_loopback()
void rfid_set_tari(int tari_value)
void rfid_set_tari_boundaries(int tari_101, int tari_099, int tari_1616, int tari_1584, int pw, int delimiter, int RTcal, int TRcal)
int rfid_create_mask_from_value(int value)
int rfid_check_command(int *packages, int quant_packages, int command_size)
int rfid_get_ip_id()
```

- `void rfid_set_loopback` - Connects Tx on Rx creating a loop, used for testing the reader
- `void rfid_set_tari` - Sets the tari value on the IP rfid
- `void rfid_set_tari_boundaries` -  Sets the tari boundaries on the IP rfid
- `int rfid_create_mask_from_value` - Generates the package mask based on the package received
- `int rfid_check_command` - Checks if the received command is valid and present on the EPC-GEN2 protocol
- `int rfid_get_ip_id` - Checks the currend address for the IP_rfid

**SENDER functions**

```c
int  sender_check_usedw()
int  sender_check_fifo_full()
void sender_enable()
void sender_send_package(int package)
void sender_send_end_of_package()
void sender_start_ctrl()
void sender_write_clr_finished_sending()
int sender_read_finished_send()
int sender_get_command_ints_size(int size_of_command)
void sender_add_mask(int n, int command_vector_masked[n],unsigned long long result_data, unsigned int result_data_size)
void sender_has_gen(int usesPreorFrameSync)
void sender_is_preamble()
void sender_send_command(command *command_ptr)
```

- `sender_check_usedw` - Access the address that indicates how many packages are in the sender FIFO
- `sender_check_fifo_full` - Access REG_STATUS to verify wether the FIFO is full or not
- `sender_enable` - Access REG_SET to activate the peripheral Sender on the IP rfid
- `sender_send_package` - Writes the package on the FIFO address
- `sender_send_end_of_package` - Writes the EOP on the FIFO address
- `sender_start_ctrl` - Access REG_SET to activate the sender controller with a pulse
- `sender_write_clr_finished_sending` - Access REG_SET to clear the finished_sending flag with a pulse
- `sender_read_finished_send` - Access RES_STATUS to check wether the package has been sent or not
- `sender_get_command_ints_size` - Check the size of the command and calculates the size of each smaller package
- `sender_add_mask` - Divides the command into smaller packages if needed and generates a mask based on the current package data size
- `sender_has_gen` - Access REG_SET to define wether the generator should be activated
- `sender_is_preamble` - If the generator is activated, defines if the generator is a preamble or a framesync
- `sender_send_command` - Runs the all the functions related to the command, going through all the steps necessary to split in packages, add the masks, send and clear the flag registers in the end

**RECEIVER functions**

```c
void receiver_enable()
int receiver_check_usedw()
int receiver_request_package()
int receiver_empty()
void receiver_rdreq()
void receiver_get_package(int *command_vector, int quant_packages, int *command_size, int *quant_packages_received)
```

- `receiver_enable` - Access REG_SET to activate the peripheral Receiver on the IP rfid
- `receiver_check_usedw` - Access the address that indicates how many packages are in the receiver FIFO
- `receiver_request_package` - Access BASE_RECEIVER_DATA to read the received package
- `receiver_empty` - Access REG_SET to check wether the receiver FIFO is empty or not
- `receiver_rdreq` - Access REG_SET to set the read_request flag with a pulse
- `receiver_get_package` - Separates the package from `receiver_request_package` into data and mask