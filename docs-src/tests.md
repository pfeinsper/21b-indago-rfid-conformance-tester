# Testing the Components

Due to the complexity of our .vhd files, they had to be extensively tested individually. This was done through the ModelSim software, which enabled us to simulate values and compare the results with the expected ones.

## Sender

[/main/fpga/RTL/tb/sender_tb.vhd](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/RTL/tb/sender_tb.vhd)

The sender_tb.vhd file tests the sender component by simulating a series of commands, each divided in packages, to be encoded and sent. Each component was manually inserted into the test bench, as the group knew what the sender output should be once the commands had been encoded, and compared the results obtained.

### FMO Encoder

[/main/fpga/RTL/tb/FM0_encoder_tb.vhd](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/RTL/tb/FM0_encoder_tb.vhd)

The FM0_encoder_tb.vhd file tests the sender encoder component in regards to the encoding process and FIFO communication. 

The encoding process tests happen in the same way as the sender tests, in which the program simulates a series of commands, each divided in packages. Each component was manually inserted into the test bench, as the group knew what the encoder output should be once the commands had been encoded, and compared the results obtained.

The FIFO communication test by simulating a FIFO component, and the test bench compares the values of the communication cable to their intended results.

### Sender Controller

[/main/fpga/RTL/tb/sender_controller_tb.vhd](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/RTL/tb/sender_controller_tb.vhd)

The sender_controller_tb.vhd file tests the sender controller component by simulating the flags that dictate its functionalities, those being the `has gen`, `start encoder`, `start generator`, `clr_finished sending`.

### Signal Generator

[/main/fpga/RTL/tb/signal_generator_tb.vhd](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/RTL/tb/signal_generator_tb.vhd)

The signal_generator_tb.vhd file tests the sender signal generator component by simulating the flags that dictate its functionalities, those being the `has gen`, `start generator`, `is_preamble`.

## Receiver

[/main/fpga/RTL/tb/receiver_tb.vhd](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/RTL/tb/receiver.vhd)

The receiver_tb.vhd file tests the receiver component by simulating a series of commands, each divided in packages, as a response being sent from the TAG. Each component was manually inserted into the test bench, as the group knew what the sender output should be once the commands had been decoded, and compared the results obtained.

### FM0 Decoder

[/main/fpga/RTL/tb/FM0_decoder_tb.vhd](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/RTL/tb/FM0_decoder_tb.vhd)

The FM0_decoder_tb.vhd file tests the receiver decoder component by simulating a series of commands, each divided in packages. Each component was manually inserted into the test bench, as the group knew what the decoder output should be once the commands had been decoded, and compared the results obtained.

### Package Constructor

[/main/fpga/RTL/tb/FM0_decoder_tb.vhd](https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/RTL/tb/package_constructor_tb.vhd)

The package_constructor_tb.vhd file tests the receiver package constructor component by simulating a decoder component that sends decoded data to the package constructor, which once correctly packaged should result in full commands that are compared to the expected command outputs.

## How to run the test bench

Below is a video explaining how to run the tests on a vhd file: