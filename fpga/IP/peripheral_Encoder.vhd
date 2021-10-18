library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.all;

entity peripheral_Encoder is
    generic (
        clk_f      : natural := 50e6; -- Hz
		  data_width : natural := 8;
		  tari_width : natural := 16;
		  mask_width : natural := 4
    );
    port (
	   clk : in std_logic;
		rst : in std_logic;
		enable : in std_logic;
		-- config
		tari : in std_logic_vector(tari_width-1 downto 0);

		-- fifo data
		is_fifo_empty    : in std_logic;
		data_in          : in std_logic_vector((data_width + mask_width)-1 downto 0); -- format expected : ddddddddmmmm
		request_new_data : out std_logic;

		-- output
		data_out : out std_logic:= '0'
    );
	 
end entity peripheral_Encoder;

architecture rtl of peripheral_Encoder is
begin

  process(clk)
  begin
    if (reset = '1') then
      LEDs <= (others => '0');
    elsif(rising_edge(clk)) then
        if(avs_address = "0001") then                  -- REG_DATA
            if(avs_write = '1') then
              LEDs <= avs_writedata(LEN - 1 downto 0);
            end if;
        end if;
    end if;
  end process;

end rtl;