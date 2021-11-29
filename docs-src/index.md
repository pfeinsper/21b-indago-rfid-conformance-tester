# Conformance Tester for Tags EPC-GEN2 UHF RFID

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
- **Repository URL:** <https://github.com/pfeinsper/21b-indago-rfid-conformance-tester>

## About

This project aims to develop an equipment capable of performing a series of tests on RFID tags, based on the communication protocol "EPC-GEN2 UHF RFID" [^1]. This equipmment will help simplify the development of new tags that conform to the established protocol, being able to assert whether the tag satisfies the requirements of said protocol, and also whether the tag itself is working as intended.

[^1]: EPC UHF Gen2 Air Interface Protocol.
<https://www.gs1.org/sites/default/files/docs/epc/Gen2_Protocol_Standard.pdf>
Accessed on: 16/08/2021.

### Insper

This project was developed by four computer engineering students at "Insper Instituto de Ensino e Pesquisa" [^2], together with "Indago Services Inc." [^3]. As part of their completion of course work, the students must communicate with their selected company to identify a problem the company currently has and work together to find and implement a solution for it. For each group of students there is also a teacher that acts as a mentor and aids the group with matters of communication, organization, meetings and project/report feedbacks.

[^2]: Insper Instituto de Ensino e Pesquisa.
<https://www.insper.edu.br/>
Accessed on: 16/08/2021.

[^3]: Indago Devices Inc..
<https://indagodevices.com>
Accessed on: 16/08/2021.

### Indago Devices Inc.

Indago Devices Inc. is a startup that has its headquarters in the city of Birmingham, in the state of Alabama, US, and works in the field of development and study of electronics. Despite having few employees, it seeks to innovate in the electronics market, specifically in the development of systems that communicate through RFID.

They had already been conversing with Insper in the first half of 2021, with another group of students who planned to do a similar project. On the second half of 2021, they decided to follow up with a conformance tester to help develop RFID tags. One of the driving points of the project is that the currently existing solutions are proprietary, and there is no open source alternative available for the RFID community. Hence, they opted to make one, so it could positively impact not only their company, but also the worldwide RFID development community.

## Project Overview

The main objective of this project is to develop and assemble a conformance tester for RFID tags where a microcontroller will be implemented and an IP core for communication with the DUT (device under testing). This device then shall be able to run a series of tests as a reader interacting with a tag through the EPC-GEN2 protocol, analyzing if the tag works as intended and complies with the requirements of the protocol.

The tests will be implemented using the C programming language, allowing for a variety of tests to be created, each test targeting different aspects of the tag's processing, independently evaluating most of them. Also, the tests are customizable, being possible to edit or develop new ones, should the user need it.

It is important to highlight that this project does not make use of RFID communication, nor does it intend to test whether the tag is able to communicate through it. Given the complexity of communicating through radio waves, the group and the teacher agreed to not cover those points in this project. Therefore, the device, tag and computer shall be connected by cables.

### Protocol EPC-GEN2 UHF RFID

Documentation avaliable on: <https://www.gs1.org/sites/default/files/docs/epc/Gen2_Protocol_Standard.pdf>

The main purpose of the protocol is to allow two pieces of hardware, obtained independently, but conforming to the protocol, to communicate flawlessly. To achieve this, it specifies how physical and logical interactions should take place, as well as the possible commands between reader and tag.

To claim compliance with the protocol, a reader (also called interrogator) must meet all required specifications, having implemented all mandatory commands, be able to encode, send, receive, and decode data so that it can communicate with a tag, as well as comply with all local government radio regulations. Optionally, it is allowed to implement any number of optional commands defined in the protocol and any other private commands that do not conflict with any of the mandatory ones. Finally, a reader must not require a tag to be able to process any command that is not specified as mandatory in the protocol.

To claim compliance with the protocol, a tag must meet all required specifications, having implemented all mandatory commands, be able to modulate a response signal after receiving a command from a reader, and comply with all local government radio regulations. Optionally, it is allowed to implement any number of optional commands defined in the protocol and any other private commands that do not conflict with any of the mandatory ones. Finally, the tag must not require a reader to be able to process any optional command from the protocol and is not allowed to modulate a response signal unless it has been commanded to do so by a reader using the commands present in the protocol.

