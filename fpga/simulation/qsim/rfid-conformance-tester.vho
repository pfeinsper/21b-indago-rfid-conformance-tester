-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"

-- DATE "08/16/2021 17:57:04"

-- 
-- Device: Altera 5CGXFC7C7F23C8 Package FBGA484
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	FM0_encoder IS
    PORT (
	clk : IN std_logic;
	need_to_process : IN std_logic;
	tari : IN std_logic_vector(11 DOWNTO 0);
	data_in : IN std_logic_vector(11 DOWNTO 0);
	reduced_clk_out : BUFFER std_logic;
	reset_i_out : BUFFER std_logic;
	encoded_data_out : BUFFER std_logic_vector(15 DOWNTO 0);
	not_encoded_data_out : BUFFER std_logic_vector(7 DOWNTO 0);
	mask_out : BUFFER std_logic_vector(3 DOWNTO 0);
	data_out : BUFFER std_logic;
	is_free : BUFFER std_logic
	);
END FM0_encoder;

-- Design Ports Information
-- need_to_process	=>  Location: PIN_D7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- tari[0]	=>  Location: PIN_M7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- tari[1]	=>  Location: PIN_A18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- tari[2]	=>  Location: PIN_H6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- tari[3]	=>  Location: PIN_K9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- tari[4]	=>  Location: PIN_U10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- tari[5]	=>  Location: PIN_P14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- tari[6]	=>  Location: PIN_AA17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- tari[7]	=>  Location: PIN_H9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- tari[8]	=>  Location: PIN_V14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- tari[9]	=>  Location: PIN_AB6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- tari[10]	=>  Location: PIN_B5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- tari[11]	=>  Location: PIN_Y22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- reduced_clk_out	=>  Location: PIN_L19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- reset_i_out	=>  Location: PIN_K21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- encoded_data_out[0]	=>  Location: PIN_M20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- encoded_data_out[1]	=>  Location: PIN_K17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- encoded_data_out[2]	=>  Location: PIN_N21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- encoded_data_out[3]	=>  Location: PIN_H21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- encoded_data_out[4]	=>  Location: PIN_N19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- encoded_data_out[5]	=>  Location: PIN_M18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- encoded_data_out[6]	=>  Location: PIN_M22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- encoded_data_out[7]	=>  Location: PIN_D21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- encoded_data_out[8]	=>  Location: PIN_L22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- encoded_data_out[9]	=>  Location: PIN_L17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- encoded_data_out[10]	=>  Location: PIN_N16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- encoded_data_out[11]	=>  Location: PIN_N20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- encoded_data_out[12]	=>  Location: PIN_T15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- encoded_data_out[13]	=>  Location: PIN_P16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- encoded_data_out[14]	=>  Location: PIN_R15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- encoded_data_out[15]	=>  Location: PIN_V19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- not_encoded_data_out[0]	=>  Location: PIN_T17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- not_encoded_data_out[1]	=>  Location: PIN_U17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- not_encoded_data_out[2]	=>  Location: PIN_C20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- not_encoded_data_out[3]	=>  Location: PIN_V18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- not_encoded_data_out[4]	=>  Location: PIN_R16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- not_encoded_data_out[5]	=>  Location: PIN_T22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- not_encoded_data_out[6]	=>  Location: PIN_T19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- not_encoded_data_out[7]	=>  Location: PIN_U16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- mask_out[0]	=>  Location: PIN_P17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- mask_out[1]	=>  Location: PIN_R21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- mask_out[2]	=>  Location: PIN_P19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- mask_out[3]	=>  Location: PIN_U22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_out	=>  Location: PIN_P18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- is_free	=>  Location: PIN_G15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in[4]	=>  Location: PIN_T18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in[5]	=>  Location: PIN_U21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in[6]	=>  Location: PIN_B20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in[7]	=>  Location: PIN_V21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in[8]	=>  Location: PIN_R17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in[9]	=>  Location: PIN_R22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in[10]	=>  Location: PIN_T20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in[11]	=>  Location: PIN_U20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_M16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in[3]	=>  Location: PIN_P22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in[0]	=>  Location: PIN_K22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in[1]	=>  Location: PIN_L18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in[2]	=>  Location: PIN_M21,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF FM0_encoder IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_need_to_process : std_logic;
SIGNAL ww_tari : std_logic_vector(11 DOWNTO 0);
SIGNAL ww_data_in : std_logic_vector(11 DOWNTO 0);
SIGNAL ww_reduced_clk_out : std_logic;
SIGNAL ww_reset_i_out : std_logic;
SIGNAL ww_encoded_data_out : std_logic_vector(15 DOWNTO 0);
SIGNAL ww_not_encoded_data_out : std_logic_vector(7 DOWNTO 0);
SIGNAL ww_mask_out : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_data_out : std_logic;
SIGNAL ww_is_free : std_logic;
SIGNAL \need_to_process~input_o\ : std_logic;
SIGNAL \tari[0]~input_o\ : std_logic;
SIGNAL \tari[1]~input_o\ : std_logic;
SIGNAL \tari[2]~input_o\ : std_logic;
SIGNAL \tari[3]~input_o\ : std_logic;
SIGNAL \tari[4]~input_o\ : std_logic;
SIGNAL \tari[5]~input_o\ : std_logic;
SIGNAL \tari[6]~input_o\ : std_logic;
SIGNAL \tari[7]~input_o\ : std_logic;
SIGNAL \tari[8]~input_o\ : std_logic;
SIGNAL \tari[9]~input_o\ : std_logic;
SIGNAL \tari[10]~input_o\ : std_logic;
SIGNAL \tari[11]~input_o\ : std_logic;
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \clk~inputCLKENA0_outclk\ : std_logic;
SIGNAL \clock_reducer:i2[5]~q\ : std_logic;
SIGNAL \Add1~17_sumout\ : std_logic;
SIGNAL \clock_reducer:i2[0]~q\ : std_logic;
SIGNAL \Add1~18\ : std_logic;
SIGNAL \Add1~21_sumout\ : std_logic;
SIGNAL \clock_reducer:i2[1]~feeder_combout\ : std_logic;
SIGNAL \clock_reducer:i2[1]~q\ : std_logic;
SIGNAL \Add1~22\ : std_logic;
SIGNAL \Add1~25_sumout\ : std_logic;
SIGNAL \clock_reducer:i2[2]~q\ : std_logic;
SIGNAL \Add1~26\ : std_logic;
SIGNAL \Add1~29_sumout\ : std_logic;
SIGNAL \clock_reducer:i2[3]~q\ : std_logic;
SIGNAL \Add1~30\ : std_logic;
SIGNAL \Add1~33_sumout\ : std_logic;
SIGNAL \clock_reducer:i2[4]~feeder_combout\ : std_logic;
SIGNAL \clock_reducer:i2[4]~q\ : std_logic;
SIGNAL \Add1~34\ : std_logic;
SIGNAL \Add1~37_sumout\ : std_logic;
SIGNAL \clock_reducer:i2[9]~q\ : std_logic;
SIGNAL \Add1~38\ : std_logic;
SIGNAL \Add1~1_sumout\ : std_logic;
SIGNAL \clock_reducer:i2[6]~q\ : std_logic;
SIGNAL \Add1~2\ : std_logic;
SIGNAL \Add1~6\ : std_logic;
SIGNAL \Add1~9_sumout\ : std_logic;
SIGNAL \clock_reducer:i2[8]~q\ : std_logic;
SIGNAL \Add1~10\ : std_logic;
SIGNAL \Add1~13_sumout\ : std_logic;
SIGNAL \Equal1~1_combout\ : std_logic;
SIGNAL \Equal1~2_combout\ : std_logic;
SIGNAL \clock_reducer:i2[7]~q\ : std_logic;
SIGNAL \Add1~5_sumout\ : std_logic;
SIGNAL \Equal1~0_combout\ : std_logic;
SIGNAL \reduced_clk~0_combout\ : std_logic;
SIGNAL \reduced_clk~q\ : std_logic;
SIGNAL \data_in[11]~input_o\ : std_logic;
SIGNAL \data_in[9]~input_o\ : std_logic;
SIGNAL \data_in[10]~input_o\ : std_logic;
SIGNAL \data_in[1]~input_o\ : std_logic;
SIGNAL \data_in[3]~input_o\ : std_logic;
SIGNAL \i~3_combout\ : std_logic;
SIGNAL \data_encoder:i[0]~q\ : std_logic;
SIGNAL \data_in[2]~input_o\ : std_logic;
SIGNAL \i~0_combout\ : std_logic;
SIGNAL \data_encoder:i[1]~q\ : std_logic;
SIGNAL \i~1_combout\ : std_logic;
SIGNAL \data_encoder:i[2]~q\ : std_logic;
SIGNAL \data_in[0]~input_o\ : std_logic;
SIGNAL \Equal0~0_combout\ : std_logic;
SIGNAL \Decoder0~7_combout\ : std_logic;
SIGNAL \i~2_combout\ : std_logic;
SIGNAL \data_encoder:i[3]~q\ : std_logic;
SIGNAL \data_in[5]~input_o\ : std_logic;
SIGNAL \data_in[7]~input_o\ : std_logic;
SIGNAL \data_in[6]~input_o\ : std_logic;
SIGNAL \data_in[4]~input_o\ : std_logic;
SIGNAL \Mux0~4_combout\ : std_logic;
SIGNAL \data_in[8]~input_o\ : std_logic;
SIGNAL \Mux0~0_combout\ : std_logic;
SIGNAL \reset_i_out~reg0_q\ : std_logic;
SIGNAL \encoded_data~0_combout\ : std_logic;
SIGNAL \current_start_value~q\ : std_logic;
SIGNAL \encoded_data[0]~1_combout\ : std_logic;
SIGNAL \Decoder0~0_combout\ : std_logic;
SIGNAL \encoded_data[1]~feeder_combout\ : std_logic;
SIGNAL \encoded_data[2]~3_combout\ : std_logic;
SIGNAL \Decoder0~1_combout\ : std_logic;
SIGNAL \encoded_data[2]~DUPLICATE_q\ : std_logic;
SIGNAL \encoded_data[3]~feeder_combout\ : std_logic;
SIGNAL \encoded_data[4]~5_combout\ : std_logic;
SIGNAL \Decoder0~2_combout\ : std_logic;
SIGNAL \encoded_data[5]~feeder_combout\ : std_logic;
SIGNAL \encoded_data[6]~7_combout\ : std_logic;
SIGNAL \Decoder0~3_combout\ : std_logic;
SIGNAL \encoded_data[8]~9_combout\ : std_logic;
SIGNAL \Decoder0~4_combout\ : std_logic;
SIGNAL \encoded_data[10]~11_combout\ : std_logic;
SIGNAL \Decoder0~5_combout\ : std_logic;
SIGNAL \encoded_data[12]~13_combout\ : std_logic;
SIGNAL \Decoder0~6_combout\ : std_logic;
SIGNAL \encoded_data[14]~15_combout\ : std_logic;
SIGNAL \encoded_data[14]~DUPLICATE_q\ : std_logic;
SIGNAL \mask_out[0]~reg0_q\ : std_logic;
SIGNAL \mask_out[1]~reg0feeder_combout\ : std_logic;
SIGNAL \mask_out[1]~reg0_q\ : std_logic;
SIGNAL \mask_out[2]~reg0feeder_combout\ : std_logic;
SIGNAL \mask_out[2]~reg0_q\ : std_logic;
SIGNAL \mask_out[3]~reg0_q\ : std_logic;
SIGNAL \Equal2~0_combout\ : std_logic;
SIGNAL \i3~1_combout\ : std_logic;
SIGNAL \sending_data:i3[0]~q\ : std_logic;
SIGNAL \Add2~0_combout\ : std_logic;
SIGNAL \i3~0_combout\ : std_logic;
SIGNAL \sending_data:i3[1]~q\ : std_logic;
SIGNAL \i3~3_combout\ : std_logic;
SIGNAL \sending_data:i3[3]~q\ : std_logic;
SIGNAL \Add2~2_combout\ : std_logic;
SIGNAL \i3~2_combout\ : std_logic;
SIGNAL \sending_data:i3[2]~q\ : std_logic;
SIGNAL \Add2~1_combout\ : std_logic;
SIGNAL \Mux1~3_combout\ : std_logic;
SIGNAL \Mux1~1_combout\ : std_logic;
SIGNAL \Mux1~2_combout\ : std_logic;
SIGNAL \Mux1~0_combout\ : std_logic;
SIGNAL \Mux1~4_combout\ : std_logic;
SIGNAL \tmp_data_out~q\ : std_logic;
SIGNAL encoded_data : std_logic_vector(15 DOWNTO 0);
SIGNAL \ALT_INV_data_in[2]~input_o\ : std_logic;
SIGNAL \ALT_INV_data_in[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_data_in[0]~input_o\ : std_logic;
SIGNAL \ALT_INV_data_in[3]~input_o\ : std_logic;
SIGNAL \ALT_INV_data_in[11]~input_o\ : std_logic;
SIGNAL \ALT_INV_data_in[10]~input_o\ : std_logic;
SIGNAL \ALT_INV_data_in[9]~input_o\ : std_logic;
SIGNAL \ALT_INV_data_in[8]~input_o\ : std_logic;
SIGNAL \ALT_INV_data_in[7]~input_o\ : std_logic;
SIGNAL \ALT_INV_data_in[6]~input_o\ : std_logic;
SIGNAL \ALT_INV_data_in[5]~input_o\ : std_logic;
SIGNAL \ALT_INV_data_in[4]~input_o\ : std_logic;
SIGNAL \ALT_INV_Equal1~1_combout\ : std_logic;
SIGNAL \ALT_INV_Equal2~0_combout\ : std_logic;
SIGNAL \ALT_INV_Equal0~0_combout\ : std_logic;
SIGNAL \ALT_INV_Add2~2_combout\ : std_logic;
SIGNAL \ALT_INV_sending_data:i3[3]~q\ : std_logic;
SIGNAL \ALT_INV_Mux1~3_combout\ : std_logic;
SIGNAL \ALT_INV_Mux1~2_combout\ : std_logic;
SIGNAL \ALT_INV_Mux1~1_combout\ : std_logic;
SIGNAL \ALT_INV_Mux1~0_combout\ : std_logic;
SIGNAL \ALT_INV_Add2~1_combout\ : std_logic;
SIGNAL \ALT_INV_sending_data:i3[2]~q\ : std_logic;
SIGNAL \ALT_INV_Add2~0_combout\ : std_logic;
SIGNAL \ALT_INV_sending_data:i3[0]~q\ : std_logic;
SIGNAL \ALT_INV_sending_data:i3[1]~q\ : std_logic;
SIGNAL \ALT_INV_data_encoder:i[3]~q\ : std_logic;
SIGNAL \ALT_INV_Decoder0~7_combout\ : std_logic;
SIGNAL \ALT_INV_encoded_data~0_combout\ : std_logic;
SIGNAL \ALT_INV_data_encoder:i[2]~q\ : std_logic;
SIGNAL \ALT_INV_data_encoder:i[0]~q\ : std_logic;
SIGNAL \ALT_INV_data_encoder:i[1]~q\ : std_logic;
SIGNAL \ALT_INV_current_start_value~q\ : std_logic;
SIGNAL \ALT_INV_Equal1~0_combout\ : std_logic;
SIGNAL ALT_INV_encoded_data : std_logic_vector(15 DOWNTO 0);
SIGNAL \ALT_INV_reduced_clk~q\ : std_logic;
SIGNAL \ALT_INV_Mux0~4_combout\ : std_logic;
SIGNAL \ALT_INV_clock_reducer:i2[5]~q\ : std_logic;
SIGNAL \ALT_INV_clock_reducer:i2[4]~q\ : std_logic;
SIGNAL \ALT_INV_clock_reducer:i2[3]~q\ : std_logic;
SIGNAL \ALT_INV_clock_reducer:i2[2]~q\ : std_logic;
SIGNAL \ALT_INV_clock_reducer:i2[1]~q\ : std_logic;
SIGNAL \ALT_INV_clock_reducer:i2[0]~q\ : std_logic;
SIGNAL \ALT_INV_clock_reducer:i2[9]~q\ : std_logic;
SIGNAL \ALT_INV_clock_reducer:i2[8]~q\ : std_logic;
SIGNAL \ALT_INV_clock_reducer:i2[7]~q\ : std_logic;
SIGNAL \ALT_INV_clock_reducer:i2[6]~q\ : std_logic;
SIGNAL \ALT_INV_Mux0~0_combout\ : std_logic;
SIGNAL \ALT_INV_Add1~37_sumout\ : std_logic;
SIGNAL \ALT_INV_Add1~33_sumout\ : std_logic;
SIGNAL \ALT_INV_Add1~29_sumout\ : std_logic;
SIGNAL \ALT_INV_Add1~25_sumout\ : std_logic;
SIGNAL \ALT_INV_Add1~21_sumout\ : std_logic;
SIGNAL \ALT_INV_Add1~17_sumout\ : std_logic;
SIGNAL \ALT_INV_Add1~13_sumout\ : std_logic;
SIGNAL \ALT_INV_Add1~9_sumout\ : std_logic;
SIGNAL \ALT_INV_Add1~5_sumout\ : std_logic;
SIGNAL \ALT_INV_Add1~1_sumout\ : std_logic;

BEGIN

ww_clk <= clk;
ww_need_to_process <= need_to_process;
ww_tari <= tari;
ww_data_in <= data_in;
reduced_clk_out <= ww_reduced_clk_out;
reset_i_out <= ww_reset_i_out;
encoded_data_out <= ww_encoded_data_out;
not_encoded_data_out <= ww_not_encoded_data_out;
mask_out <= ww_mask_out;
data_out <= ww_data_out;
is_free <= ww_is_free;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_data_in[2]~input_o\ <= NOT \data_in[2]~input_o\;
\ALT_INV_data_in[1]~input_o\ <= NOT \data_in[1]~input_o\;
\ALT_INV_data_in[0]~input_o\ <= NOT \data_in[0]~input_o\;
\ALT_INV_data_in[3]~input_o\ <= NOT \data_in[3]~input_o\;
\ALT_INV_data_in[11]~input_o\ <= NOT \data_in[11]~input_o\;
\ALT_INV_data_in[10]~input_o\ <= NOT \data_in[10]~input_o\;
\ALT_INV_data_in[9]~input_o\ <= NOT \data_in[9]~input_o\;
\ALT_INV_data_in[8]~input_o\ <= NOT \data_in[8]~input_o\;
\ALT_INV_data_in[7]~input_o\ <= NOT \data_in[7]~input_o\;
\ALT_INV_data_in[6]~input_o\ <= NOT \data_in[6]~input_o\;
\ALT_INV_data_in[5]~input_o\ <= NOT \data_in[5]~input_o\;
\ALT_INV_data_in[4]~input_o\ <= NOT \data_in[4]~input_o\;
\ALT_INV_Equal1~1_combout\ <= NOT \Equal1~1_combout\;
\ALT_INV_Equal2~0_combout\ <= NOT \Equal2~0_combout\;
\ALT_INV_Equal0~0_combout\ <= NOT \Equal0~0_combout\;
\ALT_INV_Add2~2_combout\ <= NOT \Add2~2_combout\;
\ALT_INV_sending_data:i3[3]~q\ <= NOT \sending_data:i3[3]~q\;
\ALT_INV_Mux1~3_combout\ <= NOT \Mux1~3_combout\;
\ALT_INV_Mux1~2_combout\ <= NOT \Mux1~2_combout\;
\ALT_INV_Mux1~1_combout\ <= NOT \Mux1~1_combout\;
\ALT_INV_Mux1~0_combout\ <= NOT \Mux1~0_combout\;
\ALT_INV_Add2~1_combout\ <= NOT \Add2~1_combout\;
\ALT_INV_sending_data:i3[2]~q\ <= NOT \sending_data:i3[2]~q\;
\ALT_INV_Add2~0_combout\ <= NOT \Add2~0_combout\;
\ALT_INV_sending_data:i3[0]~q\ <= NOT \sending_data:i3[0]~q\;
\ALT_INV_sending_data:i3[1]~q\ <= NOT \sending_data:i3[1]~q\;
\ALT_INV_data_encoder:i[3]~q\ <= NOT \data_encoder:i[3]~q\;
\ALT_INV_Decoder0~7_combout\ <= NOT \Decoder0~7_combout\;
\ALT_INV_encoded_data~0_combout\ <= NOT \encoded_data~0_combout\;
\ALT_INV_data_encoder:i[2]~q\ <= NOT \data_encoder:i[2]~q\;
\ALT_INV_data_encoder:i[0]~q\ <= NOT \data_encoder:i[0]~q\;
\ALT_INV_data_encoder:i[1]~q\ <= NOT \data_encoder:i[1]~q\;
\ALT_INV_current_start_value~q\ <= NOT \current_start_value~q\;
\ALT_INV_Equal1~0_combout\ <= NOT \Equal1~0_combout\;
ALT_INV_encoded_data(15) <= NOT encoded_data(15);
ALT_INV_encoded_data(14) <= NOT encoded_data(14);
ALT_INV_encoded_data(13) <= NOT encoded_data(13);
ALT_INV_encoded_data(12) <= NOT encoded_data(12);
ALT_INV_encoded_data(11) <= NOT encoded_data(11);
ALT_INV_encoded_data(10) <= NOT encoded_data(10);
ALT_INV_encoded_data(9) <= NOT encoded_data(9);
ALT_INV_encoded_data(8) <= NOT encoded_data(8);
ALT_INV_encoded_data(7) <= NOT encoded_data(7);
ALT_INV_encoded_data(6) <= NOT encoded_data(6);
ALT_INV_encoded_data(5) <= NOT encoded_data(5);
ALT_INV_encoded_data(4) <= NOT encoded_data(4);
ALT_INV_encoded_data(3) <= NOT encoded_data(3);
ALT_INV_encoded_data(2) <= NOT encoded_data(2);
ALT_INV_encoded_data(1) <= NOT encoded_data(1);
ALT_INV_encoded_data(0) <= NOT encoded_data(0);
\ALT_INV_reduced_clk~q\ <= NOT \reduced_clk~q\;
\ALT_INV_Mux0~4_combout\ <= NOT \Mux0~4_combout\;
\ALT_INV_clock_reducer:i2[5]~q\ <= NOT \clock_reducer:i2[5]~q\;
\ALT_INV_clock_reducer:i2[4]~q\ <= NOT \clock_reducer:i2[4]~q\;
\ALT_INV_clock_reducer:i2[3]~q\ <= NOT \clock_reducer:i2[3]~q\;
\ALT_INV_clock_reducer:i2[2]~q\ <= NOT \clock_reducer:i2[2]~q\;
\ALT_INV_clock_reducer:i2[1]~q\ <= NOT \clock_reducer:i2[1]~q\;
\ALT_INV_clock_reducer:i2[0]~q\ <= NOT \clock_reducer:i2[0]~q\;
\ALT_INV_clock_reducer:i2[9]~q\ <= NOT \clock_reducer:i2[9]~q\;
\ALT_INV_clock_reducer:i2[8]~q\ <= NOT \clock_reducer:i2[8]~q\;
\ALT_INV_clock_reducer:i2[7]~q\ <= NOT \clock_reducer:i2[7]~q\;
\ALT_INV_clock_reducer:i2[6]~q\ <= NOT \clock_reducer:i2[6]~q\;
\ALT_INV_Mux0~0_combout\ <= NOT \Mux0~0_combout\;
\ALT_INV_Add1~37_sumout\ <= NOT \Add1~37_sumout\;
\ALT_INV_Add1~33_sumout\ <= NOT \Add1~33_sumout\;
\ALT_INV_Add1~29_sumout\ <= NOT \Add1~29_sumout\;
\ALT_INV_Add1~25_sumout\ <= NOT \Add1~25_sumout\;
\ALT_INV_Add1~21_sumout\ <= NOT \Add1~21_sumout\;
\ALT_INV_Add1~17_sumout\ <= NOT \Add1~17_sumout\;
\ALT_INV_Add1~13_sumout\ <= NOT \Add1~13_sumout\;
\ALT_INV_Add1~9_sumout\ <= NOT \Add1~9_sumout\;
\ALT_INV_Add1~5_sumout\ <= NOT \Add1~5_sumout\;
\ALT_INV_Add1~1_sumout\ <= NOT \Add1~1_sumout\;

-- Location: IOOBUF_X89_Y38_N5
\reduced_clk_out~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \reduced_clk~q\,
	devoe => ww_devoe,
	o => ww_reduced_clk_out);

