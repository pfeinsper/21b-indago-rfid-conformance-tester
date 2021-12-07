# 21b-indago-rfid-conformance-tester

This is a Conformance Tester for Tags EPC-GEN2 UHF RFID, an Open-Source project built by four Computer Engineering students at Insper Instituto de Ensino e Pesquisa, together with Indago Devices Inc.

This project was developed using both VHDL and C programming languages and acts as an interrogator communicating with a tag to test all the mandatory commands specified in the EPC-GEN2 protocol.

A full tutorial on how to clone and run the project is available [here]( https://pfeinsper.github.io/21b-indago-rfid-conformance-tester/getting_started/).

Our implementation was done on a DE10-Standard Terasic FPGA and focuses on creating the tester device capable of generating encoded mandatory commands, sending them to the tag, as well as decoding and analyzing the responses.

![Reader diagram](./docs-src/hardware/reader.png)

 The first component is the Nios II soft processor, which splits the commands into smaller packages (including data and mask), and sends them to the IP core so they can be encoded and sent. The processor is also responsible for interpreting the responses of the tag, after they have been decoded by the IP core.
 
The packages are a method to easily deal with the variable sizes of the mandatory commands since there is no specification about their size in bits. More information on how this is done can be found on the hardware section of the GitHub-pages documentation.

![Package diagram](./docs-src/hardware/package.png)

The second main component of the reader is the IP core, responsible for the communication with the tag, as well as encoding and decoding commands. Since these are two separate tasks, the IP core itself is separated into Sender and Receiver.

![IP core diagram](./docs-src/hardware/ip.png)

Currently our project can fully run the handshake process defined in the protocol, as well as independently check some of the mandatory commands.
