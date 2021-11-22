
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
		data_out       : out std_logic_vector((data_width + mask_width)-1 downto 0);
        clr_eop        : out std_logic := '0'
	);

end entity;

architecture arch of package_constructor is
	------------------------------
	--          values          --
	------------------------------
    signal data : std_logic_vector(data_width-1 downto 0) := (others => '0');
    signal mask : std_logic_vector(mask_width-1 downto 0) := (others => '0');
    signal mask_integer : integer range 0 to data_width + mask_width + 1 := 0;
    -- signal send_void_package, rst_mask_integer : boolean := false;
    

    type state_type_contructor is (c_wait, c_send_package, c_new_bit, c_inc_mask, c_clear, c_send_void_package, c_check_mask_overflow, c_check_eop);
	signal state_contructor    : state_type_contructor := c_wait;

	begin

        contructor : process( clk, rst, data_ready, eop )
        -- variable mask_integer : integer range 0 to data_width + mask_width + 1 := 0;
        begin
            if (rst = '1') then
                state_contructor <= c_wait;
                mask_integer <= 0;
                data <= (others => '0');

            elsif (rising_edge(clk)) then
                case state_contructor is
                    when c_wait =>
                        clr_eop <= '0';
                        write_request_out <= '0';
                        if (data_ready = '1') then
                            state_contructor <= c_new_bit;
                        elsif (eop = '1') then
                            state_contructor <= c_check_eop;
                        end if;
                        
                    when c_new_bit =>
                        data(mask_integer) <= data_in;
                        state_contructor <= c_inc_mask;
                        
                    when c_inc_mask =>
                        mask_integer <= mask_integer + 1;
                        state_contructor <= c_check_mask_overflow;
                        
                    when c_check_mask_overflow =>
                        if (mask_integer = data_width) then
                            state_contructor <= c_send_package;
                            write_request_out <= '1';
                        else
                            state_contructor <= c_check_eop;
                        end if;

                    when c_send_package =>
                        write_request_out <= '0';                        
                        state_contructor <= c_clear;

                    when c_clear =>
                        -- write_request_out <= '0';
                        mask_integer <= 0;
                        data <= (others => '0');
                        state_contructor <= c_wait;
                    
                    when c_check_eop =>
                        if (eop = '1') then
                            if (mask_integer = 0) then
                                state_contructor <= c_send_void_package;
                            else
                                state_contructor <= c_send_package;
                                write_request_out <= '1';
                            end if;
                        else
                            state_contructor <= c_wait;
                        end if;
                    
                    when c_send_void_package =>
                        clr_eop <= '1';
                        data <= (others => '0');
                        mask_integer <= 0;
                        write_request_out <= '1';
                        state_contructor <= c_wait;
                    
                    when others =>
                        state_contructor <= c_wait;
                end case;
            end if;
            
        end process ; -- contructor

        mask <= std_logic_vector(to_unsigned(mask_integer, mask_width));
        data_out <= data & mask;
        
end arch ; -- arch
