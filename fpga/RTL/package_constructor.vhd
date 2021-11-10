
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
		data_width : natural := 26;
		mask_width : natural := 6
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
    signal data : std_logic_vector(data_width-1 downto 0) := (others => '0');
    signal mask : std_logic_vector(mask_width-1 downto 0) := (others => '0');
    -- signal mask_integer : integer range 0 to data_width + mask_width + 1 := 0;
    signal send_void_package, rst_mask_integer : boolean := false;
    

	begin
	    LL: process ( clk, rst )
        variable mask_integer : integer range 0 to data_width + mask_width + 1 := 0;
        begin
            if (rst = '1') then
                write_request_out <= '0';
                data              <= (others => '0');
                mask              <= (others => '0');
            elsif rising_edge(clk) then
                write_request_out <= '0';
                mask_integer := to_integer(unsigned(mask));
                if (rst_mask_integer) then
                    -- mask_integer <= 0;
                    mask <= (others => '0');
                    rst_mask_integer <= false;

                elsif (send_void_package) then
                    if (mask_integer = 0 and unsigned(data) = 0) then
                        write_request_out <= '1';                        
                        send_void_package <= false;
                    end if ;
                    mask <= (others => '0');
                    data <= (others => '0');

                elsif (eop = '1') then
                    write_request_out <= '1';
                    mask <= (others => '0');
                    send_void_package <= true;

                elsif (data_ready = '1') then
                    mask <= std_logic_vector(to_unsigned(mask_integer+1, mask_width));
                    data(mask_integer) <= data_in;
                    -- data <= data(data_width-2 downto 0) & data_in;
                    if (mask_integer = data_width) then
                        write_request_out <= '1';
                        rst_mask_integer <= true;
                    end if;
                end if;
                end if;
                end process;
                
        -- mask <= std_logic_vector(to_unsigned(mask_integer-1, mask_width));
        data_out <= data & mask;
end arch ; -- arch
