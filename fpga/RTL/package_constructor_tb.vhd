library ieee;
use ieee.std_logic_1164.all;

entity package_constructor_tb is
end entity package_constructor_tb;

architecture tb of package_constructor_tb is

    component package_constructor
	    generic (
            -- defining size of data in and clock speed
            data_width : natural := 8;
            mask_width : natural := 4

        );
        port (
            -- flags
            clk : in std_logic;
            rst : in std_logic;
    
            data_ready : in std_logic := '0';
            data_in    : in std_logic := '0';
            eop        : in std_logic := '0';
    
            -- output
            write_request_out : out std_logic := '0';
            data_out       : out std_logic_vector((data_width + mask_width)-1 downto 0)
        );

    end component;

	signal clk, eop, data_in_constructor, write_request_out, data_ready : std_logic := '0';
    signal data_constructor_out : std_logic_vector (11 downto 0);
	constant clk_period : time := 20 ns;
	constant tari_period : time := 10 us;

	begin

		clk_process : process
		begin
			clk <= '0';
			wait for clk_period/2;  --for 0.5 ns signal is '0'.
			clk <= '1';
			wait for clk_period/2;  --for next 0.5 ns signal is '1'.
		end process;

		
		decoder : process
		begin
			wait for 30 us;

			data_in_constructor <= '0';
			data_ready <= '1';
			wait for clk_period;
			data_ready <= '0';
			wait for tari_period;
			
			data_in_constructor <= '1';
			data_ready <= '1';
			wait for clk_period;
			data_ready <= '0';
			wait for tari_period;

			eop <= '1';
			wait for clk_period;
			eop <= '0';

			wait for 30 us;
			
			
			data_in_constructor <= '1';
			data_ready <= '1';
			wait for clk_period;
			data_ready <= '0';
			wait for tari_period;
			
			data_in_constructor <= '1';
			data_ready <= '1';
			wait for clk_period;
			data_ready <= '0';
			wait for tari_period * 1.6;

			data_in_constructor <= '1';
			data_ready <= '1';
			wait for clk_period;
			data_ready <= '0';
			wait for tari_period;
			
			data_in_constructor <= '1';
			data_ready <= '1';
			wait for clk_period;
			data_ready <= '0';
			wait for tari_period;
			
			data_in_constructor <= '1';
			data_ready <= '1';
			wait for clk_period;
			data_ready <= '0';
			wait for tari_period;
			
			data_in_constructor <= '0';
			data_ready <= '1';
			wait for clk_period;
			data_ready <= '0';
			wait for tari_period;
			
			data_in_constructor <= '1';
			data_ready <= '1';
			wait for clk_period;
			data_ready <= '0';
			wait for tari_period;
			
			data_in_constructor <= '1';
			data_ready <= '1';
			wait for clk_period;
			data_ready <= '0';
			wait for tari_period;
			
			data_in_constructor <= '1';
			data_ready <= '1';
			wait for clk_period;
			data_ready <= '0';
			wait for tari_period;
			
			data_in_constructor <= '1';
			data_ready <= '1';
			wait for clk_period;
			data_ready <= '0';
			wait for tari_period * 1.6;

			eop <= '1';
			wait for clk_period;
			eop <= '0';
			wait;

		end process ; -- decoder


	   	p_constructor : package_constructor port map (
            clk => clk,
            rst => '0',
            data_ready => data_ready,
            data_in => data_in_constructor,
            eop => eop,
            write_request_out => write_request_out,
            data_out => data_constructor_out
       );
		
	
end tb;
