library ieee;
use ieee.std_logic_1164.all;

entity fm0_decoder_tb is
end entity fm0_decoder_tb;

architecture tb of fm0_decoder_tb is

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

	signal clk, eop, error_out, data_out, is_fifo_empty, request_new_data, encoded_data : std_logic := '0';
	constant mask : std_logic_vector(3 downto 0) := "0101";
	constant data_a : std_logic_vector(7 downto 0) := "UUU10110";
	signal data : std_logic_vector(11 downto 0) := data_a & mask;
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
		variable quant_packages : integer range 0 to 3 := 1;
		begin
			if (rising_edge(request_new_data)) then
				if (quant_packages > 0) then
					is_fifo_empty <= '0';
					if (quant_packages = 3) then
						data <= "111011111000";
					elsif (quant_packages = 2) then
						data <= "111010101000";
					elsif (quant_packages = 1) then
						data <= "UUUUUUUU0000";
					end if;
					quant_packages := quant_packages - 1;
				else
					is_fifo_empty <= '1';
				end if;
			end if;
		end process;
		
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
			data_in => encoded_data );
		
		encoder : fm0_encoder port map (
			clk => clk,
			rst => '0',
			enable => '1',
			tari => "0000000111110100", -- tari = 10 us
			data_out => encoded_data,
			is_fifo_empty => is_fifo_empty,
			data_in => data,
			request_new_data => request_new_data  );
		
	   
		
	
end tb;
