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

            -- Avalion Memmory Mapped Slave
            avs_address     : in  std_logic_vector(2 downto 0)  := (others => '0');
            avs_read        : in  std_logic                     := '0';
            avs_readdata    : out std_logic_vector(31 downto 0) := (others => '0');
            avs_write       : in  std_logic                     := '0';
            avs_writedata   : in  std_logic_vector(31 downto 0) := (others => '0');
      
           
            -- -- data
            data_in_sender : in std_logic_vector(data_size-1 downto 0);

            data_out_receiver : out std_logic_vector(data_size-1 downto 0)

            
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
        
        -- signal enable_fm0, clear_fifo, fifo_write_req, is_fifo_full, rst_fm0, q    : std_logic;
        signal reg_settings : std_logic_vector(31 downto 0);
        signal reg_send_tari : std_logic_vector(15 downto 0);

        begin
            
            
            -- receiver_rfid : receiver port map (
                
            -- );

            -- signal enable_fm0, clear_fifo, fifo_write_req, is_fifo_full, rst_fm0, q    : std_logic;
            process(clk)
            begin
              if (rising_edge(clk)) then
                if (rst = '1') then
                    reg_settings <= (others => '0');
                else
                  if (avs_write = '1') then
                      case avs_address is
                        when "000" => 
                        reg_settings  <= avs_writedata;
                        when "001" => 
                        reg_send_tari <=  avs_writedata(15 downto 0);
                        
            end process;
    
            sender_rfid : sender port map (
        clk            => clk,
        rst_fm0        => reg_settings(0), -- rst_fm0,
        enable_fm0     => reg_settings(1), -- enable_fm0,
        clear_fifo     => reg_settings(2), -- clear_fifo,
        fifo_write_req => reg_settings(3),-- fifo_write_req,
        is_fifo_full   => reg_settings(4),-- is_fifo_full,
        tari           =>  reg_send_tari,
        data           =>  data_in_sender,
        q              =>  reg_settings(5) );-- q  );

    end arch ; -- arch