-- Location: IOOBUF_X89_Y38_N39
\reset_i_out~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \reset_i_out~reg0_q\,
	devoe => ww_devoe,
	o => ww_reset_i_out);

-- Location: IOOBUF_X89_Y37_N39
\encoded_data_out[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => encoded_data(0),
	devoe => ww_devoe,
	o => ww_encoded_data_out(0));

-- Location: IOOBUF_X89_Y37_N5
\encoded_data_out[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => encoded_data(1),
	devoe => ww_devoe,
	o => ww_encoded_data_out(1));

-- Location: IOOBUF_X89_Y35_N96
\encoded_data_out[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \encoded_data[2]~DUPLICATE_q\,
	devoe => ww_devoe,
	o => ww_encoded_data_out(2));

-- Location: IOOBUF_X88_Y81_N3
\encoded_data_out[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => encoded_data(3),
	devoe => ww_devoe,
	o => ww_encoded_data_out(3));

-- Location: IOOBUF_X89_Y36_N5
\encoded_data_out[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => encoded_data(4),
	devoe => ww_devoe,
	o => ww_encoded_data_out(4));

-- Location: IOOBUF_X89_Y36_N22
\encoded_data_out[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => encoded_data(5),
	devoe => ww_devoe,
	o => ww_encoded_data_out(5));

