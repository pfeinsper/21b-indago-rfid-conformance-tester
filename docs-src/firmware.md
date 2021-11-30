# Firmware

This section contains an explanation of the firmware/code of this project, which is centered around the NIOS II soft processor.

## NIOS II

The NIOS II is a soft processor, which means that, unlike discrete processors, such as those in conventional computers, its peripherals and addressing can be reconfigured on demand. This enables the development of a specialized and efficient processor, reducing the costs and time of producing a prototype since i!t is dynamically generated inside the FPGA without the need to produce a new processor.

Communication between the NIOS II and the peripheral IP core is done via the Avalon data bus, which is a memory-mapped peripheral. The addressing works as in a common memory, having write, read, and address signals, as well as the input and output vectors of this bus.

The NIOS II function is to write the commands and tests in the register banks present in the IP peripheral, so that it can communicate with the tag. This processor can be viewed as the conductor and all other components as the orchestra, as it is responsible for enabling, configuring, reading, and writing data from the Avalon memory to the IP core.

Throughout this project, commands are separated into packages for ease of use. Details on how this is done can be found [here](hardware.md)

### File Hierarchy

All necessary C and header files are located in the project’s `fpga/software/rfid_test` folder. The top entity of the entire processor including all the required configuration generics is main.c and all other relevant files are inside the helpers folder.

```
main.c                   - NIOS II soft processor top entity
│
└/helpers                - Holds all complimentary C files
    │
    ├/functions             - Holds all functions that dictate how the components act
    │   ├sender.c              - Holds all functions that dictate how the Sender acts
    │   ├receiver.c            - Holds all functions that dictate how the Receiver acts
    │   └rfid.c                - Holds all functions about tari, commands and packages
    |
    ├config.h                - Stores all the needed defines
    |
    ├crc.c                   - Cyclic Redundance Check file
    │
    └/commands              - Holds all the EPC-GEN2 mandatory commands
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
```

Additional information on the EPC-GEN2 protocol and mandatory commands (as well as the other command types) can be found here [here](index.md)

## Main code

[/main/fpga/software/rfid_test/main.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/main.c)

The software is developed to be easy to understand, it calls single responsibility functions, defines and commands structures from the /helpers folder which are granted by the higher level code. These features are all called in the main.c code, which is responsible for the control and monitoring of the IP core. 

In the main code the user can choose which commands they want to send to the TAG, to see if it responds properly according to the EPC-GEN2 protocol. Also It is possible to make timing tests by varying the Tari values, to check if the Tag will respond accordingly. This also permits the user to implement new commands such as propertary or custom ones.

The group has prepared a set of examples in which this code will be used by the final user. For example, if the user wants to test it's reader or even make a simulation in ModelSim, they must copy the file loopback_handshake.c from the folder ./examples_of_main to the main code. By executing this code inside the main, what the user will be able to see and test will be shown later in the section Example of Main code. This folder can be found [here](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/tree/main/fpga/example_of_main).

Besides the loopback_handshake.c the others examples of main codes are the reader.c, the tag.c and the test_individual_commands_loopback.c which are variations that are capable, respectivily, of making the job of a Reader or emulating a Tag and even testing the send and receive of a single command in a single fpga.



## Config.h - Starting Variables

Inside the /helpers folder the first group to be explained are the defines that declares the adresses in which the previous page, IP core Interface, acts. IN this file there are also defines that store default values for package, command and mask sizes. Those defines are in more details right bellow.

#### Register Status

```C
//READ ONLY
define BASE_IS_FIFO_FULL    (1 << 0)
define MASK_EMPTY_RECEIVER  (1 << 13)
```

- `BASE_IS_FIFO_FULL`  - Indicates the necessary shift for the `is_FIFO_full` flag
- `MASK_EMPTY_RECEIVER` - Indicates the necessary shift for the `is_receiver_empty` flag

#### Register Settings