The EPC-GEN2 UHF RFID allow four types of commands in its documentation: 1- mandatory; 2- optional; 3- proprietary; 4- custom. All commands defined in the protocol are either mandatory or optional. Proprietary and custom commands are manufacturer-defined.
Mandatory commands shall be supported by all tags and readers that claim compliance to the protocol.
Optional commands may or may not be supported by tags or readers. If any implements optional commands, then it shall do so in the manner specified in the protocol.
Proprietary commands may be enabled in conformance with the protocol but are not specified in it. All proprietary commands shall be capable of being permanently disabled. Proprietary commands are intended for manufacturing purposes and shall not be used in field-deployed RFID systems.
Custom commands may be enabled in conformance with the protocol but are not specified in it. A reader shall issue a custom command only after singulating a tag and reading (or having prior knowledge of) the tag manufacturer’s identification in the tag’s TID memory. A reader shall use a custom command only in accordance with the specifications of the tag manufacturer identified in the TID. A custom command shall not solely duplicate the functionality of any mandatory or optional command defined in the protocol by a different method.

#### Mandatory Commands

- <guide>Select</guide>  selects the population of tags that will be communicated with. The set can be defined by intersection, union or negation of tags;
- <guide>Query / Query Adjust / Query Rep</guide>  starts a communication round between the tags and reader, deciding which tag will participate in the round and sending the Q value for such. <guide>Query Adjust</guide>  can adjust que Q value for the tag. <guide>Query Rep</guide>  decreases the value of Q stored within the tag’s memory by 1;  
- <guide>ACK / NAK</guide>  is sent to the tag with the same value sent by the tag when returning to the <guide>Query</guide>  command. It signifies the reader recognized the tag’s response. <guide>NAK</guide>  changes the state of the tags involved in the round to <guide>arbitrate</guide>  , in which they remain as stand-by;
- <guide>Req_RN</guide>  requests a new random number (RN16), sending the previous one as authentication;
- <guide>Read / Write</guide>  requests the reading of information within a specified address in the tag’s memory bank. <guide>Write</guide>  sends information to be written in that address instead;
- <guide>Kill / Lock</guide>  sets the tag as unusable. It is a way to end the communication so that the tag no longer responds. <guide>Lock</guide>  can lock or unlock portions of the tag’s memory bank for <guide>Write</guide>  access.

#### Handshake

The diagram below can be found in annex E of the EPC-GEN2 documentation and represents the Hand-shake between reader and tag.

![Handshake diagram](./index/handshake.png)
*EPC UHF Gen2 Air Interface Protocol, p 138*

The reader sends a <guide>Query</guide>  (1), to start an inventory round with the tag. Upon recognizing the inventory round, the tag checks whether to respond, and responds with a 16-bit random number <guide>RN16</guide>  (2). To establish the communication as successful, the reader sends the <guide>ACK</guide>  (3) containing the same RN16. Having received and validated the confirmation, the tag responds with <guide>PC/XPC, EPC</guide>  (4). The reader then send a <guide>Req_RN</guide>  (5), again with the old RN16, requesting a new RN16 to continue the communication. If the tag again validates the RN16, it responds with the <guide>handle</guide>  (6), a new RN16. Once the reader receives the <guide>handle</guide>, the handshake is effectively over and the <guide>handle</guide>  will be used as authentication for all communication from that point forwards. Every <guide>command</guide>  (7) will be sent together with the <guide>handle</guide>  and tag will always verify the <guide>handle</guide>  before responding (8).

#### Tari

The reference time interval for a data-0 in reader to tag signaling. Derives from <u>T</u>ype <u>A</u> <u>R</u>eference <u>I</u>nterval.

According to the EPC-GEN2 protocol, section 6.3.1.2.4, p 27: "Interrogators  shall  communicate  using  Tari  values  in  the  range  of  6.25μs  to  25μs.  Interrogator  compliance  shall be evaluated using at least one Tari value between 6.25μs and 25μs with at least one value of the parameter x. The tolerance on all parameters specified in units of Tari shall be +/–1%. The choice of Tari value and x shall be in accordance with local radio regulations. ".

### State-of-the-Art Review

The market currently has very diversified solutions in relation to RFID technology. Among the options currently available, proprietary equipment and products are the main competitors, as they are developed by well-established companies. For example, CISC semiconductor [^4], specializing in RFID and NFC services, and working both in the production of laboratory equipment and product testers for the market. Another company that is worth mentioning is HID global [^5], which has several solutions for RFID tags end operates worldwide under sales and distribution of these products.

