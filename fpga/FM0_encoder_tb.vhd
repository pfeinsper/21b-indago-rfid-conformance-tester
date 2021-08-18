library IEEE;
use IEEE.std_logic_1164.all;


entity FM0_encoder_tb is

end entity FM0_encoder_tb;


architecture tb of FM0_encoder_tb is

	component FM0_encoder port (
		clk  : in  std_logic;
		updating_data_in   : in std_logic;
		tari : in std_logic_vector(11 downto 0); -- 50*2000
		data_in  : in std_logic_vector(11 downto 0);
		
		encoded_data_out : out std_logic_vector(15 downto 0);
		reduced_clk_out : out std_logic;
		);
	end component;

	signal clk : std_logic;
	constant CLK_PERIOD : time := 20 ns;
	signal pwm : std_logic;

	begin

	clk_process :process

		begin
			clk <= '0';
			wait for clk_period/2;  --for 0.5 ns signal is '0'.
			clk <= '1';
			wait for clk_period/2;  --for next 0.5 ns signal is '1'.

		end process;

		u1 : servo port map (clk,
									'1',
									"00000010111011100",
									pwm);
									
end tb;
