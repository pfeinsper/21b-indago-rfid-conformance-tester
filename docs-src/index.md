# Conformance Tester for TAGs EPC-GEN2 UHF RFID

- **Students:** Alexandre Almeida Edington / Bruno Signorelli Domingues / Lucas Leal Vale / Rafael Dos Santos
- **Course:** Computer Engineering
- **Semester:** 8
- **Teacher:** Rafael Corsi Ferrão
- **Contact:**
    - alexandreae@al.insper.edu.br
    - brunosd1@al.insper.edu.br
    - lucaslv1@al.insper.edu.br
    - rafaels6@al.insper.edu.br
    - rafael.corsi@insper.edu.br
- **Year:** 2021
- **Repository:** https://github.com/pfeinsper/21b-indago-rfid-conformance-tester
## About

This project aims to develop an equipment capable of performing a series of tests on RFID TAGs, based on the communication protocol "EPC-GEN2 UHF RFID" [^1]. The project simplifies the development of  new TAGs that conform to the defined protocol, being able to assert wether the tag satisfies the requirements of said protocol, and also wether the TAG itself is working as intended.

[^1]: EPC UHF Gen2 Air Interface Protocol.
<https://www.gs1.org/sites/default/files/docs/epc/Gen2_Protocol_Standard.pdf>
Accessed on: 16/08/2021.

### Insper

This project is being developed by four computer engineering students at "Insper Instituto de Ensino e Pesquisa" [^2], together with "Indago Services Inc." [^3]. As part of their completion of course work, the students must communicate with their selected company to identify a problem the company currently has and work together to find and implement a solution to it. For each group of students there is also a teaches that acts as a mentor and aids the group with matters of communication, organization, meetings, and project and report feedbacks.

[^2]: Insper Instituto de Ensino e Pesquisa.
<https://www.insper.edu.br/>
Accessed on: 16/08/2021.

[^3]: Indago Devices Inc..
<https://indagodevices.com>
Accessed on: 16/08/2021.

### Indago Devices Inc.

Indago Devices Inc. is a startup that has its headquarters in the city of Birmingham Alabama, US, and works in the field of development and study of electronics. Despite having few employees, it seeks to innovate in the electronics market, specifically in the development of systems that communicate through RFID. They had already been communicating with Insper in the previous semester, and also another group of students who planned to do a similar project. This semester they decided to request a conformance tester to help develop RFID TAGs. One of the driving points of the project is that currently there is no similar sofware avaliable on open source for the RFID community, so it could impact not only their company, but also the worldwide RFID development community.

## Project Overview

The main objetive of this project is to develop and assemble a conformance tester for RFID TAGs where a microcontroller will be implemented and an IP Core for communication with the DUT (device under testing). This device then shall be able to run a series of tests as a READER interacting with a TAG through the EPC-GEN2 protocol, analysing if the TAG works as intended and complies with the requirements of the protocol.

The tests will be implemented using C, allowing for a large amount of tests to be made that target different aspects of the TAG's process, independently evaluating most of them. Also, it will be possible to customize the tests or develop new ones should the user need to do so.

This project does not make use of RFID communication, nor does it intend to test wether the TAG is able to communicate through it. Given the compleity of communicating through radio waves, the group and the teacher agreed to not cover those points in this project. Therefore, the device, TAG and computer shall be connected by cables. 

### Protocol EPC-GEN2 UHF RFID

Documentation avaliable on: <https://www.gs1.org/sites/default/files/docs/epc/Gen2_Protocol_Standard.pdf>

The main purpose of this protocol is to allow two pieces of hardware, obtained independently, but conforming to the protocol, to communicate flawlessly. To achieve this, it specifies how physical and logial interactions should take place, as well as the possible commands between READER and TAG.

There are rules defined for both READER and TAG, however, due to the nature of this project, we will focus only on the TAG, as it is the focus of the tests devised.

To claim compliance with the protocol, a TAG must meet all required specifications, having implementd all mandatory commands, be able to modulate a response signal after receiving a command from a READER, and comply with all government radio regulations. Optionally, it is allowed to implement any number of non-mandatory commands defined in this protocol and any other private commands that do not conflict with any of the mandatory ones. Finally, the TAG must not require a READER to be able to process any non-mandatory comand for this protocol, and is not allowed to modulate a response signal unless it has been commanded to do so by a READER using the commands present in this protocol.

### State-of-the-Art Review

The market currently has very diversified solutions in relation to RFID technology. Among the options currently available, proprietary equipment and products are the main competitors, as they are developed by well-established companies. For example, CISC semiconductor [^4], specializing in RFID and NFC services, and working both in the production of laboratory equipment and product testers for the market. Another company that is worth mentioning is HID global [^5], which has several solutions for RFID tags end operates worldwide under sales and distribution of these products.

There are, however, other solutions present in the market, such as open-source solutions. As proprietary products are expensive and not easily customizable, some users choose to develop their own version of those products, leaving them open for others to use and improve. The use of open source helps to develop a highly customizable product, as every user can download the program and make their own changes to better suit their need. Another benefit of open source is the collaboration aspect, where users around the world can suggest changes or improvements, as well as implement them to improve the overall product.

