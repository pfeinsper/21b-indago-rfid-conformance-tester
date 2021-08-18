library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flipflop is
    port ( d   : in std_logic;
           clk : in std_logic;
           rst : in std_logic;
           q   : out std_logic; 
        );
end flipflop;

architecture arch of flipflop is

    begin
        process (d, clk, rst)
            begin

                if (rst = '1') then
                    q <= '0';
                elsif (rising_edge(clk)) then
                    q <= d;
                end if;
        end process;
end arch;