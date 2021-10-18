library IEEE;
use IEEE.std_logic_1164.all;

entity rfid_nios is
    port (
        -- Gloabals
        fpga_clk_50        : in  std_logic;             -- clock.clk

        -- I/Os
        fpga_led_pio       : out std_logic_vector(5 downto 0)
  );
end entity rfid_nios;

architecture rtl of rfid_nios is

component NIOS_RFID is port (
  clk_clk       : in  std_logic                    := 'X'; -- clk
  reset_reset_n : in  std_logic                    := 'X'; -- reset_n
  pio_0_external_connection_export    : out std_logic_vector(5 downto 0)         -- export
);
end component NIOS_RFID;

begin

u0 : component NIOS_RFID port map (
  clk_clk       => fpga_clk_50,    --  clk.clk
  reset_reset_n => '1',            --  reset.reset_n
  pio_0_external_connection_export    => fpga_led_pio    --  leds.export
);

end rtl;