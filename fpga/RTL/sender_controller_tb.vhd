library ieee;
use ieee.std_logic_1164.all;

entity sender_controller_tb is
end entity sender_controller_tb;

architecture tb of sender_controller_tb is

    component sender_controller is
        port (
            -- flags
            clk : in std_logic;
            rst : in std_logic;
            enable : in std_logic;
            signal_generator_ended : in std_logic;
            encoder_ended : in std_logic;
            has_gen : in std_logic;
            clr_finished_sending : in std_logic;
            start : in std_logic;
            
            finished_sending : out std_logic;
            start_encoder : out std_logic;
            start_generator : out std_logic
        );
    
    end component;

	signal clk, signal_generator_ended, encoder_ended, has_gen, start_encoder, start_generator, clr_finished_sending, finished_sending, start : std_logic := '0';
	constant clk_period : time := 20 ns;

	begin

		clk_process : process
		begin
			clk <= '0';
			wait for clk_period/2;  --for 0.5 ns signal is '0'.
			clk <= '1';
			wait for clk_period/2;  --for next 0.5 ns signal is '1'.
		end process;

        NIOS_II : process
        begin
            -- waiting before requesting to send data
            start <= '0';
            wait for 30 us;

            -- requesting to send without preamble or frame-sync
            has_gen <= '0';
            start <= '1';
            wait for 5 us;
            start <= '0';
            
            wait until (finished_sending = '1');
            wait for 5 us;
            clr_finished_sending <= '1';
            wait for 10 us;
            clr_finished_sending <= '0';
            
            
            -- waiting before requesting to send data
            wait for 20 us;
            
            -- requesting to send with preamble or framesync
            has_gen <= '1';
            start <= '1';
            wait for 5 us;
            start <= '0';

            wait until (finished_sending = '1');
            wait for 5 us;
            clr_finished_sending <= '1';
            wait for 10 us;
            clr_finished_sending <= '0';

            start <= '0';
            wait;
            
        end process ; -- resto_sender

        generator : process
        begin
            signal_generator_ended <= '0';
            wait until (start_generator = '1');
            wait for 10 us;
            signal_generator_ended <= '1';
            wait for clk_period;
            
        end process ; -- generator

        encoder : process
        begin
            encoder_ended <= '0';
            wait until (start_encoder = '1');
            wait for 20 us;
            encoder_ended <= '1';
            wait for clk_period;
            
        end process ; -- encoder


	   	sender_controller_c : sender_controller port map (
            clk => clk,
            rst => '0',
            enable => '1',
            signal_generator_ended => signal_generator_ended,
            encoder_ended => encoder_ended,
            has_gen => has_gen,
            start_encoder => start_encoder,
            start_generator => start_generator,
            clr_finished_sending => clr_finished_sending,
            finished_sending => finished_sending,
            start => start
       );
		
	
end tb;
