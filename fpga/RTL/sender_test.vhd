library ieee;
use ieee.std_logic_1164.all;

entity sender_test is
	port (
		fpga_clk_50 : in std_logic;
		pin_tx : out std_logic
	);
end entity sender_test;

architecture tb of sender_test is
	
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
	 
	constant data : std_logic_vector(25 downto 0) := (others => '1');
   signal data_in : std_logic_vector(31 downto 0) := (others => '1');
	constant mask : std_logic_vector(5 downto 0) := "011010";
	
	begin
	
		sender_c : sender port map (
			   clk                  => fpga_clk_50,
            clr_finished_sending => '0', -- escrita quando terminou o pacote pulsar esse fio
            enable               => '1',
            rst                  => '0',
            finished_sending     => open,
            clear_fifo           => '0',
            fifo_write_req       => '1',
            is_fifo_full         => open,
            usedw                => open,
            has_gen              => '0',
            start_controller     => '1',
            is_preamble          => '0',
            tari                 => "0000000111110100",
            pw                   => "0000000011111010",
            delimiter            => "0000001001110001",
            RTcal                => "0000010101000110",
            TRcal                => "0000010101000110",
            data                 => data_in,
            q                    => pin_tx
		);

		data_in <= data & mask;

end tb;
