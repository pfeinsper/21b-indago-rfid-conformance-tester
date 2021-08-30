library ieee;
use ieee.std_logic_1164.all;

entity fm0_tb is
end entity fm0_tb;

architecture tb of fm0_tb is

	component fm0_encoder
		generic (
				-- defining size of data in and clock speed
				clk_f      : natural := 50e6; -- Hz
				data_width : natural := 8;
				tari_width : natural := 16;
				mask_width : natural := 4
		);
		port (
			-- flags 
			clk : in std_logic;
			rst : in std_logic;
			enable : in std_logic;


			-- config
			tari : in std_logic_vector(tari_width-1 downto 0);

			-- fifo data
			is_fifo_empty    : in std_logic;
			data_in          : in std_logic_vector((data_width + mask_width)-1 downto 0); -- format expected : ddddddddmmmm
			request_new_data : out std_logic;

			-- output
			data_out : out std_logic
		);

	end component;

	signal clk, data_out, is_fifo_empty, request_new_data : std_logic := '0';
	signal data_in : std_logic_vector(11 downto 0) := "111111111000";
	constant clk_period : time := 20 ns;


	begin

		clk_process : process
		begin
			clk <= '0';
			wait for clk_period/2;  --for 0.5 ns signal is '0'.
			clk <= '1';
			wait for clk_period/2;  --for next 0.5 ns signal is '1'.
		end process;

		
		fifo : process ( request_new_data )
		variable quant_packages : integer range 0 to 3 := 3;
		begin
			if (rising_edge(request_new_data)) then
				if (quant_packages > 0) then
					is_fifo_empty <= '0';
					if (quant_packages = 3) then
						data_in <= "111011111000";
					elsif (quant_packages = 2) then
						data_in <= "111010101000";
					elsif (quant_packages = 1) then
						data_in <= "000010100100";
					end if;
					quant_packages := quant_packages - 1;
				else
					is_fifo_empty <= '1';
				end if;
			end if;
		end process;


		u0 : fm0_encoder port map (
			clk => clk,
			rst => '0',
			enable => '1',
			tari => "0000000111110100", -- tari = 10 us
			data_out => data_out,
			is_fifo_empty => is_fifo_empty,
			data_in => data_in,
			request_new_data => request_new_data  );
	
end tb;
