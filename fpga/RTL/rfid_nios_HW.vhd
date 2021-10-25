library IEEE;
use IEEE.std_logic_1164.all;

entity rfid_nios_HW is
	port (
			-- Gloabals
			fpga_clk_50 : in std_logic;		-- clock.clk

			-- I/Os
			pin_rx      : in std_logic;
			pin_tx		: out std_logic
	  );
end entity rfid_nios_HW;

architecture hw of rfid_nios_HW is

    component RFID_NIOS is
        port (
            clk_clk       : in  std_logic := 'X'; -- clk
            pins_rx       : in  std_logic := 'X'; -- rx
            pins_tx       : out std_logic;        -- tx
            reset_reset_n : in  std_logic := 'X'  -- reset_n
        );
    end component RFID_NIOS;
	
begin

	 u0 : component RFID_NIOS
		  port map (
				clk_clk       => fpga_clk_50,       --  clk.clk
				pins_rx       => pin_rx,       		--  pins.rx
				pins_tx       => pin_tx,       		--  pins.tx
				reset_reset_n => '1'					   --  reset.reset_n
		  );
		 
end hw;
