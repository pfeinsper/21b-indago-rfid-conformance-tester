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

In the main code the user can choose which commands they want to send to the TAG, to see if it responds properly according to the EPC-GEN2 protocol. Also It is possible to make timing tests by varying the Tari values, to check if the Tag will respond accordingly. This also permits the user to implement new commands such as proprietary or custom ones.

The group has prepared a set of examples in which this code will be used by the final user. For example, if the user wants to test it's reader or even make a simulation in ModelSim, they must copy the file loopback_handshake.c from the folder ./examples_of_main to the main code located [here](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/main.c). By executing this code inside the main, what the user will be able to see and test will be shown later in the section Example of Main code. This folder can be found [here](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/tree/main/fpga/example_of_main).

Besides the [loopback_handshake.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/examples_of_main/loopback_handshake.c)
 the others examples of main codes are the [reader.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/examples_of_main/reader.c)
, the [tag.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/examples_of_main/tag.c)
 and the [test_individual_commands_loopback.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/examples_of_main/test_individual_commands_loopback.c)
 which are variations that are capable, respectively, of making the job of a Reader or emulating a Tag and even testing the send and receive of a single command in a single fpga.


## Config.h - Starting Variables

Inside the /helpers folder the first group to be explained are the defines that declares the addresses in which the previous page, IP core Interface, acts. IN this file there are also defines that store default values for package, command and mask sizes. Those defines are in more detail right below.

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
- `BASE_REG_RTCAL`      - W   - address of receiver transmitter calibration
- `BASE_REG_TRCAL`      - W   - address of transmitter receiver calibration
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

As described in the Mandatory Commands subsection inside the [Project Overview](index.md) page, the group has implemented all the mandatory commands, a couple of them still need to be validated, but the ones that are necessary for a full handshake are both implemented and deeply tested.

### Command Struct and CRC
Both the Command Struct and the CRC files are not together with the rest of the commands, because they are not exactly commands they actually are part of the build of each command depending on the demands of the protocol.

#### Command Struct
[/main/fpga/software/rfid_test/helpers/commands/command_struct.h](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/command_struct.h)

The first, is the Command Struct which establishes the base struct that every command will have in common. Which is composed by the commands size and data. It can be seen in the box below.
```c
typedef struct
{
    int size;
    unsigned long long result_data;
} command;
```
#### Cyclic Redundancy Check - CRC-5/CRC-16
[/main/fpga/software/rfid_test/helpers/commands/crc.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/crc.c)

Secondly, the  CRC code was added by the previous group. It comes from the BarrGroup, a verified hardware site, which is cited and documented properly inside the file. 

The CRC implemented by them, in the C language, is the same that the EPC-GEN2 documentation requires and as it is an Open Source code, just like this project, the group maintained and made use of it. 

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

#### Table of commands 

The Mandatory commands were already explained in the [Protocol EPC-GEN2 UHF RFID](index.md) subsection, so here in the Firmware page it will be presented just their status of implementation in the following table. The tested column stands for the commands that were sent and received properly, the Validated one means that the whole command was built according to the EPC-GEN2 protocol and functional means that it is also already interpreted correctly once sent or received by the tag or by the reader. The last column is the ToDo, which is the one that indicates if that specific command has a GitHub issue to be completed.


|   commands   | tested | validated | functional | ToDo |
|:------------:|:------:|:---------:|:----------:|:----:|
|      Ack     |    x   |     x     |      x     |      |
|     Kill     |    x   |           |            |   x  |
|     Lock     |    x   |           |            |   x  |
|      Nak     |    x   |     x     |      x     |      |
|     Query    |    x   |     x     |      x     |      |
| Query_adjust |    x   |     x     |      x     |      |
|   Query_rep  |    x   |     x     |      x     |      |
|     Read     |    x   |     x     |            |      |
|    Req_rn    |    x   |     x     |      x     |      |
|     Rn16     |    x   |     x     |      x     |   x  |
|    Rn_crc    |    x   |     x     |      x     |      |
|    Select    |    x   |           |            |   x  |
|     Write    |    x   |     x     |            |      |

#### Example of command build: The Ack command
[/main/fpga/software/rfid_test/helpers/commands/ack.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/ack.c)

