library ieee;
use ieee.std_logic_1164.all;

entity receiver_tb is
end entity receiver_tb;

architecture tb of receiver_tb is

	component receiver
        generic (
            -- defining size of data in and clock speed
            data_width : natural := 26;
            tari_width : natural := 16;
            mask_width : natural := 6
        );

        port (
            -- GENERAL
            
            -- flags
            clk    : in std_logic;
            rst    : in std_logic;
            enable : in std_logic;

            -- data in from DUT
            data_DUT : in std_logic;
            -----------------------------------
            -- DECODER

            -- config
            tari_101  : in std_logic_vector(tari_width-1 downto 0); -- 1% above tari
            tari_099  : in std_logic_vector(tari_width-1 downto 0); -- 1% below tari
            tari_1616 : in std_logic_vector(tari_width-1 downto 0); -- 1% above 1.6 tari
            tari_1584 : in std_logic_vector(tari_width-1 downto 0); -- 1% below 1.6 tari
            
            -- flag
            clr_err_decoder : in std_logic;
            err_decoder     : out std_logic;
            -----------------------------------
            -- FIFO

            -- flags
            rdreq : in std_logic;
            sclr  : in std_logic;

            empty : out std_logic;
            full  : out std_logic;
            
            -- data output
            data_out_fifo : out std_logic_vector(31 downto 0);
            usedw	      : out std_logic_vector(7 downto 0)
        );
    end component;

    
	signal clk, data_DUT, clr_err_decoder, err_decoder, rdreq, sclr, empty, full : std_logic := '0';
	signal out_fifo : std_logic_vector(31 downto 0) := (others => '0');
    signal data : std_logic_vector(25 downto 0) := (others => '0');
    signal mask : std_logic_vector(5 downto 0) := (others => '0');
	signal usedw : std_logic_vector(7 downto 0) := (others => '0');
    signal current_bit : std_logic := '0';
    constant clk_period : time := 20 ns;
	constant nios_delay : time := 5 us;
	constant tari : time := 10 us;
    signal i2 : integer range 0 to 1000:= 0;
    
	constant size : integer := 17;
    constant data_to_be_received : std_logic_vector(size-1 downto 0) := "10000010011010010";
	
    begin

		clk_process : process
		begin
			clk <= '0';
			wait for clk_period/2;  --for 0.5 ns signal is '0'.
			clk <= '1';
			wait for clk_period/2;  --for next 0.5 ns signal is '1'.
		end process;

        DUT : process
		variable i : integer range 0 to 1000 := 0;
		variable prev_value : std_logic := '1';
		variable current : std_logic := '1';
		begin
			current := data_to_be_received(i);
			if (current = '1') then
				data_DUT <= prev_value;
				wait for tari;
				prev_value := not prev_value;
			else
				data_DUT <= prev_value;
				wait for tari/2;
				data_DUT <= not prev_value;
				wait for tari/2;
			end if ;
			i := i + 1;
			if (i = size) then
				current := '1';
				data_DUT <= '0';
				wait;
			end if ;
            i2 <= i;
            current_bit <= current;
        end process;

        NIOS : process
            begin
                wait until (empty = '0');
                wait for nios_delay;
                -- read data in nios and save it

                wait for nios_delay;
                -- request new data
                rdreq <= '1';
                wait for clk_period;
                rdreq <= '0';
                wait for clk_period;
        end process;

		receiver_c : receiver port map (
            clk             => clk,
            rst             => '0',
            enable          => '1',
            data_DUT        => data_DUT,
            tari_101        => "0000000111111001",
            tari_099        => "0000000111101111",
            tari_1616       => "0000001100101000",
            tari_1584       => "0000001100011000",
            clr_err_decoder => clr_err_decoder,
            err_decoder     => err_decoder,
            rdreq           => rdreq,
            sclr            => sclr,
            empty           => empty,
            full            => full,
            data_out_fifo   => out_fifo,
            usedw           => usedw
		);

        data <= out_fifo(31 downto 6);
        mask <= out_fifo(5 downto 0);

	
end tb;
