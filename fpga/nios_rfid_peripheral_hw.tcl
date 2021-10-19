# TCL File Generated by Component Editor 18.1
# Mon Oct 18 19:52:49 BRST 2021
# DO NOT MODIFY


# 
# nios_rfid_peripheral "nios_rfid_peripheral" v1.0
#  2021.10.18.19:52:49
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module nios_rfid_peripheral
# 
set_module_property DESCRIPTION ""
set_module_property NAME nios_rfid_peripheral
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME nios_rfid_peripheral
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL rfid
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file rfid.vhd VHDL PATH RTL/rfid.vhd TOP_LEVEL_FILE
add_fileset_file sender.vhd VHDL PATH RTL/sender.vhd
add_fileset_file FM0_encoder.vhd VHDL PATH RTL/FM0_encoder.vhd
add_fileset_file fifo_fm0.vhd VHDL PATH RTL/fifo_fm0.vhd
add_fileset_file receiver.vhd VHDL PATH RTL/receiver.vhd

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL rfid
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file rfid.vhd VHDL PATH RTL/rfid.vhd
add_fileset_file sender.vhd VHDL PATH RTL/sender.vhd
add_fileset_file FM0_encoder.vhd VHDL PATH RTL/FM0_encoder.vhd
add_fileset_file fifo_fm0.vhd VHDL PATH RTL/fifo_fm0.vhd
add_fileset_file receiver.vhd VHDL PATH RTL/receiver.vhd


# 
# parameters
# 
add_parameter data_width NATURAL 8
set_parameter_property data_width DEFAULT_VALUE 8
set_parameter_property data_width DISPLAY_NAME data_width
set_parameter_property data_width TYPE NATURAL
set_parameter_property data_width UNITS None
set_parameter_property data_width ALLOWED_RANGES 0:2147483647
set_parameter_property data_width HDL_PARAMETER true
add_parameter tari_width NATURAL 16
set_parameter_property tari_width DEFAULT_VALUE 16
set_parameter_property tari_width DISPLAY_NAME tari_width
set_parameter_property tari_width TYPE NATURAL
set_parameter_property tari_width UNITS None
set_parameter_property tari_width ALLOWED_RANGES 0:2147483647
set_parameter_property tari_width HDL_PARAMETER true
add_parameter mask_width NATURAL 4
set_parameter_property mask_width DEFAULT_VALUE 4
set_parameter_property mask_width DISPLAY_NAME mask_width
set_parameter_property mask_width TYPE NATURAL
set_parameter_property mask_width UNITS None
set_parameter_property mask_width ALLOWED_RANGES 0:2147483647
set_parameter_property mask_width HDL_PARAMETER true
add_parameter data_size NATURAL 32
set_parameter_property data_size DEFAULT_VALUE 32
set_parameter_property data_size DISPLAY_NAME data_size
set_parameter_property data_size TYPE NATURAL
set_parameter_property data_size UNITS None
set_parameter_property data_size ALLOWED_RANGES 0:2147483647
set_parameter_property data_size HDL_PARAMETER true
add_parameter loopback BOOLEAN false "if loopback = 1 than rx <= tx"
set_parameter_property loopback DEFAULT_VALUE false
set_parameter_property loopback DISPLAY_NAME loopback
set_parameter_property loopback WIDTH ""
set_parameter_property loopback TYPE BOOLEAN
set_parameter_property loopback UNITS None
set_parameter_property loopback DESCRIPTION "if loopback = 1 than rx <= tx"
set_parameter_property loopback HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point avalon_slave_0
# 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressUnits WORDS
set_interface_property avalon_slave_0 associatedClock clock
set_interface_property avalon_slave_0 associatedReset reset_sink
set_interface_property avalon_slave_0 bitsPerSymbol 8
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 burstcountUnits WORDS
set_interface_property avalon_slave_0 explicitAddressSpan 0
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_slave_0 maximumPendingWriteTransactions 0
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitTime 1
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 0
set_interface_property avalon_slave_0 ENABLED true
set_interface_property avalon_slave_0 EXPORT_OF ""
set_interface_property avalon_slave_0 PORT_NAME_MAP ""
set_interface_property avalon_slave_0 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_0 SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_0 avs_address address Input 3
add_interface_port avalon_slave_0 avs_read read Input 1
add_interface_port avalon_slave_0 avs_readdata readdata Output 32
add_interface_port avalon_slave_0 avs_write write Input 1
add_interface_port avalon_slave_0 avs_writedata writedata Input 32
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink rst reset Input 1


# 
# connection point pins
# 
add_interface pins conduit end
set_interface_property pins associatedClock clock
set_interface_property pins associatedReset reset_sink
set_interface_property pins ENABLED true
set_interface_property pins EXPORT_OF ""
set_interface_property pins PORT_NAME_MAP ""
set_interface_property pins CMSIS_SVD_VARIABLES ""
set_interface_property pins SVD_ADDRESS_GROUP ""

add_interface_port pins rfid_rx rx Input 1
add_interface_port pins rfid_tx tx Output 1

