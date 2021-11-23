### Software

Below is an axplanation of the software code of our project, the NIOS II processor.

#### NIOS II

The NIOS II is a soft processor, which means that, unlike discrete processors, such as those in conventional computers, its peripherals and adressing can be reconfigured on demand. This enables the development of a specialized and efficient processor, reducing the costs and time of producing a prototype sincce it is dynamically generated inside the FPGA without the need to produce a new processor.

Communication between the NIOS II and the peripheral IP CORE is done via the Avalon data bus, which is a memory-mapped peripheral. The addressing works as in a common memory, having write, read and address signals, as well as the input and output vectors of this bus.

The NIOS II function is to write the commands and tests in the register banks present in the IP peripheral, so that it can communicate with the TAG. This processor can be viewed as the conductor and all other components as the orchestra, as it is responsible for enabling, configuring, reading and writing data from the Avalon memory to the IP CORE.
