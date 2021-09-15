	-----------------------------------------
	--               Sender                --
	-- Projeto Final de Engenharia         --
	-- Professor Orientador: Rafael Corsi  --
	-- Orientador: Shephard                --
	-- Alunos:                             --
	-- 		Alexandre Edington             --
	-- 		Bruno Domingues                --
	-- 		Lucas Leal                     --
	-- 		Rafael Santos                  --
	-----------------------------------------

    library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_unsigned.all;
    use IEEE.numeric_std.all;
    use work.all;
    
    entity sender is
        generic (
            -- defining size of data in and clock speed
            data_width : natural := 8;
            tari_width : natural := 16;
            mask_width : natural := 4
        );
    
        port (
            -- flags
            clk : in std_logic;
                -- fm0
            rst_fm0 : in std_logic;
            enable_fm0 : in std_logic;
                -- fifo
            clear_fifo : in std_logic;
            fifo_write_req : in std_logic;
            is_fifo_full : out std_logic;
    
            -- config
            tari : in std_logic_vector(tari_width-1 downto 0);
    
            -- data
            data : in std_logic_vector(31 downto 0);
    
            -- output
            q : out std_logic
        );
    
    end entity;
    
    
    architecture arch of sender is
        component FIFO_FM0
            generic (
                -- defining size of data in and clock speed
                data_width : natural := 8;
                tari_width : natural := 16;
                mask_width : natural := 4
            );
        
            port (
                -- flags
                clk : in std_logic;
                    -- fm0
                rst_fm0 : in std_logic;
                enable_fm0 : in std_logic;
                    -- fifo
                clear_fifo : in std_logic;
                fifo_write_req : in std_logic;
                is_fifo_full : out std_logic;
        
                -- config
                tari : in std_logic_vector(tari_width-1 downto 0);
        
                -- data
                data : in std_logic_vector(31 downto 0);
        
                -- output
                q : out std_logic
            );
        end component;
    
        begin
            fifo_fm0_c : fifo_fm0 port map (
                clk            => clk,
                rst_fm0        => rst_fm0,
                enable_fm0     => enable_fm0,
                clear_fifo     => clear_fifo,
                fifo_write_req => fifo_write_req,
                is_fifo_full   => is_fifo_full,
                tari           => tari,
                data           => data,
                q              => q  );
    
    end arch ; -- arch