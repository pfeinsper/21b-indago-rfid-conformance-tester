library ieee;
use ieee.std_logic_1164.all;

entity sender_tb is
end entity sender_tb;

architecture tb of sender_tb is

	component sender
        generic (
            -- defining size of data in and clock speed
            data_width       : natural := 26;
            tari_width       : natural := 16;
            pw_width         : natural := 16;
            delimiter_width  : natural := 16;
            RTcal_width      : natural := 16;
            TRcal_width      : natural := 16;
            mask_width       : natural := 6
        );

        port (
            -- flags
            clk                  : in std_logic;
            clr_finished_sending : in std_logic;
            enable               : in std_logic;
            rst                  : in std_logic;

            finished_sending : out std_logic;

            -- fifo
            clear_fifo     : in std_logic;
            fifo_write_req : in std_logic;
            is_fifo_full   : out std_logic;
            usedw          : out std_logic_vector(7 downto 0);

            -- controller
            has_gen          : in std_logic;
            start_controller : in std_logic;

            -- generator
            is_preamble : in std_logic;

            -- config
            tari      : in std_logic_vector(tari_width-1 downto 0);
            pw        : in std_logic_vector(pw_width-1 downto 0);
            delimiter : in std_logic_vector(delimiter_width-1 downto 0);
            RTcal     : in std_logic_vector(RTcal_width-1 downto 0);
            TRcal     : in std_logic_vector(TRcal_width-1 downto 0);           

            -- data
            data : in std_logic_vector(31 downto 0);

            -- output
            q : out std_logic
        );

    end component;

	signal clk, clr_finished_sending, finished_sending, clear_fifo, fifo_write_req, has_gen, start_controller, is_preamble, data_out_sender, is_fifo_full : std_logic := '0';
	signal data : std_logic_vector(25 downto 0) := (others => '0');
	signal data_in : std_logic_vector(31 downto 0) := (others => '0');
	signal mask : std_logic_vector(5 downto 0) := "011010";
	signal usedw : std_logic_vector(7 downto 0) := (others => '0');
	constant clk_period : time := 20 ns;
	constant delay_nios : time := 5 us;


	begin

		clk_process : process
		begin
			clk <= '0';
			wait for clk_period/2;  --for 0.5 ns signal is '0'.
			clk <= '1';
			wait for clk_period/2;  --for next 0.5 ns signal is '1'.
		end process;

        NIOS_II : process
        variable i : integer range 0 to 100 := 0;
        begin
            start_controller <= '0';
            wait for 30 us;

            -- adding first package to fifo
            data <= "11000110000001100000001001";
            mask <= "011010";

            fifo_write_req <= '1';
            wait for clk_period;
            fifo_write_req <= '0';
            wait for delay_nios;


            data <= "00000000000000000111011011";
            mask <= "001010";

            fifo_write_req <= '1';
            wait for clk_period;
            fifo_write_req <= '0';

            data <= (others => '0');
            mask <= (others => '0');

            fifo_write_req <= '1';
            wait for clk_period;
            fifo_write_req <= '0';
            wait for delay_nios;


            -- configurating that we gonna use preamble
            has_gen <= '1';
            is_preamble <= '1';

            -- sending signal to start sending
            start_controller <= '1';
            wait for clk_period;
            start_controller <= '0';
            -----------------------------------

            -- waiting until sender has finished sending
            wait until (finished_sending = '1');
            clr_finished_sending <= '1';
            wait for delay_nios;
            clr_finished_sending <= '0';

            wait for delay_nios;
            wait for delay_nios;
            wait for delay_nios;

            -----------------------------------
            -- adding second package to fifo
            data <= "01100100111100010000010011";
            mask <= "011010";

            fifo_write_req <= '1';
            wait for clk_period;
            fifo_write_req <= '0';
            wait for delay_nios;


            data <= (others => '0');
            mask <= (others => '0');

            fifo_write_req <= '1';
            wait for clk_period;
            fifo_write_req <= '0';

            -- configurating that we not gonna use preamble or frame-sync
            has_gen <= '0';

            -- sending signal to start sending

            start_controller <= '1';
            wait for delay_nios;
            start_controller <= '0';
            -----------------------------------

            -- waiting until sender has finished sending
            wait until (finished_sending = '1');
            clr_finished_sending <= '1';
            wait for delay_nios;
            clr_finished_sending <= '0';
            wait for delay_nios;
            wait for delay_nios;
            wait for delay_nios;

            -----------------------------------
            -- adding third package to fifo
            data <= "00000000000000001001011100";
            mask <= "001010";

            fifo_write_req <= '1';
            wait for clk_period;
            fifo_write_req <= '0';

            data <= (others => '0');
            mask <= (others => '0');

            fifo_write_req <= '1';
            wait for clk_period;
            fifo_write_req <= '0';

            -- configurating that we not gonna use preamble or frame-sync
            has_gen <= '1';
            is_preamble <= '0';

            -- sending signal to start sending

            start_controller <= '1';
            wait for delay_nios;
            start_controller <= '0';
            -----------------------------------
            -- waiting until sender has finished sending
            wait until (finished_sending = '1');
            clr_finished_sending <= '1';
            wait for delay_nios;
            clr_finished_sending <= '0';




            wait;
        end process;

		sender_c : sender port map (
			clk                  => clk,
            clr_finished_sending => clr_finished_sending, -- escrita quando terminou o pacote pulsar esse fio
            enable               => '1',
            rst                  => '0',
            finished_sending     => finished_sending,
            clear_fifo           => clear_fifo,
            fifo_write_req       => fifo_write_req,
            is_fifo_full         => is_fifo_full,
            usedw                => usedw,
            has_gen              => has_gen,
            start_controller     => start_controller,
            is_preamble          => is_preamble,
            tari                 => "0000000111110100",
            pw                   => "0000000011111010",
            delimiter            => "0000001001110001",
            RTcal                => "0000010101000110",
            TRcal                => "0000010101000110",
            data                 => data_in,
            q                    => data_out_sender
		);

		data_in <= data & mask;
	
end tb;
