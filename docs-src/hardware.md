# Hardware

For this project, the chosen solution for implementing the conformance tester was to develop a dedicated hardware in FPGA [^10]. The chosen product was the DE10-Standard produced by Terasic as well as a FPGA Cyclone V from Intel. The teacher had ample experience working with this specific model, and it also perfectly fits the requirements need to implement the chosen solution. This is because, through a tool called "platform designer", it can edit its configuration on demand, allowing great flexibility when needed.

The proposed solution makes use of Intel's solution development ecosystem, providing flexibility in the use of a soft processor, enabling the integration of peripherals called IP cores to its architecture, as well as allowing the creation of new instructions implemented in the hardware. For more information on these modifications, see the document "NIOS II Custom Instruction User Guide" [^11].

[^10]: FPGA Intel.
<https://www.intel.com.br/content/www/br/pt/products/programmable.html>
Accessed on: 23/08/2021

[^11]: Nios II Custom Instruction User Guide.
<https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/ug/ug_nios2_custom_instruction.pdf>
Acessed on: 23/08/2021.

## File Hierarchy

All necessary VHDL hardware description files are located in the project’s <guide>fpga/RTL</guide> folder. The top entity of the entire processor including all the required configuration generics is rfid.vhd.

    rfid.vhd                   - Conformance tester top entity
    │
    ├sender.vhd                - Sender component top entity
    │   ├FIFO_fm0.vhd             - Encoder-specific FIFO
    │   │  ├FM0_encoder.vhd         - Encoder-FM0-specific FIFO
    │   │  └fifo_32_32.vhd          - General use FIFO
    │   ├sender_controller.vhd    - Controls the flow of packages to the TAG
    │   └signal_generator.vhd     - Generates preamble or frame-sync signal
    │
    └receiver.vhd              - Receiver component top entity
        ├FM0_decoder.vhd          - Decoder-FM0-specific FIFO
        ├fifo_32_32.vhd           - General use FIFO
        └package_constructor.vhd  - Stores bits into packages before storing in the FIFO

## Packages and commands

This project uses the mandatory commands specified in the EPC-GEN2 documentation. However, those commands have varying sizes and even the same command could vary its size based on the data it sends. To work with this fluctuating command bit size, the group decided to separate the commands into 32-bit packages, where the 26 more significant bits are the actual data of the packet, and the 6 less significant are the mask, indicating how many of the 26 are in use.

![Package structure](./hardware/package.png)
*Package visual example*

This way, there are three possible situations given the command sizes:

- The command is larger than one package: if the command has more than 26 bits, it is split into multiple packages, communicated in order through the components (more significant -> less significant);
- The command is the same size as the package: the easiest case, where the package is treated as the full command;
- The command is shorter than one package: in this case  the package will be filled up to the number of bits the command has, and then use the mask to communicate how many of the data bits in the package are useful, ignoring the ones not needed to the command;

For example, if a command has 40 bits, it will be separated into two packets. The first one uses the 26 data bits, and the mask <guide>011010</guide> (26) to indicate all the data bits are in use. Then, the second package would only use 14 of the 26 data bits available to reach the 40 bits the command has, and so the mask would be <guide>001110</guide> (14) to indicate that only 14 bits should be analyzed.

To communicate between the components that the command is over, a <guide>void package 0x000000</guide> is sent after the last package of the command. This occurs in two times in the product: first, when sending the command to the TAG, the NIOS II sends a void package to the Sender to indicate the command is over. Second, when receiving the response from the TAG, the Recevier sends a void package to the NIOS II to indicate that the command received is over.

## READER

The READER, as shown in the diagram below, is the toplevel of the vhdl components, which contains the three main components. An in depth analysis is present in the sections below.

![Reader diagram](./hardware/reader.png)
*Reader component visual diagram*

