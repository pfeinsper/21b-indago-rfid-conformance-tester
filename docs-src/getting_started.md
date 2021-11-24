# Getting Started

## Tools

To be able to use the Conformance Tester for TAGs EPC-GEN2 UHF RFID, you'll need the following tools:

- **Hardware:** DE10-Standard + accessories
- **Software:**
    - Quartus Prime Lite Edition 18.1
    - Cyclone V device support
    - ModelSim-Intel FPGA Edition

You can find the software downloads [here](https://fpgasoftware.intel.com/18.1/?edition=lite). The user manual for the DE-10 Standard board can be found [here](https://github.com/Insper/DE10-Standard-v.1.3.0-SystemCD/blob/master/Manual/DE10-Standard_User_manual.pdf).

## Cloning

First, you must have <guide>git</guide> installed on your machine. After that, you need to run the following command on the directory that you want the repository to be cloned on.

<guide>git clone https://github.com/pfeinsper/21b-indago-rfid-conformance-tester.git</guide>

The repository is now cloned, and you can start testing/running the project.

## Testing / Running

First, launch Quartus Prime. After launching, click on <guide>File</guide> ➡️ <guide>Open Project</guide>. A window will pop up, and you need to choose the <guide>rfid-conformance-tester.qpf</guide> file, located in the <guide>fpga</guide> folder of the repository.

After opening the project, you can test both in ModelSim and in the DE-10 Standard board.

## How to collaborate

Firstly, you should create a fork of the original repository to work on. You can learn how to do so [here](https://docs.github.com/en/get-started/quickstart/fork-a-repo).
After creating your own fork, you can open a pull request to this repository. The instructions on how to do it can be found [here](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork). After making your pull request, it will be reviewed by one of the team members, and if everything's ok, they will approve it. If there are problems with your pull request, the reviewer will inform you of them, and you can make the adjustments necessary.