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

    entity rfid is
        generic (
            -- defining size of data in and clock speed
            data_width : natural := 8;
            tari_width : natural := 16;
            mask_width : natural := 4;
            data_size  : natural :=32
        );
        port (
            -- flags
            clk : in std_logic;
                -- fm0
            rst : in std_logic;
            enable : in std_logic;
      
            -- -- config
            tari : in std_logic_vector(tari_width-1 downto 0);
    
            -- -- data
            data_in_sender : in std_logic_vector(data_size-1 downto 0);

            data_out_receiver : in std_logic_vector(data_size-1 downto 0)
            -- -- output
            -- q : out std_logic
        );
    end entity;

    architecture arch of rfid is
        component sender
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
    
        -- component receiver
        -- generic (
            -- defining size of data in and clock speed
            -- data_width : natural := 8;
            -- tari_width : natural := 16;
            -- mask_width : natural := 4
        -- );
    
        -- port (
            -- flags
            -- clk : in std_logic;
            --     -- fm0
            -- rst_fm0 : in std_logic;
            -- enable_fm0 : in std_logic;
            --     -- fifo
            -- clear_fifo : in std_logic;
            -- fifo_write_req : in std_logic;
            -- is_fifo_full : out std_logic;
    
            -- -- config
            -- tari : in std_logic_vector(tari_width-1 downto 0);
    
            -- -- data
            -- data : in std_logic_vector(31 downto 0);
    
            -- -- output
            -- q : out std_logic
        -- );
        -- end component;

        -- component register_bank
        -- generic (
            -- defining size of data in and clock speed
            -- data_width : natural := 8;
            -- tari_width : natural := 16;
            -- mask_width : natural := 4
        -- );
    
        -- port (
            -- flags
            -- clk : in std_logic;
            --     -- fm0
            -- rst_fm0 : in std_logic;
            -- enable_fm0 : in std_logic;
            --     -- fifo
            -- clear_fifo : in std_logic;
            -- fifo_write_req : in std_logic;
            -- is_fifo_full : out std_logic;
    
            -- -- config
            -- tari : in std_logic_vector(tari_width-1 downto 0);
    
            -- -- data
            -- data : in std_logic_vector(31 downto 0);
    
            -- -- output
            -- q : out std_logic
        -- );
        -- end component;
        
         signal enable_fm0, clear_fifo, fifo_write_req, is_fifo_full, rst_fm0, q    : std_logic;

        begin
            sender_rfid : sender port map (
                clk            => clk,
                rst_fm0        => rst_fm0,
                enable_fm0     => enable_fm0,
                clear_fifo     => clear_fifo,
                fifo_write_req => fifo_write_req,
                is_fifo_full   => is_fifo_full,
                tari           => tari,
                data           => data_in_sender,
                q              => q  );
            
            -- receiver_rfid : receiver port map (
                
            -- );

            -- register_bank_rfid : register_bank port map (
                
            -- );
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
    end arch ; -- arch