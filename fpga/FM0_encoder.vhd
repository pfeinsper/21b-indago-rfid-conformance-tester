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
		clk              : in std_logic;
		updating_data_in : in std_logic; -- if encoder has data do encode, is used to keep encoder index at 0 when no needed
		tari             : in std_logic_vector(11 downto 0); -- the value expected is 1e8 times greater than the real one, tari goes normaly btw 6.25 µs and 25µs
		data_in          : in std_logic_vector((data_width + mask_width)-1 downto 0); -- format expected : ddddddddmmmm
		
		data_out                 : out std_logic; 
		finished_releasing_data  : out std_logic
		
	);

end entity;


architecture arch of FM0_encoder is

	-- TODO
	--		encode data using clock full speed
	--		reduce clock to desirable speed (will be used to move data to output)
	--		move encoded data to output, at correct time intervals
	--		add logic to inform FIFO that Im free and can receive data
	--		make the maths to burn the correct amount of clocks
	--		make this shit compile

	-- assumindo tari = 7 µs 
	-- 2 tari = 14 µs = 1/14e-6 Hz = 71428.57142857143 Hz

	-- 1 clock takes 1/clk_f seconds
	-- tari/2 = x * clk_f
	-- x = (tari / 2) * clk_f
	-- because we cant use floats: x = (tari / 2e8) * clk_f
	-- if we burn x clocks, the new clock will tick at the correct speed

	signal data : std_logic_vector(data_width-1 downto 0) := data_in((data_width + mask_width)-1 downto mask_width);
	signal mask : std_logic_vector(mask_width-1 downto 0) := data_in(mask_width-1 downto 0);
	
	signal encoded_data        : std_logic_vector(2*data_width - 1 downto 0) := (others => '0');
	signal tmp_data_out        : std_logic := '0';
	signal reduced_clk         : std_logic := '0';
	signal current_start_value : std_logic := '1'; -- current value when a new bit is going to be modulated
	
	signal mask_value          : integer := to_integer(unsigned(mask));
	signal clock_tari_over_two : integer := 2; -- to_integer(unsigned(tari)) / 2e8 * clk_f;
	
	signal flag_released_data_insider : std_logic_vector(0 downto 0) := "0";
	
	
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

					i := i + 1;
					if (i = mask_value) then
						i := 0;
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

		

		sending_data : process( reduced_clk, updating_data_in )
			variable i3 : integer range 0 to 15 := 0;
			variable flag_release_data : integer range 0 to 1 := 0; -- flag used to inform if we already released the current package on data_out

			begin
				if (flag_release_data = 0) then
					if (rising_edge(reduced_clk)) then
						i3 := i3 + 1;
						tmp_data_out <= encoded_data(i3);
						
						if (i3 = mask_value) then
							i3 := 0;
							flag_release_data := 1;
						end if ;
					end if ;
				else
					if (rising_edge(updating_data_in)) then
						flag_release_data := 0;
					end if;
				end if ;
				flag_released_data_insider <= std_logic_vector(to_unsigned(flag_release_data, 1));
		end process ; -- sending_data
		
		
		
--		update_data_in : process( updating_data_in )
--			begin
--				-- test if need to have rising edge, if we dont need, nice fifo only flips updating_data_in when changing data_in
--				-- 		if we need, fifo can keep this value normaly low and when it updates data_in, it set`s updating_data_in hight for a few clock cycles
--
--				-- if (rising_edge(updating_data_in)) then
--				flag_release_data <= '0';
--				-- end if ;
--		end process ; -- update_data_in
		
		data_out <= tmp_data_out;

		finished_releasing_data <= '1' when  flag_released_data_insider = "1" else '0';

end arch ; -- arch