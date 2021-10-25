library ieee;
use ieee.std_logic_1164.all;

entity signal_generator_tb is
end entity signal_generator_tb;

architecture tb of signal_generator_tb is

	component signal_generator is
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
    
    end component;


	signal clk, data_out, start_send, is_preamble, has_ended : std_logic := '0';
	constant clk_period : time := 20 ns;

	begin

		clk_process : process
		begin
			clk <= '0';
			wait for clk_period/2;  --for 0.5 ns signal is '0'.
			clk <= '1';
			wait for clk_period/2;  --for next 0.5 ns signal is '1'.
		end process;


		controller : process
		begin
			-- start_send <= '0';
			is_preamble <= '0';
			-- wait for 10 us;
			start_send <= '1';
			wait for clk_period;
			start_send <= '0';
			wait until (has_ended = '1');
			wait for 10 us;
			is_preamble <= '1';
			start_send <= '1';
			wait for clk_period;
			start_send <= '0';
			wait until (has_ended = '1');
			wait;
		end process;

		generator : signal_generator port map (
			clk => clk,
			rst => '0',
			enable => '1',
			start_send => start_send,
			is_preamble => is_preamble,
			tari => "0000000111110100",
			pw => "0000000011111010",
			delimiter => "0000001001110001",
			RTcal => "0000010101000110",
			TRcal => "0000010101000110",
			has_ended => has_ended,
			data_out => data_out
		);

end tb;
