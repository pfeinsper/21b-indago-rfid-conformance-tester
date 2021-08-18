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

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "08/17/2021 18:04:00"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          FM0_encoder
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY FM0_encoder_vhd_vec_tst IS
END FM0_encoder_vhd_vec_tst;
ARCHITECTURE FM0_encoder_arch OF FM0_encoder_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL data_in : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL data_out : STD_LOGIC;
SIGNAL encoded_data_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL finished_releasing_data : STD_LOGIC;
SIGNAL reduced_clk_out : STD_LOGIC;
SIGNAL tari : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL updating_data_in : STD_LOGIC;
COMPONENT FM0_encoder
	PORT (
	clk : IN STD_LOGIC;
	data_in : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
	data_out : OUT STD_LOGIC;
	encoded_data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	finished_releasing_data : OUT STD_LOGIC;
	reduced_clk_out : OUT STD_LOGIC;
	tari : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
	updating_data_in : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : FM0_encoder
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	data_in => data_in,
	data_out => data_out,
	encoded_data_out => encoded_data_out,
	finished_releasing_data => finished_releasing_data,
	reduced_clk_out => reduced_clk_out,
	tari => tari,
	updating_data_in => updating_data_in
	);

-- clk
t_prcs_clk: PROCESS
BEGIN
LOOP
	clk <= '0';
	WAIT FOR 10000 ps;
	clk <= '1';
	WAIT FOR 10000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clk;
-- data_in[11]
t_prcs_data_in_11: PROCESS
BEGIN
	data_in(11) <= '0';
WAIT;
END PROCESS t_prcs_data_in_11;
-- data_in[10]
t_prcs_data_in_10: PROCESS
BEGIN
	data_in(10) <= '1';
WAIT;
END PROCESS t_prcs_data_in_10;
-- data_in[9]
t_prcs_data_in_9: PROCESS
BEGIN
	data_in(9) <= '1';
WAIT;
END PROCESS t_prcs_data_in_9;
-- data_in[8]
t_prcs_data_in_8: PROCESS
BEGIN
	data_in(8) <= '0';
WAIT;
END PROCESS t_prcs_data_in_8;
-- data_in[7]
t_prcs_data_in_7: PROCESS
BEGIN
	data_in(7) <= '1';
WAIT;
END PROCESS t_prcs_data_in_7;
-- data_in[6]
t_prcs_data_in_6: PROCESS
BEGIN
	data_in(6) <= '0';
WAIT;
END PROCESS t_prcs_data_in_6;
-- data_in[5]
t_prcs_data_in_5: PROCESS
BEGIN
	data_in(5) <= '0';
WAIT;
END PROCESS t_prcs_data_in_5;
-- data_in[4]
t_prcs_data_in_4: PROCESS
BEGIN
	data_in(4) <= '1';
WAIT;
END PROCESS t_prcs_data_in_4;
-- data_in[3]
t_prcs_data_in_3: PROCESS
BEGIN
	data_in(3) <= '1';
WAIT;
END PROCESS t_prcs_data_in_3;
-- data_in[2]
t_prcs_data_in_2: PROCESS
BEGIN
	data_in(2) <= '0';
WAIT;
END PROCESS t_prcs_data_in_2;
-- data_in[1]
t_prcs_data_in_1: PROCESS
BEGIN
	data_in(1) <= '0';
WAIT;
END PROCESS t_prcs_data_in_1;
-- data_in[0]
t_prcs_data_in_0: PROCESS
BEGIN
	data_in(0) <= '0';
WAIT;
END PROCESS t_prcs_data_in_0;
END FM0_encoder_arch;
