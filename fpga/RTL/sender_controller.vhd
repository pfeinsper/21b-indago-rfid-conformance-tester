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
    --! \sender_controller.vhd
    --!
    --!
    library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    --! \brief This component controls the state machine in the sender
    --!
    --! This component is responsible for indicating to the other sender components if the data should be encoded or sent, since the TARI controls the rate at which encoded packets can be sent
    --!
    entity sender_controller is
        port (
            -- flags
            clk                    : in std_logic; --! Clock input
            rst                    : in std_logic; --! Reset high
            enable                 : in std_logic; --! Enable high
            start                  : in std_logic; --! Flag indicates a new command must be encoded and sent
            signal_generator_ended : in std_logic; --! Flag high if preamble or framesync finished
            encoder_ended          : in std_logic; --! Flag high if encoder has no more data to send
            has_gen                : in std_logic; --! Flag high if using the preamble or framesync
            clr_finished_sending   : in std_logic; --! Clears the finished_sending flag
            
            mux              : out std_logic;        --! Flag control mux output
            finished_sending : out std_logic := '0'; --! Flag high if sender has no more data to send
            start_encoder    : out std_logic := '0'; --! Flag high to start the encoder
            start_generator  : out std_logic := '0'  --! Flag high to start preamble or framesync
        );
    
    end entity;
    
    
    architecture arch of sender_controller is
        
    type state_type_controller is (c_wait, c_wait_generator, c_wait_encoder);
    signal state_controller	: state_type_controller := c_wait;
    
    begin
        controller : process( clk, rst, enable, clr_finished_sending )
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
                        if (encoder_ended = '1') then
                            state_controller <= c_wait;
                            start_encoder <= '0';
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