```C
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

- `BASE_REG_SET`       - Memory address for the `REGISTER_SETTINGS`
- `MASK_RST`           - Indicates the necessary shift for the `sender_reset` flag
- `MASK_EN`            - Indicates the necessary shift for the `sender_enable` flag
- `MASK_RST_RECEIVER`  - Indicates the necessary shift for the `receiver_reset` flag
- `MASK_EN_RECEIVER`   - Indicates the necessary shift for the `receiver_enable` flag
- `MASK_CLR_FIFO`      - Indicates the necessary shift for the `sender_clear_FIFO` flag
- `MASK_LOOPBACK`      - Indicates the necessary shift for the `RFID_loopback` flag
- `MASK_CLR_FINISHED`  - Indicates the necessary shift for the `sender_clear_finished` flag
- `SENDER_HAS_GEN`     - Indicates the necessary shift for the `sender_has_generator` flag
- `SENDER_ENABLE_CTRL` - Indicates the necessary shift for the `sender_enable_controller` flag
- `SENDER_IS_PREAMBLE` - Indicates the necessary shift for the `sender_is_preamble` flag
- `MASK_READ_REQ`      - Indicates the necessary shift for the `receiver_read_request` flag
- `MASK_FINISH_SEND`   - Indicates the necessary shift for the `mask_finish_send` flag

#### RFID - Addresses

```C
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
- `BASE_REG_STATUS`     - R   - address of `REGISTER_STATUS`
- `BASE_RECEIVER_DATA`  - R   - address of receiver data
- `BASE_SENDER_USEDW`   - R   - address of `sender_FIFO_actual_size`
- `BASE_RECEIVER_USEDW` - R   - address of `receiver_FIFO_actual_size`
- `BASE_ID`             - R   - address of IP core

#### RFID - Command specifications

```C
// package defines
define data_mask_size      (6)
define data_package_size   (26)
define eop                 (0x000000000)
define bits6               (0x3F)
define bits26              (0x3FFFFFF)
define bits32              (0xFFFFFFFF)
```

- `data_mask_size`    - defines the number of bits reserved for the mask
- `data_package_size` - defines the number of bits reserved for the data
- `eop`               - defines the `END_OF_PACKAGE` format
- `bits6`             - mask for full package mask
- `bits26`            - mask for full package data
- `bits32`            - mask for full package

## Commands
[/main/fpga/software/rfid_test/helpers/commands](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/tree/main/fpga/software/rfid_test/helpers/commands)

As described in the Mandatory Commands subsection inside the [Project Overview](index.md) page, the group has implemented all the mandatory commands, a couple of them still need to be validated, but the ones that are necessary for a full handshake are both implamented and deeply tested.

### Command Struct and CRC
Both the Command Struct and the CRC files are not together with the rest of the commands, because they are not exactly commands they are in essence part of the build of each command depending of course on the demands of the protocol.

#### Command Struct
[/main/fpga/software/rfid_test/helpers/commands/command_struct.h](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/command_struct.h)

The first, is the Command Struct which stablishes the base struct that every command will have in common. Which is composed by the commands size and data. It can be seen in the box bellow.
```c
typedef struct
{
    int size;
    unsigned long long result_data;
} command;
```
#### Cyclic Redundancy Check - CRC-5/CRC-16
[/main/fpga/software/rfid_test/helpers/commands/crc.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/crc.c)

Secondely, the  CRC code was added by the previous group. It comes from the BarrGroup, a verified hardware site, which is coted and documented properly inside the file. 

The CRC implemented by them, in the C language, is the same that the EPC-GEN2 documentation requires and as it is an Open Source code, just like this project, the group maintened and make use of it. 

Follows a CRC-16 example:

```c
void crc_16_ccitt_init(void)
{
    unsigned short polynomial = POLYNOMIAL_16;
    crc16 remainder;
    int dividend;
    unsigned char bit;

    // Compute the remainder of each possible dividend.
    for (dividend = 0; dividend < 256; ++dividend)
    {
        // Start with the dividend followed by zeros.
        remainder = dividend << 8;

        // Perform modulo-2 division, a bit at a time.
        for (bit = 8; bit > 0; --bit)
        {
            //	Try to divide the current data bit.
            if (remainder & 0x8000)
            {
                remainder = (remainder << 1) ^ polynomial;
            }
            else
            {
                remainder = (remainder << 1);
            }
        }

        // Store the result into the table.
        crc_table[dividend] = remainder;
    }
}
```
### Mandatory commands
[/main/fpga/software/rfid_test/helpers/commands/](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/)

