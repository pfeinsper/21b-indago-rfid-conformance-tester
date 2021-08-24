library IEEE;
use IEEE.std_logic_1164.all;

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

	signal clk, data_out, is_fifo_empty, request_new_data : std_logic;
	constant CLK_PERIOD : time := 20 ns;
	constant one_package : time := 10 * 8 us;


	begin

		clk_process : process
		begin
			clk <= '0';
			wait for clk_period/2;  --for 0.5 ns signal is '0'.
			clk <= '1';
			wait for clk_period/2;  --for next 0.5 ns signal is '1'.
		end process;

		
		set_is_fifo_empty : process
		begin
			is_fifo_empty <= '0';
			wait for one_package;
			is_fifo_empty <= '1';
			wait;
		end process;


		u0 : fm0_encoder port map (
			clk => clk,
			rst => '0',
			tari => "0000000111110100", -- tari = 10 us
			data_out => data_out,
			is_fifo_empty => is_fifo_empty,
			data_in => "100000101000",
			request_new_data => request_new_data  );

end tb;
