library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FM0_encoder is
	generic (
		clk_f      : natural := 50e6; -- Hz
		data_width : natural := 8;
		mask_width : natural := 4
	);
	
	port ( 
		clk             : in std_logic;
		need_to_process : in std_logic; -- if encoder has data do encode, is used to keep encoder index at 0 when no needed
		tari            : in std_logic_vector(11 downto 0); -- the value expected is 1e8 times greater than the real one, tari goes normaly btw 6.25 µs and 25µs
		data_in         : in std_logic_vector((data_width + mask_width)-1 downto 0); -- format expected : ddddddddmmmm

		
		reduced_clk_out  : out std_logic;
		reset_i_out      : out std_logic;
		encoded_data_out : out std_logic_vector(data_width*2 -1 downto 0);
		not_encoded_data_out : out std_logic_vector(data_width-1 downto 0);
		mask_out : out std_logic_vector(mask_width -1 downto 0);
		
		data_out : out std_logic; 
		is_free  : out std_logic
		
	);

end entity;


architecture arch of FM0_encoder is

	-- TODO
	--		encode data using clock full speed
	--		reduce clock to desirable speed (will be used to move data to output)
	--		move encoded data to output, at correct time intervals
	--		add logic to inform FIFO that Im free and can receive data
	--		test if logic to keep encoder index at 0 and "is_free" is working
	--		make the maths to burn the correct amount of clocks
	--		make this shit compile

	-- assumindo tari = 7 µs 
	-- 2 tari = 14 µs = 1/14e-6 Hz = 71428.57142857143 Hz

	-- 1 clock takes 1/clk_f seconds
	-- tari/2 = x * clk_f
	-- x = (tari / 2) * clk_f
	-- because we cant use floats: x = (tari / 2e8) * clk_f
	-- if we burn x clocks, the new clock will tick at the correct speed

	signal data : std_logic_vector((data_width + mask_width)-1 downto mask_width) := data_in((data_width + mask_width)-1 downto mask_width);
	signal mask : std_logic_vector(mask_width-1 downto 0) := data_in(mask_width-1 downto 0);
	signal mask_value   : integer := to_integer(unsigned(mask));
	signal encoded_data : std_logic_vector(2*data_width - 1 downto 0) := (others => '0');
	signal tmp_data_out : std_logic := '0';
	signal reduced_clk  : std_logic := '0';
	signal current_start_value : std_logic := '1'; -- current value when a new bit is going to be modulated
	signal clock_tari_over_two : integer := 2; -- to_integer(unsigned(tari)) / 2e8 * clk_f;
	
	
	signal aa : std_logic := '0';
	
	
	begin
		data_encoder : process( clk )
			variable i : integer range 0 to 15 := 0;
			begin
				if (rising_edge(clk)) then
					encoded_data(2*i) <= current_start_value;
					if (data(i) = '0') then						
						encoded_data(2*i+1) <= not current_start_value;
					else
						encoded_data(2*i+1) <= current_start_value;
						
						current_start_value <= not current_start_value; -- default value only change when a '1' is current data bit
					end if ;
					
					reset_i_out <= data(i);
					mask_out <= std_logic_vector(to_unsigned(i, 4));
					i := i + 1;
					if (i = mask_value) then
						i := 0;
						aa <= not aa;
					end if;
				end if ;
		
		end process ; -- data_encoder

		

		clock_reducer : process( clk )
			variable i2 : integer range 0 to 700 := 0;
			begin
				if (rising_edge(clk)) then
					i2 := i2 + 1;
					if (i2 = clock_tari_over_two) then
						i2 := 0;
						reduced_clk <= not reduced_clk;
					end if ;
				end if ;
		end process ; -- clock_reducer

		

		sending_data : process( reduced_clk )
			variable i3 : integer range 0 to 15 := 0;
			begin
				if (rising_edge(reduced_clk)) then
					i3 := i3 + 1;
					tmp_data_out <= encoded_data(i3);

					if (i3 = mask_value) then
						i3 := 0;
					end if ;
				end if ;
		end process ; -- sending_data
		
		
		data_out <= tmp_data_out;
		
		encoded_data_out <= encoded_data;
		reduced_clk_out <= reduced_clk;
		
--		reset_i_out <= aa;
		not_encoded_data_out <= data;

end arch ; -- arch