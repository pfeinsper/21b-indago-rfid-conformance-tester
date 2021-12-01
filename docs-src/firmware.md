# Firmware

This section contains an explanation of the firmware/code of this project, which is centered around the Nios II soft processor.

## Nios II

The Nios II is a soft processor, which means that, unlike discrete processors, such as those in conventional computers, its peripherals and addressing can be reconfigured on demand. This enables the development of a specialized and efficient processor, reducing the costs and time of producing a prototype since it is dynamically generated inside the FPGA without the need to produce a new processor.

Communication between the Nios II and the peripheral IP core is done via the Avalon data bus, which is a memory-mapped peripheral. The addressing works as in a common memory, having write, read, and address signals, as well as the input and output vectors of this bus.

The Nios II function is to write the commands and tests in the register banks present in the IP peripheral, so that it can communicate with the tag. This processor can be viewed as the conductor and all other components as the orchestra, as it is responsible for enabling, configuring, reading, and writing data from the Avalon memory to the IP core.

Throughout this project, commands are separated into packages for ease of use. Details on how this is done can be found [here](hardware.md).

### File Hierarchy

All necessary C and header files are located in the project’s `fpga/software/rfid_test` folder. The top entity of the entire processor (including all the required configuration generics) is the `main.c` file, with all other relevant files present inside the helpers folder.

```
main.c                   - Nios II soft processor top entity
│
└/helpers                - Holds all complimentary C files
    │
    ├/functions             - Holds all functions that dictate how the components act
    │   ├sender.c              - Holds all functions that dictate how the sender acts
    │   ├receiver.c            - Holds all functions that dictate how the receiver acts
    │   └rfid.c                - Holds all functions about Tari, commands and packages
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

Additional information on the EPC-GEN2 protocol and mandatory commands (as well as the other command types) can be found [here](../#protocol-epc-gen2-uhf-rfid).

## Main code

[/main/fpga/software/rfid_test/main.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/main.c)

The software was developed in a way that it would be easy to understand it. It is responsible for calling functions, defines and commands structures from the `/helpers` folder, advantages that are present due to the C programming language being considered high-level. These features are all called in the `main.c` code, which is responsible for controlling and monitoring the IP core.

In the main code, the user can choose which commands they want to send to the tag, to see if it responds properly according to the EPC-GEN2 protocol. It is also possible to make timing based tests by varying the Tari values, to check if the tag will respond accordingly. This also allows the user to implement new commands, such as proprietary or custom ones.

The group has also prepared a set of examples in which this code will be used by the final user. For example, if the user wants to test their version of the reader or even make a simulation in ModelSim, they must copy the `loopback_handshake.c` (located [here](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/examples_of_main/loopback_handshake.c)) file from the `fpga/examples_of_main` folder to the main code located in the [`main.c`](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/main.c) file. Once this code is run, the user will be able to see and test different parameters, which will be shown later in the "Example of main code" section. This folder can be found [here](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/tree/main/fpga/example_of_main).

Besides the [loopback_handshake.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/examples_of_main/loopback_handshake.c), the other examples of codes that can be used in the `main.c` file are the [`reader.c`](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/examples_of_main/reader.c), the [`tag.c`](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/examples_of_main/tag.c) and the [`test_individual_commands_loopback.c`](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/examples_of_main/test_individual_commands_loopback.c), all of which are variations that are capable, respectively, of acting as a reader, emulating a tag and even testing the send/receive functionalities of a single command in a single DE-10 Standard board.

## `config.h` - Starting Variables

Inside the `/helpers` folder, the first group to be explained are the defines that declare the addresses in which the IP core interface (previously mentioned [here](IP_core_interface.md)) acts. In this file, there are also defines that store the default values for package, command and mask sizes. The following section explains them in more detail.

### Register Status

```C
//READ ONLY
define BASE_IS_FIFO_FULL    (1 << 0)
define MASK_EMPTY_RECEIVER  (1 << 13)
```

- `BASE_IS_FIFO_FULL`  - Indicates the necessary shift for the `is_FIFO_full` flag
- `MASK_EMPTY_RECEIVER` - Indicates the necessary shift for the `is_receiver_empty` flag

### Register Settings

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

### RFID - Addresses

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

### RFID - Command specifications

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

The group has implemented all the mandatory commands (described in the [Mandatory Commands subsection](../#mandatory-commands) page). A couple of them still need to be validated, but the ones that are necessary for a full handshake have been implemented and thoroughly tested.

### Command Struct and CRC

Both the Command Struct and the CRC files are separate from the rest of the commands, because they are not commands, but rather act in building each command, which depends on the protocol's requirements of the command.

#### Command Struct

[/main/fpga/software/rfid_test/helpers/commands/command_struct.h](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/command_struct.h)

The first is the Command Struct, which establishes the base struct that every command will have in common. It is composed by the command's size and data, as shown in the code block below.

```C
typedef struct
{
    int size;
    unsigned long long result_data;
} command;
```

#### Cyclic Redundancy Check - CRC-5/CRC-16

[/main/fpga/software/rfid_test/helpers/commands/crc.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/crc.c)

Secondly, the CRC code was designed by the previous group. It was designed by BarrGroup[^1], a verified hardware site, which is cited and documented properly inside the file.

[^1]: BarrGroup.
<https://barrgroup.com>
Accessed on: 05/10/2021.

The CRC implemented by them is the same that the EPC-GEN2 documentation requires, and as it is an open-source code, just like this project, the group maintained and made use of it.

The following code block shows one of the functions used in the CRC code.

```C
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
            // Try to divide the current data bit.
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