An example of an open-source product is the WISP5 [^6] tag, initially developed at the University of Washington [^7]. The WISP is a battery-free platform with a software-defined implementation of a passive RFID tag, that can communicate with commercial-off-the-shelf RFID readers and is powered by the carrier signal emitted by the reader. It is also built from low-cost components commonly found in hardware stores, allowing WISP users to fabricate their own platforms if desired.

Another open-source product is the S.U.R.F.E.R. (Software-defined UHF RFID Flexible Economical Reader) [^8], an RFID reader. It operates with the same technology as the WISP5 tag, enabling readings up to 60 feet (20 meters) away. Due to it being software-defined, the reader is highly versatile, as the user can input the specifications of the desired tag into the software. It also has a relatively simple structure to find, which result in a low-cost product.

Open-source products bring a series of benefits to the users, such as lesser hardware and software costs, due to the products being intentionally built to be easily accessible; simple licensing management because they often are free to use and impose no restrictions at all; abundant support, as there are many companies that develop open-source products and offer both free and varied levels of paid support.

Given these advantages, Indago Devices opted for a completely open-source product as well. In a meeting with our mentor Wallace Shepherd Pitts, he mentioned he had previously researched and studied some of the options currently available, but nothing had fit with what he had in mind, because the products offered little room for customization regarding the tests made to the tag.

The direct competitors of our project would be the previously mentioned products, which dominate the current market. However, as we are aiming for the open-source architecture, it may attract users interested in a more accessible or customizable product.

Another point mentioned by our mentor is that he also intends to use the project as study material for students at the University of North Carolina [^9], which consequently opens up possibilities for further expansion of the product.

[^4]: Cisc Semiconductors.
<https://www.cisc.at/>
Accessed on: 20/09/2021.

[^5]: HID Global.
<https://www.hidglobal.com/products/rfid-tags>
Accessed on: 20/09/2021.

[^6]: WISP5 Wiki.
<https://sites.google.com/uw.edu/WISP-wiki/home>
Accessed on: 20/09/2021.

[^7]: University of Washington.
https://www.washington.edu/
Accessed on: 20/09/2021.

[^8]: S.U.R.F.E.R. reader.
<https://openrfidreader.net/>
Accessed on: 20/09/2021.

[^9]: University of North Carolina.
https://www.uncg.edu/
Accessed on: 20/09/2021.

### Methodology

During the first weeks of the project, the group settled on definitions and agreements on what would be the methodology used throughout the semester, as well as the different tools and softwares that would be used.

The platform GitHub was chosen as the method for sharing the code between the group members and the teacher, as it can store many important files other than code files, such as diagrams and images the group would produce for the project. Another feature often used by the group is the creation of issues, which can help define and order the group’s next tasks and assign members to complete them.

The day-to-day communication between the members were done through Discord, and meetings with Indago’s representative or the PFE’s coordinators though Microsoft Teams. As meetings with a member of the company were infrequent, taking place every fortnight, the group usually kept a list of questions and issues about the EPC-GEN2 protocol and the project in general so that the representative could provide some support.

Documents and reports were produced and stored in Google Drive, so that multiple members could work on them simultaneously, and also be accessed by the teacher to provide insights and feedback. It also served as another backup storage to the Github repository, in case any problems occurred.

The programming languages VHDL and C were used throughout the project, through the softwares Quartus and Eclipse, which support simulations and tests that aid in the development process. As the client specified that he wanted the project to be open-source, all code, reports and images relevant to this will also be available on the project’s public GitHub repository.

As the project consists of the creation of a conformance tester for the EPC-GEN2 UHF RFID protocol, its documentation was widely used, researched, and discussed by all members of the group during the project, focusing mainly on the communication sections between the READER and TAG, as well as encoding data, and mandatory commands for protocol standards.

Since the project was open-source and available on GitHub, it was decided that the group would also provide a documentation to the whole project, which was later decided would be available through GitHub Pages. Inside, the group would give an in-depth description of all components, and also a tutorial on how to clone, run, utilize and modify this project.

### File Hierarchy

All necessary VHDL hardware description files are located in the project’s fpga/rtl/ folder. The top entity of the entire processor including all the required configuration generics is rfid.vhd.

    rfid.vhd                   - Conformance tester top entity
    │
    ├sender.vhd                - Sender component top entity
    │├FIFO_fm0.vhd             - Encoder-specific FIFO
    ││├FM0_encoder.vhd         - Encoder-FM0-specific FIFO
    ││└fifo_32_32.vhd          - General use FIFO
    │├sender_controller.vhd    - Controls the flow of packets to the TAG
    │└signal_generator.vhd     - Generates preamble or frame-sync signal
    │
    └receiver.vhd              - Receiver component top entity
     ├FM0_decoder.vhd          - Decoder-FM0-specific FIFO
     ├fifo_32_32.vhd           - General use FIFO
     └package_constructor.vhd  - Stores bits into packets before storing in the FIFO
