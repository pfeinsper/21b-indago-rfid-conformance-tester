# Firmware
This section contains an explanation of the software/code of our project, which is centered around the NIOS II soft processor.

## NIOS II

[/main/fpga/software/rfid_test/hello_world.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/hello_world.c)

The NIOS II is a soft processor, which means that, unlike discrete processors, such as those in conventional computers, its peripherals and addressing can be reconfigured on demand. This enables the development of a specialized and efficient processor, reducing the costs and time of producing a prototype since i!t is dynamically generated inside the FPGA without the need to produce a new processor.

Communication between the NIOS II and the peripheral IP core is done via the Avalon data bus, which is a memory-mapped peripheral. The addressing works as in a common memory, having write, read, and address signals, as well as the input and output vectors of this bus.

The NIOS II function is to write the commands and tests in the register banks present in the IP peripheral, so that it can communicate with the TAG. This processor can be viewed as the conductor and all other components as the orchestra, as it is responsible for enabling, configuring, reading, and writing data from the Avalon memory to the IP core.

Throughout this project, commands are separated into packages for ease of use. Details on how this is done can be found [here](hardware.md)

### File Hierarchy

All necessary C and header filesare located in the project’s fpga/software/rfid_test folder. The top entity of the entire processor including all the required configuration generics is main.c and all other relevant files are inside the helpers folder.

    main.c                   - NIOS II soft processor top entity
    │
    │
    └/helpers                - Holds all complimentary C files
        │
        ├/functions             - Holds all functions that dictate how the components act
        │   │
        │   ├sender.c              - Holds all functions that dictate how the Sender acts
        │   ├receiver.c            - Holds all functions that dictate how the Receiver acts
        │   └rfid.c                - Holds all functions about tari, commands and packages
        |
        ├config.h                - Stores all the needed defines
        |
        ├crc.c                   - Cyclic Redundance Check file
        │
        └/commands              - Holds all the EPC-GEN2 mandatory commands
            │
            ├ack.c                 - Mandatory command ack
            ├kill.c                - Mandatory command kill
            ├lock.c                - Mandatory command lock
            ├nak.c                 - Mandatory command nak
            ├query.c               - Mandatory command query
            ├query_adjust.c        - Mandatory command query_adjust
            ├query_rep.c           - Mandatory command query_rep
            ├read.c                - Mandatory command read
            ├req_rn.c              - Mandatory command req_rn
            ├rn16.c                - Mandatory command rn16
            ├rn_crc.c              - Mandatory command rn_crc
            ├select.c              - Mandatory command select
            ├write.c               - Mandatory command write
            
Additional information on the EPC-GEN2 protocol and mandatory commands (as well as the other command types) can be found here [here](index.md)

### Starting Variables

#### Register Status

```c
//READ ONLY
define BASE_IS_FIFO_FULL    (1 << 0)
define MASK_EMPTY_RECEIVER  (1 << 13)
```

- <guide>BASE_IS_FIFO_FULL</guide>   - Indicates the necessary shift for the is_FIFO_full flag
- <guide>MASK_EMPTY_RECEIVER</guide> - Indicates the necessary shift for the is_receiver_empty flag


#### Register Settings

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

- <guide>BASE_REG_SET</guide>       - Memory address for the REGISTER_SETTINGS
- <guide>MASK_RST</guide>           - Indicates the necessary shift for the sender_reset flag
- <guide>MASK_EN</guide>            - Indicates the necessary shift for the sender_enable flag
- <guide>MASK_RST_RECEIVER</guide>  - Indicates the necessary shift for the receiver_reset flag
- <guide>MASK_EN_RECEIVER</guide>   - Indicates the necessary shift for the receiver_enable flag
- <guide>MASK_CLR_FIFO</guide>      - Indicates the necessary shift for the sender_clear_FIFO flag
- <guide>MASK_LOOPBACK</guide>      - Indicates the necessary shift for the RFID_loopback flag
- <guide>MASK_CLR_FINISHED</guide>  - Indicates the necessary shift for the sender_clear_finished flag
- <guide>SENDER_HAS_GEN</guide>     - Indicates the necessary shift for the sender_has_generator flag
- <guide>SENDER_ENABLE_CTRL</guide> - Indicates the necessary shift for the sender_enable_controller flag
- <guide>SENDER_IS_PREAMBLE</guide> - Indicates the necessary shift for the sender_is_preamble flag
- <guide>MASK_READ_REQ</guide>      - Indicates the necessary shift for the receiver_read_request flag
- <guide>MASK_FINISH_SEND</guide>   - Indicates the necessary shift for the mask_finish_send flag

#### RFID - Addresses

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

- <guide>BASE_REG_TARI</guide>       - R/W - address of the tari
- <guide>BASE_REG_FIFO</guide>       - R/W - address of FIFO R/W
- <guide>BASE_REG_TARI_101</guide>   - W   - address of tari_101
- <guide>BASE_REG_TARI_099</guide>   - W   - address of tari_099
- <guide>BASE_REG_TARI_1616</guide>  - W   - address of tari_1616
- <guide>BASE_REG_TARI_1584</guide>  - W   - address of tari_1584
- <guide>BASE_REG_PW</guide>         - W   - address of pw
- <guide>BASE_REG_DELIMITER</guide>  - W   - address of delimiter
- <guide>BASE_REG_RTCAL</guide>      - W   - address of receiver transmitter callibration
- <guide>BASE_REG_TRCAL</guide>      - W   - address of transmitter receiver callibrtation
- <guide>BASE_REG_STATUS</guide>     - R   - address of REGISTER_STATUS
- <guide>BASE_RECEIVER_DATA</guide>  - R   - address of receiver data
- <guide>BASE_SENDER_USEDW</guide>   - R   - address of sender_FIFO_actual_size
- <guide>BASE_RECEIVER_USEDW</guide> - R   - address of receiver_FIFO_actual_size
- <guide>BASE_ID</guide>             - R   - address of IP core

#### RFID - Command specifications

```c
// package defines
define data_mask_size      (6)
define data_package_size   (26)
define eop                 (0x000000000)
define bits6               (0x3F)
define bits26              (0x3FFFFFF)
define bits32              (0xFFFFFFFF)
```

- <guide>data_mask_size</guide>    - defines the number of bits reserved for the mask
- <guide>data_package_size</guide> - defines the number of bits reserved for the data
- <guide>eop</guide>               - defines the END_OF_PACKAGE format
- <guide>bits6</guide>             - mask for full package mask
- <guide>bits26</guide>            - mask for full package data
- <guide>bits32</guide>            - mask for full package

#### RFID - Start of Communication Values

```c
int tari_100  = rfid_tari_2_clock(10e-6, FREQUENCY);
int pw        = rfid_tari_2_clock(5e-6, FREQUENCY);
int delimiter = rfid_tari_2_clock(62.5e-6, FREQUENCY);
int RTcal     = rfid_tari_2_clock(135e-6, FREQUENCY);
int TRcal     = rfid_tari_2_clock(135e-6, FREQUENCY);
```

- <guide>tari_100</guide>    - tari time parameter
- <guide>pw</guide>          - pw parameter
- <guide>delimiter</guide>   - Delimiter parameter
- <guide>RTcal</guide>       - Receiver transmitter callibration parameter
- <guide>TRcal</guide>       - Transmitter receiver callibration parameter

### Functions

#### RFID functions

```c
void rfid_set_loopback()
void rfid_set_tari(int tari_value)
void rfid_set_tari_boundaries(int tari_101, int tari_099, int tari_1616, int tari_1584, int pw, int delimiter, int RTcal, int TRcal)
int rfid_create_mask_from_value(int value)
int rfid_check_command(int *packages, int quant_packages, int command_size)
int rfid_get_ip_id()
```

- <guide>void rfid_set_loopback</guide> - Connects Tx on Rx creating a loop, used for testing the reader
- <guide>void rfid_set_tari</guide> - Sets the tari value on the IP core
- <guide>void rfid_set_tari_boundaries</guide> -  Sets the tari boundaries on the IP core
- <guide>int rfid_create_mask_from_value</guide> - Generates the package mask based on the package received
- <guide>int rfid_check_command</guide> - Checks if the received command is valid and present on the EPC-GEN2 protocol
- <guide>int rfid_get_ip_id</guide> - Checks the currend address for the IP core

#### SENDER functions

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

- <guide>sender_check_usedw</guide> - Access the address that indicates how many packages are in the sender FIFO
- <guide>sender_check_fifo_full</guide> - Access REG_STATUS to verify wether the FIFO is full or not
- <guide>sender_enable</guide> - Access REG_SET to activate the peripheral Sender on the IP core
- <guide>sender_send_package</guide> - Writes the package on the FIFO address
- <guide>sender_send_end_of_package</guide> - Writes the EOP on the FIFO address
- <guide>sender_start_ctrl</guide> - Access REG_SET to activate the sender controller with a pulse
- <guide>sender_write_clr_finished_sending</guide> - Access REG_SET to clear the finished_sending flag with a pulse
- <guide>sender_read_finished_send</guide> - Access RES_STATUS to check wether the package has been sent or not
- <guide>sender_get_command_ints_size</guide> - Check the size of the command and calculates the size of each smaller package
- <guide>sender_add_mask</guide> - Divides the command into smaller packages if needed and generates a mask based on the current package data size
- <guide>sender_has_gen</guide> - Access REG_SET to define wether the generator should be activated
- <guide>sender_is_preamble</guide> - If the generator is activated, defines if the generator is a preamble or a framesync
- <guide>sender_send_command</guide> - Runs the all the functions related to the command, going through all the steps necessary to split in packages, add the masks, send and clear the flag registers in the end

#### RECEIVER functions

```c
void receiver_enable()
int receiver_check_usedw()
int receiver_request_package()
int receiver_empty()
void receiver_rdreq()
void receiver_get_package(int *command_vector, int quant_packages, int *command_size, int *quant_packages_received)
```

- <guide>receiver_enable</guide> - Access REG_SET to activate the peripheral Receiver on the IP core
- <guide>receiver_check_usedw</guide> - Access the address that indicates how many packages are in the receiver FIFO
- <guide>receiver_request_package</guide> - Access BASE_RECEIVER_DATA to read the received package
- <guide>receiver_empty</guide> - Access REG_SET to check wether the receiver FIFO is empty or not
- <guide>receiver_rdreq</guide> - Access REG_SET to set the read_request flag with a pulse
- <guide>receiver_get_package</guide> - Separates the package from `receiver_request_package` into data and mask