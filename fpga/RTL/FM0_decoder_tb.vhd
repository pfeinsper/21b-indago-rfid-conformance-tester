library ieee;
use ieee.std_logic_1164.all;

entity fm0_decoder_tb is
end entity fm0_decoder_tb;

architecture tb of fm0_decoder_tb is

	component fm0_encoder
		generic (
				-- defining size of data in and clock speed
				data_width : natural := 26;
				tari_width : natural := 16;
				mask_width : natural := 6
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

	component fm0_decoder
	generic (
		-- defining size of data in and clock speed
		tari_width : natural := 16
	);

	port (
		-- flags
		clk : in std_logic;
		rst : in std_logic;
		enable : in std_logic;
		clr_err : in std_logic;

		err : out std_logic;
		eop : out std_logic;

		-- config
		tari_101 : in std_logic_vector(tari_width-1 downto 0); -- 1% above tari
		tari_099 : in std_logic_vector(tari_width-1 downto 0); -- 1% below tari
		tari_1616 : in std_logic_vector(tari_width-1 downto 0); -- 1% above 1.6 tari
		tari_1584 : in std_logic_vector(tari_width-1 downto 0); -- 1% below 1.6 tari

		data_in : in std_logic;

		-- output
		data_ready : out std_logic;

		data_out : out std_logic
	);

	end component;
	-- 11001001100100101101010101100111

	signal clk, eop, error_out, data_out, data_DUT, current_bit : std_logic := '0';
	constant data_to_be_received : std_logic_vector(31 downto 0) := "11001001100100101101010101100111";
	constant clk_period : time := 20 ns;
	constant tari : time := 10 us;


	begin

		clk_process : process
		begin
			clk <= '0';
			wait for clk_period/2;  --for 0.5 ns signal is '0'.
			clk <= '1';
			wait for clk_period/2;  --for next 0.5 ns signal is '1'.
		end process;

		DUT : process
		variable i : integer range 0 to 40 := 0;
		variable prev_value : std_logic := '1';
		begin
			current_bit <= data_to_be_received(i); 
			if (current_bit = '1') then
				data_DUT <= prev_value;
				wait for tari;
				prev_value := not prev_value;
			else
				data_DUT <= prev_value;
				wait for tari/2;
				data_DUT <= not prev_value;
				wait for tari/2;
			end if ;
			i := i + 1;
			if (i = 32) then
				current_bit <= '0';
				data_DUT <= '0';
				wait;
			end if ;
			
			
		end process ; -- DUT
		
		decoder : fm0_decoder port map (
			clk => clk,
			rst => '0',
			enable => '1',
			clr_err => '0',
			tari_101 => "0000000111111001", -- (16-len(bin(int(0.99*tari*f))[2:]))*"0" + bin(int(0.99*tari*f))[2:]
			tari_099 => "0000000111101111",
			tari_1616 => "0000001100101000",
			tari_1584 => "0000001100011000", -- freq/tari = clocks cycles
			data_out => data_out,
			eop => eop,
			err => error_out,
			data_in => data_DUT );
			
end tb;