The Ack command was fully implemented and it`s code can be seen in the box below:

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



## Functions

### Main.c - Start of Communication Values
[/main/fpga/examples_of_main/](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/examples_of_main/)

In each variation of the main code present inside the folder examples_of_main, a sample of code is common between them all and it is the set of all the time parameters mentioned in the Signal Generator section inside the [Hardware page](hardware.md). 

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
- `RTcal`       - Receiver transmitter calibration parameter
- `TRcal`       - Transmitter receiver calibration parameter

### RFID.c

[/main/fpga/software/rfid_test/helpers/functions/rfid.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/functions/rfid.c)

The RFID code comes first in use inside the main, because it stores the functions that set all the needed parameters to the test to be launched. Such as functions that set the time parameters, functions that help with mask translations and the ones that check if an answer received is a valid command. They are all described below:  

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

This file is responsible for the functions of control of the Sender peripheral, it has the functions that enable the peripheral, the ones that prepares the commands in the proper format to be sent to the TAG and also the one that actually sends it. for more information they are presented below:

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
- `sender_check_fifo_full` - Access `REG_STATUS` to verify whether the FIFO is full or not
- `sender_enable` - Access `REG_SET` to activate the peripheral Sender on the IP core
- `sender_send_package` - Writes the package on the FIFO address
- `sender_send_end_of_package` - Writes the EOP on the FIFO address
- `sender_start_ctrl` - Access `REG_SET` to activate the sender controller with a pulse
- `sender_write_clr_finished_sending` - Access `REG_SET` to clear the `finished_sending` flag with a pulse
- `sender_read_finished_send` - Access `RES_STATUS` to check whether the package has been sent or not
- `sender_get_command_ints_size` - Check the size of the command and calculates the size of each smaller package
- `sender_add_mask` - Divides the command into smaller packages if needed and generates a mask based on the current package data size
- `sender_has_gen` - Access `REG_SET` to define wether the generator should be activated
- `sender_is_preamble` - If the generator is activated, defines if the generator is a preamble or a frame sync
- `sender_send_command` - Runs the all the functions related to the command, going through all the steps necessary to split in packages, add the masks, send and clear the flag registers in the end


### Receiver.c

[/main/fpga/software/rfid_test/helpers/functions/receiver.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/functions/receiver.c)

This section of code stores all the functions necessary to retrieve data from the IP core, which is composed by the functions that enable the peripheral Receiver, the ones that check the fifo for data and also the ones that request a new package. As the previous two, they are all described below:

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

As mentioned in the Main Code subsection, there are a set of examples already implemented in which the  user can work on tests and communication between reader and tag. All those files are located in the 
[examples_of_main](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/tree/main/fpga/examples_of_main) folder and in this section a walk-through the code will be described so that the functionality of the project can be clarified.

The chosen file to this walk-through is the [test_individual_commands_loopback.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/examples_of_main/test_individual_commands_loopback.c), because it is succinct and sufficient to evidence a simple communication in loopback mode.

First, the header of the code brings all the necessary imports to this test, the IO is the NIOS II import that permits the communication with the IP core Interface, the System.h brings the functionalities of the FPGA followed by all the proprietary codes of functions and commands imports.Follows this header of the C code in the box below:

```c
#include "io.h"
#include "system.h"
#include "stdint.h"
#include "helpers/commands/commands.h"
#include "helpers/functions/functions.h"
#include "stdio.h"
#include "helpers/config.h"
```
Sencond, now inside the main function, there is the setting of the environment, in which the time parameters are calculated, followed by the definition of the loopback function that indicates a test with the same fpga and the set of the [signal generator](hardware.md).
Also in this sample the peripherals sender and receiver are being enabled, as both of them will be needed. 

```c
 // Time parameters
	int tari_100  = rfid_tari_2_clock(10e-6, FREQUENCY);
	int pw        = rfid_tari_2_clock(5e-6, FREQUENCY);
	int delimiter = rfid_tari_2_clock(62.5e-6, FREQUENCY);
	int RTcal     = rfid_tari_2_clock(135e-6, FREQUENCY);
	int TRcal     = rfid_tari_2_clock(135e-6, FREQUENCY);
    //configurations------------------------------------------------------------------------------
    rfid_set_loopback();
    rfid_set_tari(tari_100);
    sender_enable();

    receiver_enable();
    rfid_set_tari_boundaries(tari_100 * 1.01, tari_100 * 0.99, tari_100 * 1.616, tari_100 * 1.584, pw, delimiter, RTcal, TRcal);
    sender_has_gen(0);
    //sender_is_preamble(); // NOTE: enable this function if implementing RFID tech

```

A disclaimer about the sender_is_preamble, which is responsible, as mentioned in the sender functions subsection, to the signal generator is that it is muted in the code because the team did not implemented the radio frequency part of the project as accorded before with the professor and the mentor, but once it is implemented the necessary preamble or frame-sync is ready for use.  

Now it is necessary to send the desired command to be tested and validated. So in the following sample a Ack command will be built and sended. 

```c
    printf("==============================\n");
    printf("==       TEST COMMAND       ==\n");
    printf("==============================\n");

    command rn16;
    rn16_build(&rn16);

    command ack;

    ack_build(&ack, rn16);

    printf("sending ack\n");

    sender_send_command(&ack);

    printf("sent ack\n\n");

```

The Ack command also needs a random number in it`s built that is why it was also instantiated.

Last, it is necessary to read the IP core for the sended previous command, so the following box of code is responsible to retrieve that data from the IP.

```c
    int quant_packages = 3;
    int command_size = 0;
    int packages[quant_packages];

    printf("waiting for packages\n");

    if (receiver_get_package(packages,quant_packages, &command_size) == -1)
    {
        printf("exiting on receiver\n");
        return 1;
    }

    printf("command_size: %d\n", command_size);
    int label = rfid_check_command(packages, command_size);
    printf("label is: %d\n\n", label);
```

Wrapping all this code a command shall be sent, received and also validated.  

For more information on how to run it and get the outputs for it see the Testing / Running section of the [Getting Started](getting_started.md) page.