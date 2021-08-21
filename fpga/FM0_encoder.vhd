
	----------------------------------------
	--            FM0 COMPONENT           --
	-- Projeto final de Engenharia        --
	-- Professor Orientador: Rafael Corsi --
	-- Alunos:                            --
	-- 		Alexandre                     --
	-- 		Bruno kbc                     --
	-- 		Lucas Legal                   --
	-- 		Rafael Santos                 --
	----------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FM0_encoder is
	generic (
		clk_f      : natural := 50e6; -- Hz
		data_width : natural := 8;
		tari_width : natural := 16;
		mask_width : natural := 4
	);

	port (
		-- flags
		clk           : in std_logic;
		rst           : in std_logic;

		-- config
		tari          : in std_logic_vector(tari_width-1 downto 0);

		-- fifo data
		is_fifo_empty    : in std_logic;
		data_in          : in std_logic_vector((data_width + mask_width)-1 downto 0); -- format expected : ddddddddmmmm
		request_new_data : out std_logic;

		-- output
		data_out      : out std_logic
	);

end entity;


architecture arch of FM0_encoder is

	signal data       : std_logic_vector(data_width-1 downto 0);
	signal mask       : std_logic_vector(mask_width-1 downto 0);
	signal mask_value : integer;
	signal tari_value : integer;


	------------------------------
	--          flags           --
	------------------------------
	signal data_sender_start : std_logic := '0';
	signal data_sender_end   : std_logic := '0';

	signal half_tari_start, half_tari_end : std_logic := '0';
    signal full_tari_start, full_tari_end : std_logic := '0';
    signal tari_CS_start, tari_CS_end     : std_logic := '0';


	------------------------------
	--          states          --
	------------------------------
	type state_type_controller is (c_wait, c_send, c_request, c_wait_tari);
    signal state_controller	   : state_type_controller := c_wait;

	type state_type_encoder is (e_wait, e_encoding, e_end);
    signal state_encoder	   : state_type_encoder := e_wait;

	type state_type_sender is (s_wait, s_send_s1, s_send_s2, s_send_s2_part2, s_send_s3, s_send_s3_part2, s_send_s4, s_end);
    signal state_sender	       : state_type_sender := s_wait;


	begin

		------------------------------
		--          update          --
		------------------------------
		data       <= data_in((data_width + mask_width)-1 downto mask_width);
		mask       <= data_in(mask_width-1 downto 0);
		mask_value <= to_integer(unsigned(mask));
		tari_value <= to_integer(unsigned(tari));


		------------------------------
		--        controller        --
		------------------------------
		fm0_controller: process ( clk, rst )
			begin
				if (rst = '1') then
					data_sender_start <= '0';
					state_controller  <= c_wait;
	
				elsif (rising_edge(clk)) then
					case state_controller is
						when c_wait =>
							request_new_data <= '0';
							
							if (is_fifo_empty = '0') then
								state_controller <= c_send;
								data_sender_start <= '1';
							end if;

						when c_send =>
							if (data_sender_end = '1') then
								data_sender_start <= '0';
								state_controller <= c_request;
							end if;
						
						when c_request =>
							request_new_data <= '1';
							
							if (is_fifo_empty = '1') then
								tari_CS_start <= '1';
								state_controller <= c_wait_tari;
							else
								state_controller <= c_send;
							end if;
						
						when c_wait_tari =>
							if (tari_CS_end = '1') then
								tari_CS_start <= '0';
								state_controller <= c_wait;
							end if;

						when others =>
							state_controller <= c_wait;
       				end case;
				end if;
		end process;


		------------------------------
		--          sender          --
		------------------------------
		data_sender :  process( clk, rst )
			variable index_bit : integer range 0 to 7;
			begin
				if (rst = '1') then
					state_sender <= s_wait;
					half_tari_start <= '0';
					full_tari_start <= '0';

				elsif (rising_edge(clk)) then
					
					case state_sender is

						when s_wait =>
							if (data_sender_start = '1') then
								index_bit := 0;
								if (data(index_bit) = '1') then
									state_sender <= s_send_s1;
									full_tari_start <= '1';
								else
									half_tari_start <= '1';
									state_sender <= s_send_s3;
								end if;
							end if;

						when s_send_s1 => -- data 1, out 1 1
							data_out <= '1';

							if (full_tari_end = '1') then
								full_tari_start <= '0';
								index_bit := index_bit + 1;
								if (index_bit <= mask_value) then
									if (data(index_bit) = '1') then
										full_tari_start <= '1';
										state_sender <= s_send_s4;
									else
										half_tari_start <= '1';
										state_sender <= s_send_s3;
									end if;
								else
									state_sender <= s_end;
								end if;
							end if;
						------------------------------------
						when s_send_s2 => -- data 0, out 1 0
							data_out <= '1';
							if (half_tari_end = '1') then
								half_tari_start <= '0';
								half_tari_start <= '1';
								state_sender    <= s_send_s2_part2;
							end if;

						when s_send_s2_part2 => -- data 0, out 1 0
							data_out <= '0';
							if (half_tari_end = '1') then
								half_tari_start <= '0';
								index_bit := index_bit + 1;
								if (index_bit <= mask_value) then
									if (data(index_bit) = '1') then
										full_tari_start <= '1';
										state_sender <= s_send_s1;
									else
										half_tari_start <= '1';
										state_sender <= s_send_s2;
									end if;
								else
									state_sender <= s_end;
								end if;
							end if;
						------------------------------------
						when s_send_s3 => -- data 0, out 0 1
							data_out <= '0';
							if (half_tari_end = '1') then
								half_tari_start <= '0';
								half_tari_start <= '1';
								state_sender    <= s_send_s3_part2;
							end if;

						when s_send_s3_part2 =>  -- data 0, out 0 1
							data_out <= '1';
						
							if (half_tari_end = '1') then
								half_tari_start <= '0';
								index_bit := index_bit + 1;
								if (index_bit <= mask_value) then
									if (data(index_bit) = '1') then
										full_tari_start <= '1';
										state_sender <= s_send_s4;
									else
										half_tari_start <= '1';
										state_sender <= s_send_s3;
									end if;
								else
									state_sender <= s_end;
								end if;
							end if;
						------------------------------------
						when s_send_s4 =>  -- data 1, out 0 0
							data_out <= '0';
							if (full_tari_end = '1') then
								full_tari_start <= '0';
								index_bit := index_bit + 1;
								if (index_bit <= mask_value) then
									if (data(index_bit) = '1') then
										full_tari_start <= '1';
										state_sender <= s_send_s1;

									else
										half_tari_start <= '1';
										state_sender <= s_send_s2;

									end if;

								else
									state_sender <= s_end;
									
								end if;
							end if;
						------------------------------------
						when s_end =>
							half_tari_start <= '0';
							full_tari_start <= '0';
							state_sender <= s_wait;

						when others =>
							state_sender <= s_wait;
					end case;
				end if;
		end process;


		------------------------------
		--          timers          --
		------------------------------

		half_tari : process ( clk, rst )
			variable i : integer range 0 to 700 := 0;
			begin
				if (rst = '1') then
					i := 0;
					half_tari_end <= '0';

				elsif (rising_edge(clk)) then
					half_tari_end <= '0';
					
					if(	half_tari_start = '1') then
						i := i + 1;
						if (i = tari_value / 2) then
							i := 0;
							half_tari_end <= '1';
						end if;
					end if;
				end if;
		end process;

		full_tari : process ( clk, rst )
			variable i2 : integer range 0 to 700 := 0;
			begin
				if (rst = '1') then
					i2 := 0;
					half_tari_end <= '0';

				elsif (rising_edge(clk)) then
					full_tari_end <= '0';
					if(	full_tari_start = '1') then
						i2 := i2 + 1;
						if (i2 = tari_value) then
							i2 := 0;
							full_tari_end <= '1';
						end if;
					end if;
				end if;

		end process;

		wait_CS_tari : process ( clk, rst )
			variable i3 : integer range 0 to 1600 := 0;
			begin
				if (rst = '1') then
					i3 := 0;
					half_tari_end <= '0';

				elsif (rising_edge(clk)) then
					tari_CS_end <= '0';
					if(	tari_CS_start = '1') then
						i3 := i3 + 1;
						if (i3 = tari_value + tari_value) then
							i3 := 0;
							tari_CS_end <= '1';
						end if;
					end if;
				end if;
		end process;

end arch ; -- arch
