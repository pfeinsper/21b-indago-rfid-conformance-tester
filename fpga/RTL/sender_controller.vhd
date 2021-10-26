	-----------------------------------------
	--          Sender Controller          --
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
    
    entity sender_controller is
        port (
            -- flags
            clk                    : in std_logic;
            rst                    : in std_logic;
            enable                 : in std_logic;
            start                  : in std_logic;
            signal_generator_ended : in std_logic;
            encoder_ended          : in std_logic;
            has_gen                : in std_logic;
            clr_finished_sending   : in std_logic;
            mux                    : in std_logic;
            
            finished_sending : out std_logic := '0';
            start_encoder    : out std_logic := '0';
            start_generator  : out std_logic := '0'
        );
    
    end entity;
    
    
    architecture arch of sender_controller is
        
    type state_type_controller is (c_wait, c_wait_generator, c_wait_encoder);
    signal state_controller	: state_type_controller := c_wait;
    
    begin
        controller : process( clk, rst )
        begin
            if (rst = '1') then
                state_controller <= c_wait;
                
            elsif (rising_edge(clk) and enable = '1') then
                case state_controller is
                    when c_wait =>
                        start_encoder <= '0';
                        start_generator <= '0';
                        if (start = '1') then
                            if (has_gen = '1') then
                                state_controller <= c_wait_generator;
                                start_generator <= '1';
                            else
                                state_controller <= c_wait_encoder;
                                start_encoder <= '1';
                            end if;
                        end if ;
                    
                    when c_wait_generator =>
                        mux <= '0';
                        start_generator <= '0';
                        if (signal_generator_ended = '1') then
                            state_controller <= c_wait_encoder;
                            start_encoder <= '1';
                        end if ;

                    when c_wait_encoder =>
                        mux <= '1';
                        start_encoder <= '0';
                        if (encoder_ended = '1') then
                            state_controller <= c_wait;
                            finished_sending <= '1';
                        end if ;

                    when others =>
                        state_controller <= c_wait;
                    
                end case;
            end if;
            if (clr_finished_sending = '1') then
                finished_sending <= '0';
            end if ;
        end process ; -- controller
    
    end arch ; -- arch