The first one is the NIOS II soft processor, where the group programmed the tests that will be run on the TAG. Therefore, its responsible for generating the commands for communicating with the TAG, as well as interpreting the responses it receives, to assert whether the TAG passes or fails each test.

The second component is the IP core, developed in VHDL, and is responsible for encoding and sending messages to the TAG, as well as decoding any responses and passing the through to the processor. Those two tasks have been separated into the sender and the receiver respectively.

The last one is the Avalon Interface, is the connection between the NIOS II and the IP core, where the commands, generated in the programming language C, will be passed on to the VHDL sender, and responses will take the opposite path, going from the receiver to the processor.

### IP CORE

[/main/fpga/RTL/rfid.vhd](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/RTL/rfid.vhd)

The developed peripheral can be split into two components, visualized in the diagram below. Those are the SENDER, in red, responsible for receiving the data from the NIOS II, encoding and forwarding them to the TAG; and the RECEIVER, in blue, responsible for receiving the data from the TAG, decoding and forwarding them to the NIOS II.

![IP Core](./hardware/ip.png)
*IP core visual diagram*

### SENDER

[/main/fpga/RTL/sender.vhd](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/RTL/sender.vhd)

This component is responsible for encoding the commands generated by the processor, and send them to the TAG, respecting the rules of the EPC-GEN2 protocol, including the tari, preamble and EOP. Its components are detailed below:

#### FIFO

[/main/fpga/fifo_32_32.vhd](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/fifo_32_32.vhd)

The first component of the SENDER is the FIFO, a storage system that receives the assembled commands from the NIOS II and waits for the encoder to send the <guide>read request</guide> flag, signaling for the FIFO to send the oldest package. It is possible that the command to be sent to the TAG is composed of more than one package, so the FIFO serves as a storage system for packages already received from the processor until it signals that the entire command is ready for encoding.

For this project, the group opted to use the FIFO produced by Intel, which was obtained through the Quartus automatic generator, the main software used by the group for programming in VHDL language. It is possible to include several customizations before generating the code, and thus, the group defined that the FIFO would have the settings below: 

**FIFO charactersitics**

- IP variation file type <guide>VHLD</guide>;
- Synchronous reading and writing to clock;
- 32 bits per word;
- 256 word depth;
- <guide>full</guide>, <guide>empty<guide>/, <guide>usedw</guide> (number of words in fifo), <guide>synchronous clear</guide> (flush the FIFO);
- Memory block type <guide>auto</guide>;
- Not registered output;
- Circuitry prtotection enabled;

#### FIFO_FM0

[/main/fpga/RTL/fifo_fm0.vhd](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/RTL/fifo_fm0.vhd)

FIFO-FM0 is a component created to separate the data encoding component from the signal-generator and the sender-controller, mapping the inputs: <guide>data</guide> to be encoded, <guide>write request</guide> for the FIFO, <guide>enable</guide> and <guide>tari</guide> to the other components, allowing for individual control of each component.

#### Encoder

[/main/fpga/RTL/FM0_encoder.vhd](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/RTL/FM0_encoder.vhd)

The encoder is the main component of the sender, being responsible for encoding the packages received from the FIFO with FM0 band, as specified in the EPC-GEN2, as well as sending the encoded data to the TAG. for this purpose, a refined control of the time intervals is necessary to obey the tari, also defined in the protocol as being between 6.25μs and 25μs.

This component has two state machines that work simultaneously, one responsible for communicating with the FIFO and sending it to the TAG, while the other encodes the received data. The diagram below demonstrates the first state machine:

- <guide>Wait</guide> is the encoder's default, the state it remains in while it doesn't receive any new packages to encode;
- <guide>Start Send</guide> is the most complex state, where another state machine is present inside it, which is responsible for encoding the packages. Furthermore, it also expects to receive the correct tari to send data to the TAG;
- <guide>Wait Send</guide> is a temporary state for when the data has not been fully encoded, and therefore needs to wait until the other state machine finishes the encoding.;
- <guide>Request Data</guide> happens after the data has been sent, and signals the FIFO to send more data. This state is very short, as its only duty is to send a flag to the FIFO, and immediately change to the <guide>Wait Request</guide> state;
- <guide>Wait Request</guide> can happen in two situations. First, if the Encoder is waiting for the next package from the FIFO, going back to the <guide>Start Send</guide> state once it is received. Second, it can happen once the FIFO sends the <guide>FIFO_empty</guide> signal to the Encoder, in which case the void package is removed, waiting for the next command;
- <guide>Wait 1.6 tari</guide> is the formal completion of the command sent to the TAG, where a <guide>dummy 1</guide> bit is sent, which will remain active for 1.6 tari and then stop the communication;

![Encoder diagram](./hardware/encoder.png)
*Encoder state-machine visual diagram*

The next image demonstrates the other state machine present in the component, responsible for the encoding of the data. It was defined that it would always start in state <guide>S3</guide>. FM0 encoding transforms each bit of information into two bits, in such a way so that a <guide>1</guide> becomes two bits of the same value (either <guide>1 1</guide> or <guide>0 0</guide>), and a <guide>0</guide> becomes two bits of different values (either <guide>1 0</guide> or <guide>0 1</guide>), where the signal always alternates when encoding a new bit. The change of state occurs after each bit has been sent and is defined by the value of the next bit.

- <guide>S1</guide> encodes <guide>1</guide> into <guide>1 1</guide>;
- <guide>S2</guide> encodes <guide>0</guide> into <guide>1 0</guide>;
- <guide>S3</guide> encodes <guide>0</guide> into <guide>0 1</guide>;
- <guide>S4</guide> encodes <guide>1</guide> into <guide>0 0</guide>;

![FM0 State diagram](./hardware/FM0_1.png){style= "width: 50%;"}

*EPC UHF Gen2 Air Interface Protocol, p 32*

![data-0 and data-1](./hardware/FM0_2.png){style= "width: 60%;"}
*EPC UHF Gen2 Air Interface Protocol, p 32*

The previously defined <guide>dummy 1</guide> acts as the <guide>EOP</guide> of a command passed to the TAG, however it also needs to be encoded, and is always followed by a <guide>0</guide> bit. This is shown in the image below.

![FM0 End-of-Signaling](./hardware/FM0_3.png){style= "width: 60%"}

*EPC UHF Gen2 Air Interface Protocol, p 33*

#### Signal Generator

[/main/fpga/RTL/signal_generator.vhd](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/RTL/signal_generator.vhd)

This component encompasses both the Preamble and Frame-sync functions, and receives flags to determine which one, if any, will be activated.

The Frame-sync is responsible for defining and regulating the interval at which information is sent to the TAG, and sharing this interval to all other SENDER components, so that they can communicate within the correct time intervals. This period, named tari, must be within the range defined in the protocol, and have a variation of less than 1% between each pulse.

![Frame-sync](./hardware/Framesync.png){style= "width: 70%"}

*EPC UHF Gen2 Air Interface Protocol, p 29*

The Preamble is responsible for the first wave of information sent to the TAG for each new command, and it defines which tari will be used throughout the next command. This component needs to be activated for every command that is sent to the TAG, except when more than one command is sent in sequence, without a response in between. In this case, the preamble informed will be valid for all subsequent commands, until a response is requested.

![Preamble](./hardware/Preamble.png)
*EPC UHF Gen2 Air Interface Protocol, p 29*

### RECEIVER

[/main/fpga/RTL/receiver.vhd](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/RTL/receiver.vhd)

The RECEIVER is responsible for receiving the responses from the TAG, decode them, and notify the NIOS II processor that there was a response, as well as store each package of the response until the processor sends the <guide>read request</guide> flags to analyze them. In order for the received data to be interpreted, it is necessary that the information is decoded and grouped into packages, because it is possible the response is too large for the processor to receive all at once. The group decided to split the RECEIVER into three smaller components, shown and described below:

