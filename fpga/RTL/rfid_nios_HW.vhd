LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY rfid_nios_HW IS
    PORT (
        -- Gloabals
        fpga_clk_50 : IN STD_LOGIC; -- clock.clk

        -- I/Os
        pin_rx : IN STD_LOGIC;
        pin_tx : OUT STD_LOGIC
    );
END ENTITY rfid_nios_HW;

ARCHITECTURE hw OF rfid_nios_HW IS

    COMPONENT RFID_NIOS IS
        PORT (
            clk_clk : IN STD_LOGIC := 'X'; -- clk
            pins_rx : IN STD_LOGIC := 'X'; -- rx
            pins_tx : OUT STD_LOGIC; -- tx
            reset_reset_n : IN STD_LOGIC := 'X' -- reset_n
        );
    END COMPONENT RFID_NIOS;

BEGIN

    u0 : COMPONENT RFID_NIOS
        PORT MAP(
            clk_clk => fpga_clk_50, --  clk.clk
            pins_rx => pin_rx, --  pins.rx
            pins_tx => pin_tx, --  pins.tx
            reset_reset_n => '1' --  reset.reset_n
        );

    END hw;