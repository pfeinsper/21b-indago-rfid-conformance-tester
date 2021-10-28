
	-----------------------------------------
	--               PREAMBLE              --
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
    
    entity Signal_Generator is
        generic (
            -- defining size of data in and clock speed
            tari_width       : natural := 16;
            pw_width         : natural := 16;
            delimiter_width  : natural := 16;
            RTcal_width      : natural := 16;
            TRcal_width      : natural := 16
        );
    
        port (
            -- flags
            clk : in std_logic;
            rst : in std_logic;
            enable : in std_logic;
            start_send : in std_logic;
            is_preamble : in std_logic; -- if 1 is preamble, else is frame - sync 

            -- config
            tari      : in std_logic_vector(tari_width-1 downto 0);
            pw        : in std_logic_vector(pw_width-1 downto 0);
            delimiter : in std_logic_vector(delimiter_width-1 downto 0);
            RTcal     : in std_logic_vector(RTcal_width-1 downto 0);
            TRcal     : in std_logic_vector(TRcal_width-1 downto 0);
            
            -- output
            has_ended : out std_logic := '0';
            data_out : out std_logic := '0'
        );
    
    end entity;
    
    
    architecture arch of Signal_Generator is
        ------------------------------
        --          values          --
        ------------------------------
        signal tari_value, pw_value, delimiter_value, RTcal_value, TRcal_value: integer := 0;

        type state_type_generator is (g_wait, g_delimiter, g_data0, g_data0_PW, g_RTcal, g_RTcal_PW, g_TRcal, g_TRcal_PW);
        signal state_generator : state_type_generator := g_wait;
    
        begin

            tari_value      <= to_integer(unsigned(tari));
            pw_value        <= to_integer(unsigned(pw));
            delimiter_value <= to_integer(unsigned(delimiter));
            RTcal_value     <= to_integer(unsigned(RTcal));
            TRcal_value     <= to_integer(unsigned(TRcal));

            delimiter_generator: process ( clk, rst, enable )
            variable counter : integer range 0 to 2000 := 0;
            begin
                if (rst = '1') then
                    counter := 0;
                    data_out <= '0';
                    has_ended <= '0';
                    state_generator <= g_wait;
                    
                elsif (rising_edge(clk) and enable = '1') then
                    case state_generator is
                        when g_wait =>
                            counter := 0;
                            data_out <= '0';
                            has_ended <= '0';
                            if (start_send = '1') then
                                state_generator <= g_delimiter;
                            end if;

                        when g_delimiter =>
                            data_out <= '0';
                            if (counter = delimiter_value) then
                                counter := 0;
                                state_generator <= g_data0;
                            else
                                counter := counter + 1;
                            end if;

                        when g_data0 =>
                            data_out <= '1';
                            if (counter = tari_value - pw_value) then
                                counter := 0;
                                state_generator <= g_data0_PW;
                            else
                                counter := counter + 1;
                            end if;
                            
                        when g_data0_PW =>
                            data_out <= '0';
                            if (counter = pw_value) then
                                counter := 0;
                                state_generator <= g_RTcal;
                            else
                                counter := counter + 1;
                            end if;

                        when g_RTcal =>
                            data_out <= '1';
                            if (counter = RTcal_value - pw_value) then
                                counter := 0;
                                state_generator <= g_RTcal_PW;
                            else
                                counter := counter + 1;
                            end if;
                            
                        when g_RTcal_PW =>
                            data_out <= '0';
                            if (counter = pw_value) then
                                counter := 0;
                                if (is_preamble = '1') then
                                    state_generator <= g_TRcal;
                                else
                                    has_ended <= '1';
                                    state_generator <= g_wait;
                                end if ;
                            else
                                counter := counter + 1;
                            end if;
                                        
                        when g_TRcal =>
                            data_out <= '1';
                            if (counter = TRcal_value - pw_value) then
                                counter := 0;
                                state_generator <= g_TRcal_PW;
                            else
                                counter := counter + 1;
                            end if;
                        
                        when g_TRcal_PW =>
                            data_out <= '0';
                            if (counter = pw_value) then
                                counter := 0;
                                state_generator <= g_wait;
                                has_ended <= '1';
                            else
                                counter := counter + 1;
                            end if;

                        when others =>
                            state_generator <= g_wait;
                        
                    end case;
                end if;
		    end process;

    end arch ; -- arch
    