![Receiver diagram](./hardware/receiver.png)
*Receiver component visual diagram*

#### Decoder

[/main/fpga/RTL/FM0_decoder.vhd](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/RTL/FM0_decoder.vhd)

Since the TAG also communicates back to the READER using FM0 encoding, a decoder component is needed to decode the received data, allowing it to be interpreted by the processor. This component was built in a similar way to the sender, though it is a simpler process, and only one state machine was needed. The diagram below demonstrates the state machine programmed for this purpose:

- <guide>Wait</guide> is the decoder's default, the state it remains in while it doesn't receive any new data to decode;
- <guide>Start Counter</guide> starts a time counter as soon as the decoder receives new data, in order to determine if the bit will change after 0.5 or 1.0 tari, then passing to the next state. It is also possible for the bit to remain unchanged for more than 1.0 tari, in which case it will go to the <guide>Pass 1.01 tari</guide> state;
- <guide>Stop Counter</guide> sends <guide>1</guide> to the package constructor if the input signal has not changed, and <guide>0</guide> otherwise;
- <guide>Continue Counter</guide> is necessary because the stop counter always stop at 0.5 tari, so it is activated if no bit change occurs;
- <guide>Pass 1.01 tari</guide> is activated when the TAG sends the <guide>dummy 1</guide>, which has a duration of 1.6 tari, and checks if the times are in accordance with the protocol;
- <guide>Counter CS</guide> stops the counter and resets the decoder to its default state;
- <guide>ERROR</guide> is a state that can be activated by almost any other state, as they all check certain characteristics of that TAG that must comply with the protocol. If something is irregular, this status will be activated and will send an error message explaining what caused this to happen;

![Decode diagram](./hardware/decode_data.png)
*Decoder state-machine visual diagram*

#### Package Constructor

[/main/fpga/RTL/package_constructor.vhd](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/RTL/package_constructor.vhd)

This component is responsible for assembling the decoded bits into packages and storing them in the FIFO. It gathers the received bits until reaching the limit defined in the code, and then sending to the FIFO. If, however, the package constructor receives the <guide>EOP</guide> signal before completing the package, it will concatenate a mask with the current package to inform how many bits were filled. Lastly, it will the <guide>voi package</guide> to the FIFO and the processor, which indicates the RECEIVER has finished capturing and decoding the whole response command, and that it has been fully passed to the FIFO.

- <guide>Wait</guide> is the package constructor's default, the state it remains in while it doesn't receive any new data to store;
- <guide>New Bit</guide> happens when the decoder sends a decoded bit to the package constructor, which stores it in the current package being constructed;
- <guide>Inc Mask</guide> increases the package mask by 1 representing the new bit received;
- <guide>Max Mask</guide> checks whether the mask, and therefore the package, is full, preparing to send the package if it is;
- <guide>Send Package</guide> sends the current package to the FIFO, an intermediary step before going to the NIOS II processor;
- <guide>Check EOP</guide> checks if the EOP flag is high, and changes state based on the current packet. If it is empty, goes to the <guide>Send void</guide> state, if not goes to the <guide>Send Package</guide>;
- <guide>Clear</guide> clears the current package before starting a new one;
- <guide>Send Void</guide> send to the FIFO an empty package - <guide>0x000000</guide>

![Package constructor](./hardware/Package_constructor.png)
*Package constructor state-machine visual diagram*

#### FIFO

[/main/fpga/fifo_32_32.vhd](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/fifo_32_32.vhd)

The FIFO in the RECEIVER is the same as the one in the SENDER and serves similar purpose; however, its direction is inverted. This FIFO stores packages leaving the package constructor until it receives the <guide>EOP</guide> flag, which also signals the NIOS II that the command is ready to be requested. After this, the FIFO sends one package at a time to the processor whenever it receives a <guide>read request</guide> flag.