-- Location: IOOBUF_X89_Y36_N39
\encoded_data_out[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => encoded_data(6),
	devoe => ww_devoe,
	o => ww_encoded_data_out(6));

-- Location: IOOBUF_X88_Y81_N54
\encoded_data_out[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => encoded_data(7),
	devoe => ww_devoe,
	o => ww_encoded_data_out(7));

-- Location: IOOBUF_X89_Y36_N56
\encoded_data_out[8]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => encoded_data(8),
	devoe => ww_devoe,
	o => ww_encoded_data_out(8));

-- Location: IOOBUF_X89_Y37_N22
\encoded_data_out[9]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => encoded_data(9),
	devoe => ww_devoe,
	o => ww_encoded_data_out(9));

-- Location: IOOBUF_X89_Y35_N45
\encoded_data_out[10]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => encoded_data(10),
	devoe => ww_devoe,
	o => ww_encoded_data_out(10));

-- Location: IOOBUF_X89_Y35_N79
\encoded_data_out[11]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => encoded_data(11),
	devoe => ww_devoe,
	o => ww_encoded_data_out(11));

-- Location: IOOBUF_X89_Y6_N5
\encoded_data_out[12]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => encoded_data(12),
	devoe => ww_devoe,
	o => ww_encoded_data_out(12));

-- Location: IOOBUF_X89_Y9_N5
\encoded_data_out[13]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => encoded_data(13),
	devoe => ww_devoe,
	o => ww_encoded_data_out(13));

-- Location: IOOBUF_X89_Y6_N22
\encoded_data_out[14]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \encoded_data[14]~DUPLICATE_q\,
	devoe => ww_devoe,
	o => ww_encoded_data_out(14));

-- Location: IOOBUF_X70_Y0_N19
\encoded_data_out[15]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => encoded_data(15),
	devoe => ww_devoe,
	o => ww_encoded_data_out(15));

-- Location: IOOBUF_X89_Y4_N62
\not_encoded_data_out[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \data_in[4]~input_o\,
	devoe => ww_devoe,
	o => ww_not_encoded_data_out(0));

-- Location: IOOBUF_X72_Y0_N2
\not_encoded_data_out[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \data_in[5]~input_o\,
	devoe => ww_devoe,
	o => ww_not_encoded_data_out(1));

-- Location: IOOBUF_X86_Y81_N36
\not_encoded_data_out[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \data_in[6]~input_o\,
	devoe => ww_devoe,
	o => ww_not_encoded_data_out(2));

-- Location: IOOBUF_X70_Y0_N2
\not_encoded_data_out[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \data_in[7]~input_o\,
	devoe => ww_devoe,
	o => ww_not_encoded_data_out(3));

-- Location: IOOBUF_X89_Y8_N5
\not_encoded_data_out[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \data_in[8]~input_o\,
	devoe => ww_devoe,
	o => ww_not_encoded_data_out(4));

-- Location: IOOBUF_X89_Y6_N39
\not_encoded_data_out[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \data_in[9]~input_o\,
	devoe => ww_devoe,
	o => ww_not_encoded_data_out(5));

-- Location: IOOBUF_X89_Y4_N79
\not_encoded_data_out[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \data_in[10]~input_o\,
	devoe => ww_devoe,
	o => ww_not_encoded_data_out(6));

-- Location: IOOBUF_X72_Y0_N19
\not_encoded_data_out[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \data_in[11]~input_o\,
	devoe => ww_devoe,
	o => ww_not_encoded_data_out(7));

-- Location: IOOBUF_X89_Y9_N22
\mask_out[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \mask_out[0]~reg0_q\,
	devoe => ww_devoe,
	o => ww_mask_out(0));

-- Location: IOOBUF_X89_Y8_N39
\mask_out[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \mask_out[1]~reg0_q\,
	devoe => ww_devoe,
	o => ww_mask_out(1));

-- Location: IOOBUF_X89_Y9_N39
\mask_out[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \mask_out[2]~reg0_q\,
	devoe => ww_devoe,
	o => ww_mask_out(2));

