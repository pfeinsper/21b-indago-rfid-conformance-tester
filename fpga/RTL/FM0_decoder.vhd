
-----------------------------------------
--               Decoder               --
-- Projeto Final de Engenharia         --
-- Professor Orientador: Rafael Corsi  --
-- Orientador: Shephard                --
-- Alunos:                             --
-- 		Alexandre Edington             --
-- 		Bruno Domingues                --
-- 		Lucas Leal                     --
-- 		Rafael Santos                  --
-----------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FM0_decoder is
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

		err : out std_logic := '0';
		eop : out std_logic := '0';

		-- config
		tari_101 : in std_logic_vector(tari_width-1 downto 0); -- 1% above tari
		tari_099 : in std_logic_vector(tari_width-1 downto 0); -- 1% below tari
		tari_1616 : in std_logic_vector(tari_width-1 downto 0); -- 1% above 1.6 tari
		tari_1584 : in std_logic_vector(tari_width-1 downto 0); -- 1% below 1.6 tari

		data_in : in std_logic := '0';

		-- output
		data_ready : out std_logic := '0';
		data_out : out std_logic := '0'
	);

end entity;

architecture arch of FM0_decoder is
	------------------------------
	--          values          --
	------------------------------
	signal tari_1616_value : integer;
	signal tari_1584_value : integer;
	signal tari_1010_value : integer;
	signal tari_0990_value : integer;	
	signal tari_0505_value : integer;
	signal tari_0495_value : integer;

	------------------------------
	--          flags           --
	------------------------------
	signal data_receiver_start : std_logic := '0';
	signal data_receiver_end   : std_logic := '0';

	signal clock_start, clock_kabum, clear_counter : std_logic := '0';
	
	signal prev_bit_c, prev_bit_d : std_logic := '0';
	signal clocks_counted : integer range 0 to 10000;

	------------------------------
	--          states          --
	------------------------------
	type state_type_controller is (c_wait, c_decode);
	signal state_controller	: state_type_controller := c_wait;
	
	type state_type_decoder is (d_wait, d_start_counter, d_start_counter2, d_wait_counter, d_wait_counter2, d_check_counter,d_check_counter2,  d_continue_counter, d_error, d_pass_1_01_tari, d_counter_cs);
	signal state_decoder     : state_type_decoder := d_wait;


	begin

		------------------------------
		--          update          --
		------------------------------
		tari_1616_value <= to_integer(unsigned(tari_1616));
		tari_1584_value <= to_integer(unsigned(tari_1584));
		tari_1010_value <= to_integer(unsigned(tari_101));
		tari_0990_value <= to_integer(unsigned(tari_099));	
		tari_0505_value <= to_integer(unsigned(tari_101(tari_width-1 downto 1)));
		tari_0495_value <= to_integer(unsigned(tari_099(tari_width-1 downto 1)));


		decoder_controller: process ( clk, rst )
			begin
				if (rst = '1') then
					state_controller  <= c_wait;
				
				elsif (rising_edge(clk) and enable = '1') then
					case state_controller is
						when c_wait =>
							if (prev_bit_c /= data_in) then
								prev_bit_c <= data_in;
								state_controller <= c_decode;
								data_receiver_start <= '1';
							end if;
						
						when c_decode =>
							prev_bit_c <= prev_bit_d;
							if (data_receiver_end = '1') then
								data_receiver_start <= '0';
								state_controller <= c_wait;
							end if;

						when others =>
							state_controller <= c_wait;
	   				end case;
				end if;
		end process;

		-- Decoder State Machine -> based on our diagram available in the github diagrams folder
		decoder_data: process ( clk, rst )
			begin
				if (rst = '1') then
					state_decoder  <= d_wait;
					
				elsif (rising_edge(clk) and enable = '1') then
					case state_decoder is
						when d_wait =>
							data_ready        <= '0';
							data_receiver_end <= '0';
							clear_counter     <= '1'; 				
							if (data_receiver_start = '1') then
								prev_bit_d <= data_in;
								state_decoder <= d_start_counter;
							end if;

						-- Start Counter
						when d_start_counter =>
							clock_start   <= '1';
							clear_counter <= '0';
							state_decoder <= d_wait_counter;

						when d_wait_counter =>
							if (clocks_counted > tari_1010_value) then
								state_decoder <= d_pass_1_01_tari;
							elsif (data_in /= prev_bit_d) then
								prev_bit_d    <= data_in;
								state_decoder <= d_check_counter;		
							else
								state_decoder <= d_wait_counter;
							end if;

						-- checks counter for a half or full tari
						when d_check_counter =>
							-- checks if counted clocks is b/w 0.495tari and 0.505tari to be a 0
							if (tari_0495_value <= clocks_counted and clocks_counted <= tari_0505_value) then
								prev_bit_d    <= data_in;
								state_decoder <= d_wait_counter2;

							-- checks if counted clocks is b/w 0.99tari and 1.01tari to be a 1
                            elsif (clocks_counted >= tari_0990_value and clocks_counted <= tari_1010_value ) then 
                                clear_counter <= '1';
								clock_start   <= '0';
								data_out	  <= '1';
								data_ready 	  <= '1';
								state_decoder <= d_wait;

							else
								clock_start <= '0';
                                clear_counter <= '1';
								state_decoder <= d_error;
							end if;

						-- Continue Counter -> as half tari has passed, now we need to wait for another half tari
						when d_wait_counter2 =>
							if (clocks_counted > tari_1010_value) then
								state_decoder <= d_pass_1_01_tari;
							elsif (data_in /= prev_bit_d) then
								prev_bit_d    <= data_in;
								state_decoder <= d_check_counter2;		
							else
								state_decoder <= d_wait_counter2;
							end if;

							
						-- checks counter for a half or full tari
						when d_check_counter2 =>
							-- checks if counted clocks is b/w 0.99tari and 1.01tari to be a 1
                            if (clocks_counted >= tari_0990_value and clocks_counted <= tari_1010_value ) then 
                                clear_counter <= '1';
								clock_start   <= '0';
								data_out	  <= '0';
								data_ready 	  <= '1';
								state_decoder <= d_wait;
							else
								clock_start <= '0';
                                clear_counter <= '1';
								state_decoder <= d_error;
							end if;
							
						-- Error -> if there is change in the data signal before or after the margin of error, this state should handle it
						when d_error =>
							if (clr_err = '1') then
								err <= '0';
								state_decoder <= d_wait;
							else
								err <= '1';
							end if ;
							
						-- pass 1.01 tari -> if there is no change in the data signal, for over 1.01tari, this states signals if it is an error or an end of command.
						when d_pass_1_01_tari =>
							if (data_in = '1') then
								state_decoder <= d_error;
							else
								state_decoder <= d_counter_cs;
								clear_counter <= '1';
							end if ;
							
						when d_counter_cs =>
							clear_counter <= '0';
							if (tari_1584_value < clocks_counted and clocks_counted < tari_1616_value) then
								state_decoder <= d_wait;
								eop <= '1';
								data_receiver_end <= '1';
							elsif (data_in /= prev_bit_d) then
								state_decoder <= d_error;
							end if;
							
						when others =>
							state_decoder <= d_wait;
	   				end case;
				end if;
		end process;

		counter : process( clk, rst )
		
		begin
			if (rst = '1') then
				clocks_counted <= 0;
				clock_kabum <= '0';
			elsif (rising_edge(clk)) then
				if (clear_counter = '1') then
					clocks_counted <= 0;
				end if ;
				if (clock_start = '1') then
					clock_kabum <= '0';
					clocks_counted <= clocks_counted + 1;
				end if ;
			end if ;
			
		end process ; -- counter


end arch ; -- arch
