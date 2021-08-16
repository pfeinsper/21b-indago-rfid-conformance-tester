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
		tari            : in integer  := 625; -- the value expected is 10e8 times greater than the real one, tari goes normaly btw 6.25 µs and 25µs
		data_in         : in std_logic_vector((data_width + mask_width)-1 downto 0); -- format expected : ddddddddmmmm

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
	--		test if logic to keep encoder index at 0 and "is_free" are working
	--		make the count to burn the correct amount of clocks
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
	signal mask_value : integer := to_integer(unsigned(mask));
	signal encoded_data : std_logic_vector(2*data_width - 1 downto 0);
	signal tmp_data_out : std_logic := '0';

	data_encoder : process( clk )
		variable i : integer range 0 to mask_value := 0;
		signal current_start_value : std_logic := '0'; -- current value when a new bit is going to be modulated
		begin
			if (data(i) = '0') then
				encoded_data(2*i downto 2*i + 1) <= current_start_value & not current_start_value;
			else
				encoded_data(2*i downto 2*i + 1) <= current_start_value & current_start_value;
				current_start_value <= not current_start_value; -- default value only change when a '1' is current data bit
			end if ;
			
			if (need_to_process = '1') then
				i := i + 1;
				if (i = mask_value) then
					i := 0;
					is_free <= '0';
				end if ;
			else 
				i := '0';
				tmp_data_out <= '0'; -- FIXME: need to check if without data being transmited this value is correct 
			end if ;
		
	end process ; -- data_encoder

	signal reduced_clk : std_logic := '0';

	clock_reducer : process( clk )
		constant clock_tari_over_two : integer := (tari / 2e8) * clk_f * ;
		variable i2 : integer range 0 to clock_tari_over_two := 0;
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
		variable i3 : integer range 0 to mask_value := '0';
		begin
			if (rising_edge(reduced_clk)) then
				i3 := i3 + 1;
				tmp_data_out <= encoded_data(i3);

				if (i3 = mask_value) then
					i3 := 0;
				end if ;
			end if ;
	end process ; -- sending_data

	begin
		data_out <= tmp_data_out;


	-- constant max_clk : natural := 999; 
	
	-- signal clk_reduced : std_logic := '0';
	
	-- clock_reducer : process ( clk )
	-- 	variable clk_counter: integer range 0 to max_clk := 0;
	-- 	begin
	-- 		if(rising_edge(clk)) then
	-- 			clk_counter := clk_counter + 1;
	-- 			if (clk_counter = max_clk) then
	-- 				clk_reduced <= not clk_reduced;
	-- 				clk_counter := 0;
	-- 			end if;	
	-- 		end if;	
	-- end process clock_reducer;
		
	-- signal data_out_tmp : std_logic_vector((2 * data_width)-1 downto 0);
	-- encoder : process( clk )
	-- variable i : integer range 0 to to_integer(unsigned(mask)) := 0;
	-- variable bit_tmp : std_logic := '0';
	-- begin
	-- 	if(rising_edge(clk)) then
	-- 		if (data_in(i) = '1') then
	-- 			data_out_tmp(i*2) <= bit_tmp;
	-- 			data_out_tmp(i*2+1) <= bit_tmp;
	-- 		else
	-- 			data_out_tmp(i*2) <= bit_tmp;
	-- 			data_out_tmp(i*2+1) <= not bit_tmp;
	-- 		end if ;
	-- 		bit_tmp <= not bit_tmp;

	-- 		i <= i + 1;
	-- 		if (i = to_integer(unsigned(mask))) then
	-- 			i := 0;
	-- 		end if;	
	-- 	end if;
	-- end process;

	-- begin
	-- 	data_out <= data_out_tmp;

end arch ; -- arch