-- Location: IOOBUF_X70_Y0_N53
\mask_out[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \mask_out[3]~reg0_q\,
	devoe => ww_devoe,
	o => ww_mask_out(3));

-- Location: IOOBUF_X89_Y9_N56
\data_out~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \tmp_data_out~q\,
	devoe => ww_devoe,
	o => ww_data_out);

-- Location: IOOBUF_X62_Y81_N36
\is_free~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_is_free);

-- Location: IOIBUF_X89_Y35_N61
\clk~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: CLKCTRL_G10
\clk~inputCLKENA0\ : cyclonev_clkena
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	disable_mode => "low",
	ena_register_mode => "always enabled",
	ena_register_power_up => "high",
	test_syn => "high")
-- pragma translate_on
PORT MAP (
	inclk => \clk~input_o\,
	outclk => \clk~inputCLKENA0_outclk\);

-- Location: FF_X88_Y35_N41
\clock_reducer:i2[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \Add1~37_sumout\,
	sclr => \Equal1~2_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \clock_reducer:i2[5]~q\);

-- Location: LABCELL_X88_Y35_N0
\Add1~17\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add1~17_sumout\ = SUM(( \clock_reducer:i2[0]~q\ ) + ( VCC ) + ( !VCC ))
-- \Add1~18\ = CARRY(( \clock_reducer:i2[0]~q\ ) + ( VCC ) + ( !VCC ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_clock_reducer:i2[0]~q\,
	cin => GND,
	sumout => \Add1~17_sumout\,
	cout => \Add1~18\);

-- Location: FF_X88_Y35_N50
\clock_reducer:i2[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \Add1~17_sumout\,
	sclr => \Equal1~2_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \clock_reducer:i2[0]~q\);

-- Location: LABCELL_X88_Y35_N3
\Add1~21\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add1~21_sumout\ = SUM(( \clock_reducer:i2[1]~q\ ) + ( GND ) + ( \Add1~18\ ))
-- \Add1~22\ = CARRY(( \clock_reducer:i2[1]~q\ ) + ( GND ) + ( \Add1~18\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_clock_reducer:i2[1]~q\,
	cin => \Add1~18\,
	sumout => \Add1~21_sumout\,
	cout => \Add1~22\);

-- Location: LABCELL_X88_Y35_N45
\clock_reducer:i2[1]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \clock_reducer:i2[1]~feeder_combout\ = ( \Add1~21_sumout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_Add1~21_sumout\,
	combout => \clock_reducer:i2[1]~feeder_combout\);

-- Location: FF_X88_Y35_N47
\clock_reducer:i2[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \clock_reducer:i2[1]~feeder_combout\,
	sclr => \Equal1~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \clock_reducer:i2[1]~q\);

-- Location: LABCELL_X88_Y35_N6
\Add1~25\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add1~25_sumout\ = SUM(( \clock_reducer:i2[2]~q\ ) + ( GND ) + ( \Add1~22\ ))
-- \Add1~26\ = CARRY(( \clock_reducer:i2[2]~q\ ) + ( GND ) + ( \Add1~22\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_clock_reducer:i2[2]~q\,
	cin => \Add1~22\,
	sumout => \Add1~25_sumout\,
	cout => \Add1~26\);

-- Location: FF_X88_Y35_N35
\clock_reducer:i2[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \Add1~25_sumout\,
	sclr => \Equal1~2_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \clock_reducer:i2[2]~q\);

-- Location: LABCELL_X88_Y35_N9
\Add1~29\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add1~29_sumout\ = SUM(( \clock_reducer:i2[3]~q\ ) + ( GND ) + ( \Add1~26\ ))
-- \Add1~30\ = CARRY(( \clock_reducer:i2[3]~q\ ) + ( GND ) + ( \Add1~26\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_clock_reducer:i2[3]~q\,
	cin => \Add1~26\,
	sumout => \Add1~29_sumout\,
	cout => \Add1~30\);

-- Location: FF_X88_Y35_N55
\clock_reducer:i2[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \Add1~29_sumout\,
	sclr => \Equal1~2_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \clock_reducer:i2[3]~q\);

-- Location: LABCELL_X88_Y35_N12
\Add1~33\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add1~33_sumout\ = SUM(( \clock_reducer:i2[4]~q\ ) + ( GND ) + ( \Add1~30\ ))
-- \Add1~34\ = CARRY(( \clock_reducer:i2[4]~q\ ) + ( GND ) + ( \Add1~30\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_clock_reducer:i2[4]~q\,
	cin => \Add1~30\,
	sumout => \Add1~33_sumout\,
	cout => \Add1~34\);

-- Location: LABCELL_X88_Y35_N42
\clock_reducer:i2[4]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \clock_reducer:i2[4]~feeder_combout\ = ( \Add1~33_sumout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_Add1~33_sumout\,
	combout => \clock_reducer:i2[4]~feeder_combout\);

-- Location: FF_X88_Y35_N43
\clock_reducer:i2[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \clock_reducer:i2[4]~feeder_combout\,
	sclr => \Equal1~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \clock_reducer:i2[4]~q\);

-- Location: LABCELL_X88_Y35_N15
\Add1~37\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add1~37_sumout\ = SUM(( \clock_reducer:i2[5]~q\ ) + ( GND ) + ( \Add1~34\ ))
-- \Add1~38\ = CARRY(( \clock_reducer:i2[5]~q\ ) + ( GND ) + ( \Add1~34\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_clock_reducer:i2[5]~q\,
	cin => \Add1~34\,
	sumout => \Add1~37_sumout\,
	cout => \Add1~38\);

-- Location: FF_X88_Y35_N37
\clock_reducer:i2[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \Add1~13_sumout\,
	sclr => \Equal1~2_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \clock_reducer:i2[9]~q\);

-- Location: LABCELL_X88_Y35_N18
\Add1~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add1~1_sumout\ = SUM(( \clock_reducer:i2[6]~q\ ) + ( GND ) + ( \Add1~38\ ))
-- \Add1~2\ = CARRY(( \clock_reducer:i2[6]~q\ ) + ( GND ) + ( \Add1~38\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_clock_reducer:i2[6]~q\,
	cin => \Add1~38\,
	sumout => \Add1~1_sumout\,
	cout => \Add1~2\);

-- Location: FF_X88_Y35_N31
\clock_reducer:i2[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \Add1~1_sumout\,
	sclr => \Equal1~2_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \clock_reducer:i2[6]~q\);

-- Location: LABCELL_X88_Y35_N21
\Add1~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add1~5_sumout\ = SUM(( \clock_reducer:i2[7]~q\ ) + ( GND ) + ( \Add1~2\ ))
-- \Add1~6\ = CARRY(( \clock_reducer:i2[7]~q\ ) + ( GND ) + ( \Add1~2\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_clock_reducer:i2[7]~q\,
	cin => \Add1~2\,
	sumout => \Add1~5_sumout\,
	cout => \Add1~6\);

-- Location: LABCELL_X88_Y35_N24
\Add1~9\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add1~9_sumout\ = SUM(( \clock_reducer:i2[8]~q\ ) + ( GND ) + ( \Add1~6\ ))
-- \Add1~10\ = CARRY(( \clock_reducer:i2[8]~q\ ) + ( GND ) + ( \Add1~6\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_clock_reducer:i2[8]~q\,
	cin => \Add1~6\,
	sumout => \Add1~9_sumout\,
	cout => \Add1~10\);

-- Location: FF_X88_Y35_N59
\clock_reducer:i2[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \Add1~9_sumout\,
	sclr => \Equal1~2_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \clock_reducer:i2[8]~q\);

-- Location: LABCELL_X88_Y35_N27
\Add1~13\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add1~13_sumout\ = SUM(( \clock_reducer:i2[9]~q\ ) + ( GND ) + ( \Add1~10\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_clock_reducer:i2[9]~q\,
	cin => \Add1~10\,
	sumout => \Add1~13_sumout\);

-- Location: LABCELL_X88_Y35_N51
\Equal1~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \Equal1~1_combout\ = ( !\Add1~29_sumout\ & ( !\Add1~33_sumout\ & ( (!\Add1~17_sumout\ & (!\Add1~25_sumout\ & \Add1~21_sumout\)) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000010100000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_Add1~17_sumout\,
	datac => \ALT_INV_Add1~25_sumout\,
	datad => \ALT_INV_Add1~21_sumout\,
	datae => \ALT_INV_Add1~29_sumout\,
	dataf => \ALT_INV_Add1~33_sumout\,
	combout => \Equal1~1_combout\);

-- Location: LABCELL_X88_Y35_N30
\Equal1~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \Equal1~2_combout\ = ( !\Add1~1_sumout\ & ( \Equal1~1_combout\ & ( (!\Add1~5_sumout\ & (!\Add1~37_sumout\ & (!\Add1~13_sumout\ & !\Add1~9_sumout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000010000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_Add1~5_sumout\,
	datab => \ALT_INV_Add1~37_sumout\,
	datac => \ALT_INV_Add1~13_sumout\,
	datad => \ALT_INV_Add1~9_sumout\,
	datae => \ALT_INV_Add1~1_sumout\,
	dataf => \ALT_INV_Equal1~1_combout\,
	combout => \Equal1~2_combout\);

-- Location: FF_X88_Y35_N52
\clock_reducer:i2[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \Add1~5_sumout\,
	sclr => \Equal1~2_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \clock_reducer:i2[7]~q\);

-- Location: LABCELL_X88_Y35_N36
\Equal1~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \Equal1~0_combout\ = ( !\Add1~29_sumout\ & ( !\Add1~37_sumout\ & ( (!\Add1~17_sumout\ & (!\Add1~25_sumout\ & (\Add1~21_sumout\ & !\Add1~33_sumout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000100000000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_Add1~17_sumout\,
	datab => \ALT_INV_Add1~25_sumout\,
	datac => \ALT_INV_Add1~21_sumout\,
	datad => \ALT_INV_Add1~33_sumout\,
	datae => \ALT_INV_Add1~29_sumout\,
	dataf => \ALT_INV_Add1~37_sumout\,
	combout => \Equal1~0_combout\);

-- Location: LABCELL_X88_Y35_N57
\reduced_clk~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \reduced_clk~0_combout\ = ( \Equal1~0_combout\ & ( \reduced_clk~q\ & ( (((\Add1~9_sumout\) # (\Add1~13_sumout\)) # (\Add1~1_sumout\)) # (\Add1~5_sumout\) ) ) ) # ( !\Equal1~0_combout\ & ( \reduced_clk~q\ ) ) # ( \Equal1~0_combout\ & ( !\reduced_clk~q\ & ( 
-- (!\Add1~5_sumout\ & (!\Add1~1_sumout\ & (!\Add1~13_sumout\ & !\Add1~9_sumout\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000100000000000000011111111111111110111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_Add1~5_sumout\,
	datab => \ALT_INV_Add1~1_sumout\,
	datac => \ALT_INV_Add1~13_sumout\,
	datad => \ALT_INV_Add1~9_sumout\,
	datae => \ALT_INV_Equal1~0_combout\,
	dataf => \ALT_INV_reduced_clk~q\,
	combout => \reduced_clk~0_combout\);

-- Location: FF_X88_Y35_N11
reduced_clk : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	asdata => \reduced_clk~0_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \reduced_clk~q\);

-- Location: IOIBUF_X72_Y0_N35
\data_in[11]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in(11),
	o => \data_in[11]~input_o\);

-- Location: IOIBUF_X89_Y6_N55
\data_in[9]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in(9),
	o => \data_in[9]~input_o\);

-- Location: IOIBUF_X89_Y4_N95
\data_in[10]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in(10),
	o => \data_in[10]~input_o\);

-- Location: IOIBUF_X89_Y38_N21
\data_in[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in(1),
	o => \data_in[1]~input_o\);

-- Location: IOIBUF_X89_Y8_N55
\data_in[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in(3),
	o => \data_in[3]~input_o\);

-- Location: MLABCELL_X87_Y34_N42
\i~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \i~3_combout\ = ( \data_encoder:i[3]~q\ & ( (!\data_encoder:i[0]~q\ & ((!\Equal0~0_combout\) # (!\data_in[3]~input_o\))) ) ) # ( !\data_encoder:i[3]~q\ & ( (!\data_encoder:i[0]~q\ & ((!\Equal0~0_combout\) # (\data_in[3]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1100111100000000110011110000000011111100000000001111110000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_Equal0~0_combout\,
	datac => \ALT_INV_data_in[3]~input_o\,
	datad => \ALT_INV_data_encoder:i[0]~q\,
	dataf => \ALT_INV_data_encoder:i[3]~q\,
	combout => \i~3_combout\);

-- Location: FF_X87_Y34_N44
\data_encoder:i[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \i~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \data_encoder:i[0]~q\);

-- Location: IOIBUF_X89_Y37_N55
\data_in[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in(2),
	o => \data_in[2]~input_o\);

-- Location: MLABCELL_X87_Y34_N21
\i~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \i~0_combout\ = ( \data_encoder:i[3]~q\ & ( (!\data_in[3]~input_o\ & (!\data_encoder:i[0]~q\ $ (((!\data_encoder:i[1]~q\))))) # (\data_in[3]~input_o\ & (!\Equal0~0_combout\ & (!\data_encoder:i[0]~q\ $ (!\data_encoder:i[1]~q\)))) ) ) # ( 
-- !\data_encoder:i[3]~q\ & ( (!\data_in[3]~input_o\ & (!\Equal0~0_combout\ & (!\data_encoder:i[0]~q\ $ (!\data_encoder:i[1]~q\)))) # (\data_in[3]~input_o\ & (!\data_encoder:i[0]~q\ $ (((!\data_encoder:i[1]~q\))))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011000111000100001100011100010000110010110010000011001011001000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_data_in[3]~input_o\,
	datab => \ALT_INV_data_encoder:i[0]~q\,
	datac => \ALT_INV_Equal0~0_combout\,
	datad => \ALT_INV_data_encoder:i[1]~q\,
	dataf => \ALT_INV_data_encoder:i[3]~q\,
	combout => \i~0_combout\);

-- Location: FF_X87_Y34_N23
\data_encoder:i[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \i~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \data_encoder:i[1]~q\);

-- Location: MLABCELL_X87_Y34_N30
\i~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \i~1_combout\ = ( \data_encoder:i[2]~q\ & ( \data_encoder:i[0]~q\ & ( (!\data_encoder:i[1]~q\ & ((!\Equal0~0_combout\) # (!\data_in[3]~input_o\ $ (!\data_encoder:i[3]~q\)))) ) ) ) # ( !\data_encoder:i[2]~q\ & ( \data_encoder:i[0]~q\ & ( 
-- (\data_encoder:i[1]~q\ & ((!\Equal0~0_combout\) # (!\data_in[3]~input_o\ $ (!\data_encoder:i[3]~q\)))) ) ) ) # ( \data_encoder:i[2]~q\ & ( !\data_encoder:i[0]~q\ & ( (!\Equal0~0_combout\) # (!\data_in[3]~input_o\ $ (!\data_encoder:i[3]~q\)) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000110111011110111000001101000011101101000011100000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_data_in[3]~input_o\,
	datab => \ALT_INV_Equal0~0_combout\,
	datac => \ALT_INV_data_encoder:i[1]~q\,
	datad => \ALT_INV_data_encoder:i[3]~q\,
	datae => \ALT_INV_data_encoder:i[2]~q\,
	dataf => \ALT_INV_data_encoder:i[0]~q\,
	combout => \i~1_combout\);

-- Location: FF_X87_Y34_N32
\data_encoder:i[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \i~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \data_encoder:i[2]~q\);

-- Location: IOIBUF_X89_Y38_N55
\data_in[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in(0),
	o => \data_in[0]~input_o\);

-- Location: MLABCELL_X87_Y34_N12
\Equal0~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \Equal0~0_combout\ = ( \data_in[0]~input_o\ & ( \data_encoder:i[1]~q\ & ( (\data_in[1]~input_o\ & (!\data_encoder:i[0]~q\ & (!\data_in[2]~input_o\ $ (\data_encoder:i[2]~q\)))) ) ) ) # ( !\data_in[0]~input_o\ & ( \data_encoder:i[1]~q\ & ( 
-- (!\data_in[1]~input_o\ & (\data_encoder:i[0]~q\ & (!\data_in[2]~input_o\ $ (!\data_encoder:i[2]~q\)))) ) ) ) # ( \data_in[0]~input_o\ & ( !\data_encoder:i[1]~q\ & ( (!\data_in[1]~input_o\ & (!\data_encoder:i[0]~q\ & (!\data_in[2]~input_o\ $ 
-- (\data_encoder:i[2]~q\)))) ) ) ) # ( !\data_in[0]~input_o\ & ( !\data_encoder:i[1]~q\ & ( (\data_in[1]~input_o\ & (\data_encoder:i[0]~q\ & (!\data_in[2]~input_o\ $ (\data_encoder:i[2]~q\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001000000000001100000000000100000000010001000000100000000000100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_data_in[1]~input_o\,
	datab => \ALT_INV_data_encoder:i[0]~q\,
	datac => \ALT_INV_data_in[2]~input_o\,
	datad => \ALT_INV_data_encoder:i[2]~q\,
	datae => \ALT_INV_data_in[0]~input_o\,
	dataf => \ALT_INV_data_encoder:i[1]~q\,
	combout => \Equal0~0_combout\);

-- Location: LABCELL_X88_Y34_N42
\Decoder0~7\ : cyclonev_lcell_comb
-- Equation(s):
-- \Decoder0~7_combout\ = ( \data_encoder:i[0]~q\ & ( (\data_encoder:i[2]~q\ & \data_encoder:i[1]~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000001100110000000000110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_data_encoder:i[2]~q\,
	datad => \ALT_INV_data_encoder:i[1]~q\,
	dataf => \ALT_INV_data_encoder:i[0]~q\,
	combout => \Decoder0~7_combout\);

-- Location: MLABCELL_X87_Y34_N57
\i~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \i~2_combout\ = ( \Decoder0~7_combout\ & ( (!\data_encoder:i[3]~q\ & ((!\Equal0~0_combout\) # (!\data_in[3]~input_o\))) ) ) # ( !\Decoder0~7_combout\ & ( (\data_encoder:i[3]~q\ & ((!\Equal0~0_combout\) # (!\data_in[3]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011111100000000001111110011111100000000001111110000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_Equal0~0_combout\,
	datac => \ALT_INV_data_in[3]~input_o\,
	datad => \ALT_INV_data_encoder:i[3]~q\,
	dataf => \ALT_INV_Decoder0~7_combout\,
	combout => \i~2_combout\);

-- Location: FF_X87_Y34_N59
\data_encoder:i[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \i~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \data_encoder:i[3]~q\);

-- Location: IOIBUF_X72_Y0_N52
\data_in[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in(5),
	o => \data_in[5]~input_o\);

-- Location: IOIBUF_X70_Y0_N35
\data_in[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in(7),
	o => \data_in[7]~input_o\);

-- Location: IOIBUF_X86_Y81_N52
\data_in[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in(6),
	o => \data_in[6]~input_o\);

-- Location: IOIBUF_X89_Y4_N44
\data_in[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in(4),
	o => \data_in[4]~input_o\);

-- Location: MLABCELL_X87_Y34_N24
\Mux0~4\ : cyclonev_lcell_comb
-- Equation(s):
-- \Mux0~4_combout\ = ( !\data_encoder:i[1]~q\ & ( ((!\data_encoder:i[3]~q\ & ((!\data_encoder:i[0]~q\ & ((\data_in[4]~input_o\))) # (\data_encoder:i[0]~q\ & (\data_in[5]~input_o\)))) # (\data_encoder:i[3]~q\ & (((\data_encoder:i[0]~q\))))) ) ) # ( 
-- \data_encoder:i[1]~q\ & ( ((!\data_encoder:i[3]~q\ & ((!\data_encoder:i[0]~q\ & ((\data_in[6]~input_o\))) # (\data_encoder:i[0]~q\ & (\data_in[7]~input_o\)))) # (\data_encoder:i[3]~q\ & (((\data_encoder:i[0]~q\))))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "on",
	lut_mask => "0000111100000000000011110000000001010101111111110011001111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_data_in[5]~input_o\,
	datab => \ALT_INV_data_in[7]~input_o\,
	datac => \ALT_INV_data_in[6]~input_o\,
	datad => \ALT_INV_data_encoder:i[3]~q\,
	datae => \ALT_INV_data_encoder:i[1]~q\,
	dataf => \ALT_INV_data_encoder:i[0]~q\,
	datag => \ALT_INV_data_in[4]~input_o\,
	combout => \Mux0~4_combout\);

-- Location: IOIBUF_X89_Y8_N21
\data_in[8]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in(8),
	o => \data_in[8]~input_o\);

-- Location: MLABCELL_X87_Y34_N48
\Mux0~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \Mux0~0_combout\ = ( !\data_encoder:i[1]~q\ & ( ((!\data_encoder:i[3]~q\ & (((\Mux0~4_combout\)))) # (\data_encoder:i[3]~q\ & ((!\Mux0~4_combout\ & ((\data_in[8]~input_o\))) # (\Mux0~4_combout\ & (\data_in[9]~input_o\))))) ) ) # ( \data_encoder:i[1]~q\ & 
-- ( ((!\data_encoder:i[3]~q\ & (((\Mux0~4_combout\)))) # (\data_encoder:i[3]~q\ & ((!\Mux0~4_combout\ & ((\data_in[10]~input_o\))) # (\Mux0~4_combout\ & (\data_in[11]~input_o\))))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "on",
	lut_mask => "0000000000001111000000000000111111111111001100111111111101010101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_data_in[11]~input_o\,
	datab => \ALT_INV_data_in[9]~input_o\,
	datac => \ALT_INV_data_in[10]~input_o\,
	datad => \ALT_INV_data_encoder:i[3]~q\,
	datae => \ALT_INV_data_encoder:i[1]~q\,
	dataf => \ALT_INV_Mux0~4_combout\,
	datag => \ALT_INV_data_in[8]~input_o\,
	combout => \Mux0~0_combout\);

-- Location: FF_X87_Y34_N50
\reset_i_out~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \Mux0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \reset_i_out~reg0_q\);

-- Location: MLABCELL_X87_Y34_N0
\encoded_data~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \encoded_data~0_combout\ = ( \Mux0~0_combout\ & ( !\current_start_value~q\ ) ) # ( !\Mux0~0_combout\ & ( \current_start_value~q\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011001100110011001100110011001111001100110011001100110011001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_current_start_value~q\,
	dataf => \ALT_INV_Mux0~0_combout\,
	combout => \encoded_data~0_combout\);

-- Location: FF_X87_Y34_N8
current_start_value : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \encoded_data~0_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \current_start_value~q\);

-- Location: LABCELL_X88_Y33_N33
\encoded_data[0]~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \encoded_data[0]~1_combout\ = ( !\current_start_value~q\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111000000000000000011111111111111110000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datae => \ALT_INV_current_start_value~q\,
	combout => \encoded_data[0]~1_combout\);

-- Location: LABCELL_X88_Y33_N24
\Decoder0~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \Decoder0~0_combout\ = ( !\data_encoder:i[1]~q\ & ( !\data_encoder:i[2]~q\ & ( !\data_encoder:i[0]~q\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111100000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_data_encoder:i[0]~q\,
	datae => \ALT_INV_data_encoder:i[1]~q\,
	dataf => \ALT_INV_data_encoder:i[2]~q\,
	combout => \Decoder0~0_combout\);

-- Location: FF_X88_Y33_N34
\encoded_data[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \encoded_data[0]~1_combout\,
	ena => \Decoder0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => encoded_data(0));

-- Location: LABCELL_X88_Y33_N36
\encoded_data[1]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \encoded_data[1]~feeder_combout\ = ( \encoded_data~0_combout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_encoded_data~0_combout\,
	combout => \encoded_data[1]~feeder_combout\);

-- Location: FF_X88_Y33_N38
\encoded_data[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \encoded_data[1]~feeder_combout\,
	ena => \Decoder0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => encoded_data(1));

-- Location: LABCELL_X85_Y34_N3
\encoded_data[2]~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \encoded_data[2]~3_combout\ = ( !\current_start_value~q\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111111111111111111100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_current_start_value~q\,
	combout => \encoded_data[2]~3_combout\);

-- Location: LABCELL_X85_Y34_N18
\Decoder0~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \Decoder0~1_combout\ = ( \data_encoder:i[0]~q\ & ( !\data_encoder:i[2]~q\ & ( !\data_encoder:i[1]~q\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111100001111000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_data_encoder:i[1]~q\,
	datae => \ALT_INV_data_encoder:i[0]~q\,
	dataf => \ALT_INV_data_encoder:i[2]~q\,
	combout => \Decoder0~1_combout\);

-- Location: FF_X85_Y34_N4
\encoded_data[2]~DUPLICATE\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \encoded_data[2]~3_combout\,
	ena => \Decoder0~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \encoded_data[2]~DUPLICATE_q\);

-- Location: LABCELL_X85_Y34_N12
\encoded_data[3]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \encoded_data[3]~feeder_combout\ = ( \encoded_data~0_combout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_encoded_data~0_combout\,
	combout => \encoded_data[3]~feeder_combout\);

-- Location: FF_X85_Y34_N14
\encoded_data[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \encoded_data[3]~feeder_combout\,
	ena => \Decoder0~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => encoded_data(3));

-- Location: LABCELL_X85_Y34_N48
\encoded_data[4]~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \encoded_data[4]~5_combout\ = ( !\current_start_value~q\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111111111111111111100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_current_start_value~q\,
	combout => \encoded_data[4]~5_combout\);

-- Location: LABCELL_X85_Y34_N57
\Decoder0~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \Decoder0~2_combout\ = ( !\data_encoder:i[0]~q\ & ( !\data_encoder:i[2]~q\ & ( \data_encoder:i[1]~q\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011111111000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_data_encoder:i[1]~q\,
	datae => \ALT_INV_data_encoder:i[0]~q\,
	dataf => \ALT_INV_data_encoder:i[2]~q\,
	combout => \Decoder0~2_combout\);

-- Location: FF_X85_Y34_N49
\encoded_data[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \encoded_data[4]~5_combout\,
	ena => \Decoder0~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => encoded_data(4));

-- Location: LABCELL_X85_Y34_N45
\encoded_data[5]~feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \encoded_data[5]~feeder_combout\ = ( \encoded_data~0_combout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_encoded_data~0_combout\,
	combout => \encoded_data[5]~feeder_combout\);

-- Location: FF_X85_Y34_N47
\encoded_data[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \encoded_data[5]~feeder_combout\,
	ena => \Decoder0~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => encoded_data(5));

-- Location: MLABCELL_X87_Y34_N39
\encoded_data[6]~7\ : cyclonev_lcell_comb
-- Equation(s):
-- \encoded_data[6]~7_combout\ = !\current_start_value~q\

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111000011110000111100001111000011110000111100001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_current_start_value~q\,
	combout => \encoded_data[6]~7_combout\);

-- Location: MLABCELL_X87_Y34_N18
\Decoder0~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \Decoder0~3_combout\ = ( !\data_encoder:i[2]~q\ & ( (\data_encoder:i[0]~q\ & \data_encoder:i[1]~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000110011000000000011001100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_data_encoder:i[0]~q\,
	datad => \ALT_INV_data_encoder:i[1]~q\,
	dataf => \ALT_INV_data_encoder:i[2]~q\,
	combout => \Decoder0~3_combout\);

-- Location: FF_X87_Y34_N40
\encoded_data[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \encoded_data[6]~7_combout\,
	ena => \Decoder0~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => encoded_data(6));

-- Location: FF_X87_Y34_N38
\encoded_data[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \encoded_data~0_combout\,
	sload => VCC,
	ena => \Decoder0~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => encoded_data(7));

-- Location: MLABCELL_X87_Y34_N3
\encoded_data[8]~9\ : cyclonev_lcell_comb
-- Equation(s):
-- \encoded_data[8]~9_combout\ = !\current_start_value~q\

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111000011110000111100001111000011110000111100001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_current_start_value~q\,
	combout => \encoded_data[8]~9_combout\);

-- Location: MLABCELL_X87_Y34_N45
\Decoder0~4\ : cyclonev_lcell_comb
-- Equation(s):
-- \Decoder0~4_combout\ = ( !\data_encoder:i[0]~q\ & ( (\data_encoder:i[2]~q\ & !\data_encoder:i[1]~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100000000000011110000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_data_encoder:i[2]~q\,
	datad => \ALT_INV_data_encoder:i[1]~q\,
	dataf => \ALT_INV_data_encoder:i[0]~q\,
	combout => \Decoder0~4_combout\);

-- Location: FF_X87_Y34_N4
\encoded_data[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \encoded_data[8]~9_combout\,
	ena => \Decoder0~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => encoded_data(8));

-- Location: FF_X87_Y34_N14
\encoded_data[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \encoded_data~0_combout\,
	sload => VCC,
	ena => \Decoder0~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => encoded_data(9));

-- Location: LABCELL_X85_Y34_N27
\encoded_data[10]~11\ : cyclonev_lcell_comb
-- Equation(s):
-- \encoded_data[10]~11_combout\ = ( !\current_start_value~q\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111111111111111111100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_current_start_value~q\,
	combout => \encoded_data[10]~11_combout\);

-- Location: LABCELL_X85_Y34_N36
\Decoder0~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \Decoder0~5_combout\ = ( \data_encoder:i[0]~q\ & ( \data_encoder:i[2]~q\ & ( !\data_encoder:i[1]~q\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_data_encoder:i[1]~q\,
	datae => \ALT_INV_data_encoder:i[0]~q\,
	dataf => \ALT_INV_data_encoder:i[2]~q\,
	combout => \Decoder0~5_combout\);

-- Location: FF_X85_Y34_N28
\encoded_data[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \encoded_data[10]~11_combout\,
	ena => \Decoder0~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => encoded_data(10));

-- Location: FF_X85_Y34_N38
\encoded_data[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \encoded_data~0_combout\,
	sload => VCC,
	ena => \Decoder0~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => encoded_data(11));

-- Location: MLABCELL_X87_Y34_N6
\encoded_data[12]~13\ : cyclonev_lcell_comb
-- Equation(s):
-- \encoded_data[12]~13_combout\ = !\current_start_value~q\

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111100000000111111110000000011111111000000001111111100000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => \ALT_INV_current_start_value~q\,
	combout => \encoded_data[12]~13_combout\);

-- Location: MLABCELL_X87_Y34_N9
\Decoder0~6\ : cyclonev_lcell_comb
-- Equation(s):
-- \Decoder0~6_combout\ = ( \data_encoder:i[1]~q\ & ( (\data_encoder:i[2]~q\ & !\data_encoder:i[0]~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000110000001100000011000000110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_data_encoder:i[2]~q\,
	datac => \ALT_INV_data_encoder:i[0]~q\,
	dataf => \ALT_INV_data_encoder:i[1]~q\,
	combout => \Decoder0~6_combout\);

-- Location: FF_X88_Y34_N7
\encoded_data[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \encoded_data[12]~13_combout\,
	sload => VCC,
	ena => \Decoder0~6_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => encoded_data(12));

-- Location: FF_X88_Y34_N26
\encoded_data[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \encoded_data~0_combout\,
	sload => VCC,
	ena => \Decoder0~6_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => encoded_data(13));

-- Location: MLABCELL_X87_Y34_N54
\encoded_data[14]~15\ : cyclonev_lcell_comb
-- Equation(s):
-- \encoded_data[14]~15_combout\ = ( !\current_start_value~q\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111111111111111111111111111100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_current_start_value~q\,
	combout => \encoded_data[14]~15_combout\);

-- Location: FF_X88_Y34_N40
\encoded_data[14]~DUPLICATE\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \encoded_data[14]~15_combout\,
	sload => VCC,
	ena => \Decoder0~7_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \encoded_data[14]~DUPLICATE_q\);

-- Location: FF_X88_Y34_N47
\encoded_data[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \encoded_data~0_combout\,
	sload => VCC,
	ena => \Decoder0~7_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => encoded_data(15));

-- Location: FF_X87_Y33_N4
\mask_out[0]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \data_encoder:i[0]~q\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \mask_out[0]~reg0_q\);

-- Location: LABCELL_X88_Y32_N24
\mask_out[1]~reg0feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \mask_out[1]~reg0feeder_combout\ = ( \data_encoder:i[1]~q\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_data_encoder:i[1]~q\,
	combout => \mask_out[1]~reg0feeder_combout\);

-- Location: FF_X88_Y32_N25
\mask_out[1]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \mask_out[1]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \mask_out[1]~reg0_q\);

-- Location: MLABCELL_X87_Y33_N57
\mask_out[2]~reg0feeder\ : cyclonev_lcell_comb
-- Equation(s):
-- \mask_out[2]~reg0feeder_combout\ = ( \data_encoder:i[2]~q\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_data_encoder:i[2]~q\,
	combout => \mask_out[2]~reg0feeder_combout\);

-- Location: FF_X87_Y33_N58
\mask_out[2]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \mask_out[2]~reg0feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \mask_out[2]~reg0_q\);

-- Location: FF_X87_Y34_N10
\mask_out[3]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \data_encoder:i[3]~q\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \mask_out[3]~reg0_q\);

-- Location: FF_X88_Y34_N41
\encoded_data[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \encoded_data[14]~15_combout\,
	sload => VCC,
	ena => \Decoder0~7_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => encoded_data(14));

-- Location: LABCELL_X88_Y34_N9
\Equal2~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \Equal2~0_combout\ = ( \data_in[1]~input_o\ & ( \sending_data:i3[2]~q\ & ( (\data_in[2]~input_o\ & ((!\data_in[0]~input_o\ & (!\sending_data:i3[1]~q\ & \sending_data:i3[0]~q\)) # (\data_in[0]~input_o\ & (\sending_data:i3[1]~q\ & 
-- !\sending_data:i3[0]~q\)))) ) ) ) # ( !\data_in[1]~input_o\ & ( \sending_data:i3[2]~q\ & ( (!\data_in[0]~input_o\ & (!\data_in[2]~input_o\ & (\sending_data:i3[1]~q\ & \sending_data:i3[0]~q\))) # (\data_in[0]~input_o\ & (\data_in[2]~input_o\ & 
-- (!\sending_data:i3[1]~q\ & !\sending_data:i3[0]~q\))) ) ) ) # ( \data_in[1]~input_o\ & ( !\sending_data:i3[2]~q\ & ( (!\data_in[2]~input_o\ & ((!\data_in[0]~input_o\ & (!\sending_data:i3[1]~q\ & \sending_data:i3[0]~q\)) # (\data_in[0]~input_o\ & 
-- (\sending_data:i3[1]~q\ & !\sending_data:i3[0]~q\)))) ) ) ) # ( !\data_in[1]~input_o\ & ( !\sending_data:i3[2]~q\ & ( (!\data_in[0]~input_o\ & (\data_in[2]~input_o\ & (\sending_data:i3[1]~q\ & \sending_data:i3[0]~q\))) # (\data_in[0]~input_o\ & 
-- (!\data_in[2]~input_o\ & (!\sending_data:i3[1]~q\ & !\sending_data:i3[0]~q\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100000000000010000001001000000000010000000010000000000100100000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_data_in[0]~input_o\,
	datab => \ALT_INV_data_in[2]~input_o\,
	datac => \ALT_INV_sending_data:i3[1]~q\,
	datad => \ALT_INV_sending_data:i3[0]~q\,
	datae => \ALT_INV_data_in[1]~input_o\,
	dataf => \ALT_INV_sending_data:i3[2]~q\,
	combout => \Equal2~0_combout\);

-- Location: LABCELL_X88_Y34_N51
\i3~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \i3~1_combout\ = ( \Add2~2_combout\ & ( (!\sending_data:i3[0]~q\ & ((!\data_in[3]~input_o\) # (!\Equal2~0_combout\))) ) ) # ( !\Add2~2_combout\ & ( (!\sending_data:i3[0]~q\ & ((!\Equal2~0_combout\) # (\data_in[3]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111010100000000111101010000000011111010000000001111101000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_data_in[3]~input_o\,
	datac => \ALT_INV_Equal2~0_combout\,
	datad => \ALT_INV_sending_data:i3[0]~q\,
	dataf => \ALT_INV_Add2~2_combout\,
	combout => \i3~1_combout\);

-- Location: FF_X88_Y34_N35
\sending_data:i3[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \reduced_clk~q\,
	asdata => \i3~1_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \sending_data:i3[0]~q\);

-- Location: LABCELL_X88_Y34_N45
\Add2~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~0_combout\ = ( \sending_data:i3[0]~q\ & ( !\sending_data:i3[1]~q\ ) ) # ( !\sending_data:i3[0]~q\ & ( \sending_data:i3[1]~q\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111111110000111100001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_sending_data:i3[1]~q\,
	dataf => \ALT_INV_sending_data:i3[0]~q\,
	combout => \Add2~0_combout\);

-- Location: LABCELL_X88_Y34_N12
\i3~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \i3~0_combout\ = ( \Equal2~0_combout\ & ( (\Add2~0_combout\ & (!\Add2~2_combout\ $ (!\data_in[3]~input_o\))) ) ) # ( !\Equal2~0_combout\ & ( \Add2~0_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011001100110011001100110011001100010010000100100001001000010010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_Add2~2_combout\,
	datab => \ALT_INV_Add2~0_combout\,
	datac => \ALT_INV_data_in[3]~input_o\,
	dataf => \ALT_INV_Equal2~0_combout\,
	combout => \i3~0_combout\);

-- Location: FF_X88_Y34_N14
\sending_data:i3[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \reduced_clk~q\,
	d => \i3~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \sending_data:i3[1]~q\);

-- Location: LABCELL_X88_Y34_N15
\i3~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \i3~3_combout\ = ( \data_in[3]~input_o\ & ( (\Add2~2_combout\ & !\Equal2~0_combout\) ) ) # ( !\data_in[3]~input_o\ & ( \Add2~2_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101010101010101010101010000010100000101000001010000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_Add2~2_combout\,
	datac => \ALT_INV_Equal2~0_combout\,
	dataf => \ALT_INV_data_in[3]~input_o\,
	combout => \i3~3_combout\);

-- Location: FF_X88_Y34_N17
\sending_data:i3[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \reduced_clk~q\,
	d => \i3~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \sending_data:i3[3]~q\);

-- Location: LABCELL_X88_Y34_N24
\Add2~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~2_combout\ = ( \sending_data:i3[3]~q\ & ( (!\sending_data:i3[2]~q\) # ((!\sending_data:i3[1]~q\) # (!\sending_data:i3[0]~q\)) ) ) # ( !\sending_data:i3[3]~q\ & ( (\sending_data:i3[2]~q\ & (\sending_data:i3[1]~q\ & \sending_data:i3[0]~q\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000100000001000000010000000111111110111111101111111011111110",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_sending_data:i3[2]~q\,
	datab => \ALT_INV_sending_data:i3[1]~q\,
	datac => \ALT_INV_sending_data:i3[0]~q\,
	dataf => \ALT_INV_sending_data:i3[3]~q\,
	combout => \Add2~2_combout\);

-- Location: LABCELL_X88_Y34_N48
\i3~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \i3~2_combout\ = ( \Equal2~0_combout\ & ( (\Add2~1_combout\ & (!\data_in[3]~input_o\ $ (!\Add2~2_combout\))) ) ) # ( !\Equal2~0_combout\ & ( \Add2~1_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011001100110011001100110011001100010010000100100001001000010010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_data_in[3]~input_o\,
	datab => \ALT_INV_Add2~1_combout\,
	datac => \ALT_INV_Add2~2_combout\,
	dataf => \ALT_INV_Equal2~0_combout\,
	combout => \i3~2_combout\);

-- Location: FF_X88_Y34_N50
\sending_data:i3[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \reduced_clk~q\,
	d => \i3~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \sending_data:i3[2]~q\);

-- Location: LABCELL_X88_Y34_N27
\Add2~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \Add2~1_combout\ = ( \sending_data:i3[0]~q\ & ( !\sending_data:i3[2]~q\ $ (!\sending_data:i3[1]~q\) ) ) # ( !\sending_data:i3[0]~q\ & ( \sending_data:i3[2]~q\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101010101010101010101011010010110100101101001011010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_sending_data:i3[2]~q\,
	datac => \ALT_INV_sending_data:i3[1]~q\,
	dataf => \ALT_INV_sending_data:i3[0]~q\,
	combout => \Add2~1_combout\);

-- Location: LABCELL_X88_Y34_N36
\Mux1~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \Mux1~3_combout\ = ( encoded_data(10) & ( \Add2~0_combout\ & ( (!\Add2~1_combout\) # (encoded_data(14)) ) ) ) # ( !encoded_data(10) & ( \Add2~0_combout\ & ( (encoded_data(14) & \Add2~1_combout\) ) ) ) # ( encoded_data(10) & ( !\Add2~0_combout\ & ( 
-- (!\Add2~1_combout\ & ((encoded_data(8)))) # (\Add2~1_combout\ & (encoded_data(12))) ) ) ) # ( !encoded_data(10) & ( !\Add2~0_combout\ & ( (!\Add2~1_combout\ & ((encoded_data(8)))) # (\Add2~1_combout\ & (encoded_data(12))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000010111110101000001011111010100000011000000111111001111110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => ALT_INV_encoded_data(12),
	datab => ALT_INV_encoded_data(14),
	datac => \ALT_INV_Add2~1_combout\,
	datad => ALT_INV_encoded_data(8),
	datae => ALT_INV_encoded_data(10),
	dataf => \ALT_INV_Add2~0_combout\,
	combout => \Mux1~3_combout\);

-- Location: LABCELL_X88_Y34_N21
\Mux1~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \Mux1~1_combout\ = ( \Add2~0_combout\ & ( encoded_data(11) & ( (!\Add2~1_combout\) # (encoded_data(15)) ) ) ) # ( !\Add2~0_combout\ & ( encoded_data(11) & ( (!\Add2~1_combout\ & ((encoded_data(9)))) # (\Add2~1_combout\ & (encoded_data(13))) ) ) ) # ( 
-- \Add2~0_combout\ & ( !encoded_data(11) & ( (\Add2~1_combout\ & encoded_data(15)) ) ) ) # ( !\Add2~0_combout\ & ( !encoded_data(11) & ( (!\Add2~1_combout\ & ((encoded_data(9)))) # (\Add2~1_combout\ & (encoded_data(13))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001000110111011000001010000010100010001101110111010111110101111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_Add2~1_combout\,
	datab => ALT_INV_encoded_data(13),
	datac => ALT_INV_encoded_data(15),
	datad => ALT_INV_encoded_data(9),
	datae => \ALT_INV_Add2~0_combout\,
	dataf => ALT_INV_encoded_data(11),
	combout => \Mux1~1_combout\);

-- Location: FF_X85_Y34_N5
\encoded_data[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \encoded_data[2]~3_combout\,
	ena => \Decoder0~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => encoded_data(2));

-- Location: LABCELL_X88_Y34_N0
\Mux1~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \Mux1~2_combout\ = ( \Add2~1_combout\ & ( encoded_data(0) & ( (!\Add2~0_combout\ & (encoded_data(4))) # (\Add2~0_combout\ & ((encoded_data(6)))) ) ) ) # ( !\Add2~1_combout\ & ( encoded_data(0) & ( (!\Add2~0_combout\) # (encoded_data(2)) ) ) ) # ( 
-- \Add2~1_combout\ & ( !encoded_data(0) & ( (!\Add2~0_combout\ & (encoded_data(4))) # (\Add2~0_combout\ & ((encoded_data(6)))) ) ) ) # ( !\Add2~1_combout\ & ( !encoded_data(0) & ( (encoded_data(2) & \Add2~0_combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000110011010101010000111111111111001100110101010100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => ALT_INV_encoded_data(4),
	datab => ALT_INV_encoded_data(2),
	datac => ALT_INV_encoded_data(6),
	datad => \ALT_INV_Add2~0_combout\,
	datae => \ALT_INV_Add2~1_combout\,
	dataf => ALT_INV_encoded_data(0),
	combout => \Mux1~2_combout\);

-- Location: LABCELL_X88_Y34_N57
\Mux1~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \Mux1~0_combout\ = ( encoded_data(3) & ( encoded_data(1) & ( (!\Add2~1_combout\) # ((!\Add2~0_combout\ & ((encoded_data(5)))) # (\Add2~0_combout\ & (encoded_data(7)))) ) ) ) # ( !encoded_data(3) & ( encoded_data(1) & ( (!\Add2~0_combout\ & 
-- (((!\Add2~1_combout\) # (encoded_data(5))))) # (\Add2~0_combout\ & (encoded_data(7) & ((\Add2~1_combout\)))) ) ) ) # ( encoded_data(3) & ( !encoded_data(1) & ( (!\Add2~0_combout\ & (((encoded_data(5) & \Add2~1_combout\)))) # (\Add2~0_combout\ & 
-- (((!\Add2~1_combout\)) # (encoded_data(7)))) ) ) ) # ( !encoded_data(3) & ( !encoded_data(1) & ( (\Add2~1_combout\ & ((!\Add2~0_combout\ & ((encoded_data(5)))) # (\Add2~0_combout\ & (encoded_data(7))))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000110101000011110011010111110000001101011111111100110101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => ALT_INV_encoded_data(7),
	datab => ALT_INV_encoded_data(5),
	datac => \ALT_INV_Add2~0_combout\,
	datad => \ALT_INV_Add2~1_combout\,
	datae => ALT_INV_encoded_data(3),
	dataf => ALT_INV_encoded_data(1),
	combout => \Mux1~0_combout\);

-- Location: LABCELL_X88_Y34_N30
\Mux1~4\ : cyclonev_lcell_comb
-- Equation(s):
-- \Mux1~4_combout\ = ( \Mux1~2_combout\ & ( \Mux1~0_combout\ & ( (!\Add2~2_combout\) # ((!\sending_data:i3[0]~q\ & ((\Mux1~1_combout\))) # (\sending_data:i3[0]~q\ & (\Mux1~3_combout\))) ) ) ) # ( !\Mux1~2_combout\ & ( \Mux1~0_combout\ & ( (!\Add2~2_combout\ 
-- & (((!\sending_data:i3[0]~q\)))) # (\Add2~2_combout\ & ((!\sending_data:i3[0]~q\ & ((\Mux1~1_combout\))) # (\sending_data:i3[0]~q\ & (\Mux1~3_combout\)))) ) ) ) # ( \Mux1~2_combout\ & ( !\Mux1~0_combout\ & ( (!\Add2~2_combout\ & 
-- (((\sending_data:i3[0]~q\)))) # (\Add2~2_combout\ & ((!\sending_data:i3[0]~q\ & ((\Mux1~1_combout\))) # (\sending_data:i3[0]~q\ & (\Mux1~3_combout\)))) ) ) ) # ( !\Mux1~2_combout\ & ( !\Mux1~0_combout\ & ( (\Add2~2_combout\ & ((!\sending_data:i3[0]~q\ & 
-- ((\Mux1~1_combout\))) # (\sending_data:i3[0]~q\ & (\Mux1~3_combout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000001100010001000000111101110111001111000100011100111111011101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_Mux1~3_combout\,
	datab => \ALT_INV_Add2~2_combout\,
	datac => \ALT_INV_Mux1~1_combout\,
	datad => \ALT_INV_sending_data:i3[0]~q\,
	datae => \ALT_INV_Mux1~2_combout\,
	dataf => \ALT_INV_Mux1~0_combout\,
	combout => \Mux1~4_combout\);

-- Location: FF_X88_Y34_N31
tmp_data_out : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \reduced_clk~q\,
	d => \Mux1~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \tmp_data_out~q\);

-- Location: IOIBUF_X28_Y81_N35
\need_to_process~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_need_to_process,
	o => \need_to_process~input_o\);

-- Location: IOIBUF_X8_Y0_N1
\tari[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_tari(0),
	o => \tari[0]~input_o\);

-- Location: IOIBUF_X74_Y81_N41
\tari[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_tari(1),
	o => \tari[1]~input_o\);

-- Location: IOIBUF_X26_Y81_N58
\tari[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_tari(2),
	o => \tari[2]~input_o\);

-- Location: IOIBUF_X52_Y81_N52
\tari[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_tari(3),
	o => \tari[3]~input_o\);

-- Location: IOIBUF_X30_Y0_N1
\tari[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_tari(4),
	o => \tari[4]~input_o\);

-- Location: IOIBUF_X68_Y0_N18
\tari[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_tari(5),
	o => \tari[5]~input_o\);

-- Location: IOIBUF_X60_Y0_N52
\tari[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_tari(6),
	o => \tari[6]~input_o\);

-- Location: IOIBUF_X36_Y81_N18
\tari[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_tari(7),
	o => \tari[7]~input_o\);

-- Location: IOIBUF_X56_Y0_N18
\tari[8]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_tari(8),
	o => \tari[8]~input_o\);

-- Location: IOIBUF_X26_Y0_N92
\tari[9]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_tari(9),
	o => \tari[9]~input_o\);

-- Location: IOIBUF_X34_Y81_N92
\tari[10]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_tari(10),
	o => \tari[10]~input_o\);

-- Location: IOIBUF_X66_Y0_N92
\tari[11]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_tari(11),
	o => \tari[11]~input_o\);

-- Location: LABCELL_X9_Y1_N0
\~QUARTUS_CREATED_GND~I\ : cyclonev_lcell_comb
-- Equation(s):

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
;
END structure;


