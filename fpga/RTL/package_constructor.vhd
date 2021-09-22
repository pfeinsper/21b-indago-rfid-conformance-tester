
-----------------------------------------
--        Package-constructor          --
-- Projeto Final de Engenharia         --
-- Professor Orientador: Rafael Corsi  --
-- Orientador: Shephard                --
-- Alunos:                             --
-- 		Alexandre Edington             --
-- 		Bruno Domingues                --
-- 		Lucas Leal                     --
-- 		Rafael Santos                  --
-----------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity package_constructor is
	generic (
		-- defining size of data in and clock speed
		data_width : natural := 8;
		mask_width : natural := 4

	);

	port (
		-- flags
		clk : in std_logic;
		rst : in std_logic;

        data_ready : in std_logic := '0';
		data_in    : in std_logic := '0';
        eop        : in std_logic := '0';

		-- output
		write_request_out : out std_logic := '0';
		data_out       : out std_logic_vector((data_width + mask_width)-1 downto 0)
	);

end entity;

architecture arch of package_constructor is
	------------------------------
	--          values          --
	------------------------------
    signal data : std_logic_vector(data_width-1 downto 0) := (others => '1');
    signal mask : std_logic_vector(mask_width-1 downto 0) := (others => '0');
    signal package_out : std_logic_vector((data_width + mask_width)-1 downto 0);
    signal mask_integer : integer := 0;

	begin
	    LL: process ( clk, rst )
            begin
                if (rst = '1') then
                    write_request_out <= '0';
                    data <= (others => '0');
                elsif rising_edge(clk) then
                    write_request_out <= '0';
                    
                    if (eop = '1') then
                        write_request_out<= '1';
                        mask_integer <= 0;
                    elsif (data_ready = '1') then
                        mask_integer <= mask_integer + 1;
                        data <= data_in & data(data_width-1 downto 1);
                        if (mask_integer = 8) then
                            write_request_out<= '1';
                            mask_integer <= 1;
                        end if;                  
                    end if;
                end if;
        end process;

        mask <= std_logic_vector(to_unsigned(mask_integer, mask'length));
        data_out <= data & mask;
end arch ; -- arch