The Mandatory commands were already explained in the [Protocol EPC-GEN2 UHF RFID](index.md) subsection, so here in the Firmware page it will be presented just their implamentation in plain C code. 

#### Ack
[/main/fpga/software/rfid_test/helpers/commands/ack.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/ack.c)

The Ack command was tested and validated and can be seen below:

```c
#include "ack.h"

void ack_build(command *ack, int rn)
{
    ack->result_data = ((ACK_COMMAND & 0b11) << 16) | (rn & 0xFFFF);
    ack->size = ACK_SIZE;
}

int ack_validate(int packages[], int command_size)
{
    if (command_size != ACK_SIZE && command_size != ACK_SIZE + 1)
        return 0;

    // |       packages[0]      |
    // |  command  |  rn/randle  |
    // |    X*2    |     X*16    |

    int command = (packages[0] >> 16) & 0b11;
    if (command != ACK_COMMAND)
        return 0;

    return 1;
}

```

#### Kill
[/main/fpga/software/rfid_test/helpers/commands/kill.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/kill.c)

The kill command was tested but not validated, which means that it was not tested in a full comunication between two fpgas, in whose it was supposed to stop it.
What we have done is built it and checked if it was beying sent properly. It has an Issue in the GitHub to be completed.

```c
#include "kill.h"

void kill_build(command *kill, unsigned short password, unsigned char rfu,
               unsigned short rn, unsigned short crc)
{
    kill->result_data = 0;

    kill->result_data |= (KILL_COMMAND << 51);
    kill->result_data |= (password << 35);
    kill->result_data |= (rfu << 32);
    kill->result_data |= (rn << 16);
    kill->result_data |= crc;

    kill->size = KILL_SIZE;
}

int kill_validate(int packages[], int command_size)
{
    if (command_size != KILL_SIZE && command_size != KILL_SIZE + 1)
        return 0;

    // | packages[2] |            packages[1]           | packages[0] |
    // |   command   | command |   password | rfu | rn  |  rn  | crc  |
    // |     X*7     |    X    |    X*16    | X*3 | X*6 | X*10 | X*16 |

    int command = ((packages[2] & 0xEF) << 1) | ((packages[1] >> 25) & 0x01);

    if (command != KILL_COMMAND)
        return 0;

    int crc = packages[0] & 0xFFFF;

    return 1;
}

```

#### Lock
[/main/fpga/software/rfid_test/helpers/commands/lock.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/lock.c)

As much as the kill command the lock was implamented and its send was tested, but its actual function was not yet tested and also its validation is to be done in a GitHub issue.

```c
#include "lock.h"

void lock_build(command *lock, unsigned int payload, unsigned short rn,
               unsigned short crc)
{
    lock->result_data = 0;

    lock->result_data |= (LOCK_COMMAND << 52);
    lock->result_data |= (payload << 32);
    lock->result_data |= (rn << 16);
    lock->result_data |= crc;

    lock->size = LOCK_SIZE;

}

int lock_validate(int packages_vector[], int command_size){
    //TODO: validate
    
    return 0;
}

```

#### Nak
[/main/fpga/software/rfid_test/helpers/commands/nak.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/nak.c)

The Nak, as much as the Ack command, is fully implemented and tested. It can be seen bellow:

```c
#include "nak.h"

void nak_build(command *nak)
{
    nak->result_data = NAK_COMMAND;
    nak->size = NAK_SIZE;
}

int nak_validate(int *packages, int command_size)
{
    if (command_size != NAK_SIZE && command_size != NAK_SIZE + 1)
        return 0;

    // | packages[0] |
    // |   command   |
    // |     X*8     |

    int command = packages[0] & 0xFF;
    if (command != NAK_COMMAND)
        return 0;

    return 1;
}


```