This section contains a table of the mandatory commands (described in the [Mandatory Commands subsection](../#mandatory-commands) page) with their respective statuses. In it, there are four columns:

- tested: these are the commands that were sent and received properly;
- validated: in this column are present the commands that were built solely around the EPC-GEN2 protocol specifications;
- functional: these are the commands that are already being correctly interpreted once sent or received by the tag or by the reader;
- ToDo: these are commands that have some issue concerning validation/functionality. These commands are present as issues in the GitHub repository.

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

#### Example of command build: the `ack` command

[/main/fpga/software/rfid_test/helpers/commands/ack.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/commands/ack.c)

The code block below shows an example of a command (in this case, the `ack` command):

```C
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

### `main.c` - First declaration of the time parameters

[/main/fpga/examples_of_main/](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/examples_of_main/)

In each variation of the main code present inside the `fpga/examples_of_main`, a sample of code is common between them all: these are all of the time parameters mentioned in the [Signal Generator section](../hardware/#signal-generator).

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

### `rfid.c`

[/main/fpga/software/rfid_test/helpers/functions/rfid.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/functions/rfid.c)

The RFID code's first appearance is in the main code, because it stores the functions that set all the needed parameters so that the test can be launched. Some of these functions set the time parameters, others are designed to interpreting the mask of the package, and the last few ones check if the answer received is a valid command. They are all described in the code block below:

#### RFID functions

```C
void rfid()
void rfid_set_tari(int tari_value)
void rfid_set_tari_boundaries(int tari_101, int tari_099, int tari_1616, int tari_1584, int pw, int delimiter, int RTcal, int TRcal)
int rfid_create_mask_from_value(int value)
int rfid_check_command(int *packages, int quant_packages, int command_size)
int rfid_get_ip_id()
```

- `void rfid_set_loopback` - Connects Tx on Rx, creating a loop. Used for testing the reader.
- `void rfid_set_tari` - Sets the Tari value on the IP core.
- `void rfid_set_tari_boundaries` -  Sets the Tari boundaries on the IP core.
- `int rfid_create_mask_from_value` - Generates the package's mask based on the package received.
- `int rfid_check_command` - Checks if the received command is valid and present on the EPC-GEN2 protocol.
- `int rfid_get_ip_id` - Checks the id of the IP core.

### `sender.c`

[/main/fpga/software/rfid_test/helpers/functions/sender.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/functions/sender.c)

This file is responsible for controlling the sender peripheral. It has functions that can enable the peripheral, properly format the commands in order to be sent to the tag and send the completed command. The code block below gives a little more insight on them.

#### Sender functions

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

- `sender_check_usedw` - Accesses the address that indicates how many packages are in the sender's FIFO.
- `sender_check_fifo_full` - Accesses `REG_STATUS` to verify whether the FIFO is full or not.
- `sender_enable` - Accesses `REG_SET` to activate the sender peripheral on the IP core.
- `sender_send_package` - Writes the package on the FIFO address.
- `sender_send_end_of_package` - Writes the EOP on the FIFO address.
- `sender_start_ctrl` - Accesses `REG_SET` to activate the sender controller with a pulse.
- `sender_write_clr_finished_sending` - Accesses `REG_SET` to clear the `finished_sending` flag with a pulse.
- `sender_read_finished_send` - Accesses `RES_STATUS` to check whether the package has been sent or not.
- `sender_get_command_ints_size` - Checks the size of the command and calculates how many packages will be sent.
- `sender_add_mask` - Divides the command into smaller packages if needed and generates a mask based on the current package data size.
- `sender_has_gen` - Accesses `REG_SET` to define whether the signal generator should be activated.
- `sender_is_preamble` - If the generator is activated, defines if the signal generator is a preamble or a frame sync.
- `sender_send_command` - Runs the all the previous functions related to the command, going through all the steps necessary to split it into packages, add the masks, send and clear the flag registers in the end.

### `receiver.c`

[/main/fpga/software/rfid_test/helpers/functions/receiver.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/software/rfid_test/helpers/functions/receiver.c)

This file stores all the functions required to retrieve data from the IP core, which in turn consist of the functions that enable the receiver peripheral, check the FIFO for data and also request a new package. The code block gives a little more information about these functions.

#### Receiver functions

```C
void receiver_enable()
int receiver_check_usedw()
int receiver_request_package()
int receiver_empty()
void receiver_rdreq()
void receiver_get_package(int *command_vector, int quant_packages, int *command_size, int *quant_packages_received)
```

- `receiver_enable` - Accesses `REG_SET` to activate the receiver peripheral on the IP core.
- `receiver_check_usedw` - Accesses the address that indicates how many packages are in the receiver's FIFO.
- `receiver_request_package` - Accesses `BASE_RECEIVER_DATA` to read the received package.
- `receiver_empty` - Accesses `REG_SET` to check whether the receiver FIFO is empty or not.
- `receiver_rdreq` - Accesses `REG_SET` to set the `read_request` flag with a pulse.
- `receiver_get_package` - Separates the package from `receiver_request_package` into data and mask.

## Example of main code

As mentioned in the [Main code subsection](../firmware/#main-code), there are a set of examples already implemented in which the user can work on tests and communication between reader and tag. All those files are located in the [`fpga/examples_of_main`](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/tree/main/fpga/examples_of_main) folder and in this section the code will be thoroughly described so that the functionality of the project can be clarified.

For this example, the[test_individual_commands_loopback.c](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/examples_of_main/test_individual_commands_loopback.c) file was chosen, because it is succinct and it suffices in showing a simple communication in loopback mode.

Firstly is the header of the code, which brings all the necessary includes to this test. The first one present is the `io.h`: this is the Nios II include that establishes the communication with the IP core interface; after that is `system.h`, which helps bring the functionalities of the FPGA. The following includes are the proprietary codes of the functions and the commands used. The code block below shows these includes.

```C
#include "io.h"
#include "system.h"
#include "stdint.h"
#include "helpers/commands/commands.h"
#include "helpers/functions/functions.h"
#include "stdio.h"
#include "helpers/config.h"
```

Following the includes is the main function, and inside it are the [first declaration of the time parameters](./#mainc-first-declaration-of-the-time-parameters), in which the time parameters are calculated, followed by the definition of the loopback function that indicates a test that is implemented using a single DE-10 Standard board and the setting of the [signal generator](../hardware/#signal-generator).
Also present are the enables of the sender and receiver peripherals, as both of them will be needed for this test.

```C
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

**Disclaimer:** the `sender_has_gen` function is set to disable the signal generator, and the `sender_is_preamble` (which is responsible for defining if the signal generated will be a preamble or a frame sync, previously mentioned [here](./#sender-functions)) is commented out in the code due to the team's decision of not implementing the radio frequency part of the project (explained in the [Project Overview section](../#project-overview)), but it is coded in case the radio frequency communication is implemented so that the user can know where to set these functions.

Now it is necessary to send the desired command to be tested and validated. So, in the following code, an ack command will be built and sent.

```C
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

The ack command also needs a random number in its build, hence why it was also instantiated.

Last, it is necessary to read the IP core for the command that has been sent in order to check if it has been properly received, as is shown the following code block.

```C
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

In sum, this code shows the whole process: the command to be sent, it being received and also validated.

For more information on how to run this (and the other examples of main code) and get the outputs for it, see the [Testing / Running section](../getting_started/#testing-running).