There are, however, other solutions present in the market, such as open-source solutions. As proprietary products are expensive and not easily customizable, some users choose to develop their own version of those products, leaving them open for others to use and improve. The use of open source helps to develop a highly customizable product, as every user can download the program and make their own changes to better suit their need. Another benefit of open source is the collaboration aspect, where users around the world can suggest changes or improvements, as well as implement them to improve the overall product.

An example of an open-source product is the WISP5 [^6] tag, initially developed at the University of Washington [^7]. The WISP is a battery-free platform with a software-defined implementation of a passive RFID tag, that can communicate with commercial-off-the-shelf RFID readers and is powered by the carrier signal emitted by the reader. It is also built from low-cost components commonly found in hardware stores, allowing WISP users to fabricate their own platforms if desired.

Another open-source product is the S.U.R.F.E.R. (Software-defined UHF RFID Flexible Economical Reader) [^8], an RFID reader. It operates with the same technology as the WISP5 tag, enabling readings up to 60 feet (20 meters) away. Due to it being software-defined, the reader is highly versatile, as the user can input the specifications of the desired tag into the software. It also has a relatively simple structure to find, which result in a low-cost product.

Open-source products bring a series of benefits to the users, such as lesser hardware and software costs, due to the products being intentionally built to be easily accessible; simple licensing management because they often are free to use and impose no restrictions at all; abundant support, as there are many companies that develop open-source products and offer both free and varied levels of paid support.

Given these advantages, Indago Devices opted for a completely open-source product as well. In a meeting with our mentor Wallace Shepherd Pitts, he mentioned he had previously researched and studied some of the options currently available, but nothing had fit with what he had in mind, because the products offered little room for customization regarding the tests made to the tag.

The direct competitors of our project would be the previously mentioned products, which dominate the current market. However, as the team was aiming for the open-source architecture, it may attract users interested in a more accessible or customizable product.

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
<https://www.washington.edu/>
Accessed on: 20/09/2021.

[^8]: S.U.R.F.E.R. reader.
<https://openrfidreader.net/>
Accessed on: 20/09/2021.

[^9]: University of North Carolina.
<https://www.uncg.edu/>
Accessed on: 20/09/2021.

### Methodology

During the first weeks of the project, the group settled on definitions and agreements on what would be the methodology used throughout the semester, as well as the different tools and softwares that would be used.

The platform GitHub was chosen as the method for sharing the code between the group members and the teacher, as it can store many important files other than code files, such as diagrams and images the group would produce for the project. Another feature often used by the group is the creation of issues, which can help define and order the group’s next tasks and assign members to complete them.

The day-to-day communication between the members were done through Discord, and meetings with Indago’s representative or the PFE’s coordinators though Microsoft Teams. As meetings with a member of the company were infrequent, taking place every fortnight, the group usually kept a list of questions and issues about the EPC-GEN2 protocol and the project in general so that the representative could provide some support.

Documents and reports were produced and stored in Google Drive, so that multiple members could work on them simultaneously, and also be accessed by the teacher to provide insights and feedback. It also served as another backup storage to the Github repository, in case any problems occurred.

The programming languages VHDL and C were used throughout the project, through the softwares Quartus and Eclipse, which support simulations and tests that aid in the development process. As the client specified that he wanted the project to be open-source, all code, reports and images relevant to this will also be available on the project’s public GitHub repository.

As the project consists of the creation of a conformance tester for the EPC-GEN2 UHF RFID protocol, its documentation was widely used, researched, and discussed by all members of the group during the project, focusing mainly on the communication sections between the reader and tag, as well as encoding data, and mandatory commands for protocol standards.

Since the project was open-source and available on GitHub, it was decided that the group would also provide a documentation to the whole project, which was later decided would be available through GitHub Pages. Inside, the group would give an in-depth description of all components, and also a tutorial on how to clone, run, utilize and modify this project.

To help with code documentation, the group used the Doxygen application, which was incorporated into the already existing guthub-pages documentation. This application generates a page of every VHDL file, giving a brief explanation of the purpose of that component, as well as explain every aspect of the entity, including generics, ports in and outs.

### Environment Tools

#### Development Tools

- Intel® Quartus® Prime FPGA Design Software
- Nios® II Software Build Tools for Eclipse
- Intel® FPGA Simulation - ModelSim
- [GitHub](https://github.com)

#### Design Tools

- Google Drive
- [Excalidraw](https://excalidraw.com)
- Discord