#### Query
[/main/fpga/software/rfid_test/helpers/commands/query.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/query.c)
The Query, as much as the Ack command, is fully implemented and tested. It can be seen bellow:
```c
#include "query.h"

void query_build(command *query, unsigned char dr, unsigned char m,
                unsigned char trext, unsigned char sel, unsigned char session,
                unsigned char target, unsigned char q)
{
    query->result_data = 0;

    query->result_data |= (QUERY_COMMAND << 13);
    query->result_data |= (dr << 12);
    query->result_data |= (m << 10);
    query->result_data |= (trext << 9);
    query->result_data |= (sel << 7);
    query->result_data |= (session << 5);
    query->result_data |= (target << 4);
    query->result_data |= q;

    const int crc = crc5(query->result_data);

    query->result_data <<= 5;
    query->result_data |= crc;

    query->size = QUERY_SIZE;
}

int query_validate(int packages[], int command_size)
{
    if (command_size != QUERY_SIZE && command_size != QUERY_SIZE + 1)
        return 0;

    // |                           packages[0]                           |
    // | command | dr |  m  | trext | sel | session | target |  q  | crc |
    // |   X*4   | X  | X*2 |   X   | X*2 |   X*2   |    X   | X*4 | X*5 |

    int command = (packages[0] >> 18) & 0xF;
    if (command != QUERY_COMMAND)
        return 0;

    int crc = packages[0] & 0x1F;
    int without_crc = packages[0] >> 5;
    int crc_calculated = crc5(without_crc);
    if (crc != crc_calculated)
        return 0;

    return 1;
}

```


#### Query_adjust
[/main/fpga/software/rfid_test/helpers/commands/query_adjust.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/query_adjust.c)

```c

```


#### Query_rep
[/main/fpga/software/rfid_test/helpers/commands/nak.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/nak.c)

```c

```


#### Read
[/main/fpga/software/rfid_test/helpers/commands/read.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/read.c)

```c

```


#### Req_rn
[/main/fpga/software/rfid_test/helpers/commands/req_rn.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/req_rn.c)

```c

```


#### Rn16
[/main/fpga/software/rfid_test/helpers/commands/rn16.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/rn16.c)

```c

```


#### Rn_crc
[/main/fpga/software/rfid_test/helpers/commands/rn_crc.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/rn_crc.c)

```c

```


#### Select
[/main/fpga/software/rfid_test/helpers/commands/select.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/select.c)

```c

```


#### Write
[/main/fpga/software/rfid_test/helpers/commands/write.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/write.c)

```c

```


## Functions

### Main.c - Start of Communication Values
[/main/fpga/examples_of_main/](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/examples_of_main/)

In every variation of the main code present inside the folder ./examples_of_main what them all have in common is the need to set all the time parameters metioned in the Signal Generator section inside the Hardware page.

```C
int tari_100  = rfid_tari_2_clock(10e-6, FREQUENCY);
int pw        = rfid_tari_2_clock(5e-6, FREQUENCY);
int delimiter = rfid_tari_2_clock(62.5e-6, FREQUENCY);
int RTcal     = rfid_tari_2_clock(135e-6, FREQUENCY);
int TRcal     = rfid_tari_2_clock(135e-6, FREQUENCY);
```

- `tari_100`    - tari time parameter
- `pw`          - pw parameter
- `delimiter`   - Delimiter parameter
- `RTcal`       - Receiver transmitter callibration parameter
- `TRcal`       - Transmitter receiver callibration parameter

### RFID.c

[/main/fpga/software/rfid_test/helpers/functions/rfid.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/functions/rfid.c)

The RFID code comes first in use inside the main, because it stores the functions that set all the needed parameters to the test to be launched. Such as functions that set the time parameters, functions that help with mask translations and the ones that check if an answer received is a valid command. They are all discribed bellow:  

#### RFID functions

