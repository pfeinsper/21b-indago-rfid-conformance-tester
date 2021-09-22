onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group ip /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/clk
add wave -noupdate -expand -group ip /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/rst
add wave -noupdate -expand -group ip /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/avs_address
add wave -noupdate -expand -group ip /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/avs_read
add wave -noupdate -expand -group ip /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/avs_readdata
add wave -noupdate -expand -group ip /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/avs_write
add wave -noupdate -expand -group ip /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/avs_writedata
add wave -noupdate -expand -group ip -color Magenta -itemcolor Magenta /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/q
add wave -noupdate -expand -group ip /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/reg_settings
add wave -noupdate -expand -group ip /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/reg_status
add wave -noupdate -expand -group ip /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/reg_send_tari
add wave -noupdate -expand -group ip /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fifo_data_in
add wave -noupdate -expand -group ip /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fifo_write_req
add wave -noupdate -expand -group fifo /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fifo/aclr
add wave -noupdate -expand -group fifo /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fifo/data
add wave -noupdate -expand -group fifo /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fifo/rdclk
add wave -noupdate -expand -group fifo /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fifo/rdreq
add wave -noupdate -expand -group fifo /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fifo/wrclk
add wave -noupdate -expand -group fifo /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fifo/wrreq
add wave -noupdate -expand -group fifo /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fifo/q
add wave -noupdate -expand -group fifo /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fifo/rdempty
add wave -noupdate -expand -group fifo /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fifo/wrfull
add wave -noupdate -expand -group fifo /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fifo/sub_wire0
add wave -noupdate -expand -group fifo /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fifo/sub_wire1
add wave -noupdate -expand -group fifo /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fifo/sub_wire2
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/clk
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/rst
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/enable
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/tari
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/is_fifo_empty
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/data_in
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/request_new_data
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/data_out
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/data
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/mask
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/mask_value
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/tari_value
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/data_sender_start
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/data_sender_end
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/half_tari_start
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/half_tari_end
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/full_tari_start
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/full_tari_end
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/tari_CS_start
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/tari_CS_end
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/state_controller
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/state_sender
add wave -noupdate -expand -group fm0 /rfid_nios_tb/rfid_nios_inst/nios_rfid_peripheral_0/fm0/fm0/last_state_bitaa
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {205570000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 192
configure wave -valuecolwidth 199
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {203707952 ps} {207809516 ps}
