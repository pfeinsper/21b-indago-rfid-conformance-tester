library ieee;
use ieee.std_logic_1164.all;

entity fm0_encoder_tb is
end entity fm0_encoder_tb;

architecture tb of fm0_encoder_tb is

	component fm0_encoder
		generic (
				-- defining size of data in and clock speed
				data_width : natural := 26;
				tari_width : natural := 16;
				mask_width : natural := 6
		);
		port (
			clk : in std_logic;
			rst : in std_logic;
			enable : in std_logic;
			start_encoder : in std_logic;
			finished_sending : out std_logic;
	
			-- config
			tari : in std_logic_vector(tari_width-1 downto 0);
	
			-- fifo data
			is_fifo_empty    : in std_logic;
			data_in          : in std_logic_vector((data_width + mask_width)-1 downto 0); -- format expected : dddddddddddmmmmm
			request_new_data : out std_logic;
	
			-- output
			data_out : out std_logic := '0'
		);

	end component;

	signal clk, data_out, is_fifo_empty, request_new_data, start_encoder, finished_sending : std_logic := '0';
	signal data : std_logic_vector(25 downto 0) := (others => '1');
	signal data_in : std_logic_vector(31 downto 0) := (others => '0');
	signal mask : std_logic_vector(5 downto 0) := "011010";
	constant clk_period : time := 20 ns;


	begin

		clk_process : process
		begin
			clk <= '0';
			wait for clk_period/2;  --for 0.5 ns signal is '0'.
			clk <= '1';
			wait for clk_period/2;  --for next 0.5 ns signal is '1'.
		end process;


		controller: process
		begin
			start_encoder <= '1';
			wait until (finished_sending = '1');
			start_encoder <= '0';
			wait;
		end process;

		
		fifo : process ( request_new_data )
		variable quant_packages : integer range 0 to 3 := 3;
		begin
			if (rising_edge(request_new_data)) then
				if (quant_packages > 0) then
					is_fifo_empty <= '0';
					if (quant_packages = 3) then
						data <= "01011101111010111001110101";
						mask <= "011010";
					elsif (quant_packages = 2) then
						data <= "10111101010010110110001101";
						mask <= "000100";
					elsif (quant_packages = 1) then
						data <= (others => '0');
						mask <= (others => '0');
					end if;
					quant_packages := quant_packages - 1;
				else
					is_fifo_empty <= '1';
				end if;
			end if;
		end process;


		encoder : fm0_encoder port map (
			clk => clk,
			rst => '0',
			enable => '1',
			tari => "0000000111110100", -- tari = 10 us
			data_out => data_out,
			is_fifo_empty => is_fifo_empty,
			data_in => data_in,
			request_new_data => request_new_data,
			start_encoder => start_encoder,
			finished_sending => finished_sending
		);

		data_in <= data & mask;
	
end tb;