```C
void rfid()
void rfid_set_tari(int tari_value)
void rfid_set_tari_boundaries(int tari_101, int tari_099, int tari_1616, int tari_1584, int pw, int delimiter, int RTcal, int TRcal)
int rfid_create_mask_from_value(int value)
int rfid_check_command(int *packages, int quant_packages, int command_size)
int rfid_get_ip_id()
```

- `void rfid_set_loopback` - Connects Tx on Rx creating a loop, used for testing the reader
- `void rfid_set_tari` - Sets the tari value on the IP core
- `void rfid_set_tari_boundaries` -  Sets the tari boundaries on the IP core
- `int rfid_create_mask_from_value` - Generates the package mask based on the package received
- `int rfid_check_command` - Checks if the received command is valid and present on the EPC-GEN2 protocol
- `int rfid_get_ip_id` - Checks the currend address for the IP core


### Sender.c

[/main/fpga/software/rfid_test/helpers/functions/sender.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/functions/sender.c)

This file is responsible for the functions of control of the Sender peripheral, it has the functions that enable the peripheral, the ones that prepares the commands in the proper format to be sent to the TAG and also the one that actually sends it. for more information they are presented bellow:

#### SENDER functions

```C
int  sender_check_usedw()
int  sender_check_fifo_full()
void sender_enable()
void sender_send_package(int package)
void sender_send_end_of_package()
void sender_start_ctrl()
void sender_write_clr_finished_sending()
int sender_read_finished_send()
int sender_get_command_ints_size(int size_of_command)
void sender_add_mask(int n, int command_vector_masked[n], unsigned long long result_data, unsigned int result_data_size)
void sender_has_gen(int usesPreorFrameSync)
void sender_is_preamble()
void sender_send_command(command *command_ptr)
```

- `sender_check_usedw` - Access the address that indicates how many packages are in the sender FIFO
- `sender_check_fifo_full` - Access `REG_STATUS` to verify wether the FIFO is full or not
- `sender_enable` - Access `REG_SET` to activate the peripheral Sender on the IP core
- `sender_send_package` - Writes the package on the FIFO address
- `sender_send_end_of_package` - Writes the EOP on the FIFO address
- `sender_start_ctrl` - Access `REG_SET` to activate the sender controller with a pulse
- `sender_write_clr_finished_sending` - Access `REG_SET` to clear the `finished_sending` flag with a pulse
- `sender_read_finished_send` - Access `RES_STATUS` to check whether the package has been sent or not
- `sender_get_command_ints_size` - Check the size of the command and calculates the size of each smaller package
- `sender_add_mask` - Divides the command into smaller packages if needed and generates a mask based on the current package data size
- `sender_has_gen` - Access `REG_SET` to define wether the generator should be activated
- `sender_is_preamble` - If the generator is activated, defines if the generator is a preamble or a framesync
- `sender_send_command` - Runs the all the functions related to the command, going through all the steps necessary to split in packages, add the masks, send and clear the flag registers in the end


### Receiver.c

[/main/fpga/software/rfid_test/helpers/functions/receiver.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/functions/receiver.c)

This section of code stores all the functions necessary to retrieve data from the IP core, which is composed by the functions that enable the peripheral Receiver, the ones that check the fifo for data and also the ones that request a new package. As the previous two, they are all discribed bellow:

#### RECEIVER functions

```C
void receiver_enable()
int receiver_check_usedw()
int receiver_request_package()
int receiver_empty()
void receiver_rdreq()
void receiver_get_package(int *command_vector, int quant_packages, int *command_size, int *quant_packages_received)
```

- `receiver_enable` - Access `REG_SET` to activate the peripheral Receiver on the IP core
- `receiver_check_usedw` - Access the address that indicates how many packages are in the receiver FIFO
- `receiver_request_package` - Access `BASE_RECEIVER_DATA` to read the received package
- `receiver_empty` - Access `REG_SET` to check whether the receiver FIFO is empty or not
- `receiver_rdreq` - Access `REG_SET` to set the `read_request` flag with a pulse
- `receiver_get_package` - Separates the package from `receiver_request_package` into data and mask

## Example of Main code