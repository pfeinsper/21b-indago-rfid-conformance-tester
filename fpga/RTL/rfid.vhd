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
            data_width : natural := 26;
            tari_width : natural := 16;
            mask_width : natural := 6;
            data_size  : natural :=32
            
        );
        port (
            
            clk : in std_logic;
            rst : in std_logic;
            
            -- Avalion Memmory Mapped Slave
            avs_address     : in  std_logic_vector(2 downto 0)  := (others => '0');
            avs_read        : in  std_logic                     := '0';
            avs_readdata    : out std_logic_vector(31 downto 0) := (others => '0');
            avs_write       : in  std_logic                     := '0';
            avs_writedata   : in  std_logic_vector(31 downto 0) := (others => '0');
      
            -- -- output
            rfid_tx : out std_logic;
            rfid_rx : in  std_logic
        );
    end entity;

    architecture arch of rfid is

        

        component FIFO_FM0
        generic (
            -- defining size of data in and clock speed
            data_width : natural := 26;
            tari_width : natural := 16;
            mask_width : natural := 6
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
        ----------------------------------------------------------------
        
        component receiver 
            generic (
                -- defining size of data in and clock speed
                data_width : natural := 11;
                tari_width : natural := 16;
                mask_width : natural := 5
            );
        
            port (
               
                -- flags
                clk : in std_logic;
                rst : in std_logic;
                enable : in std_logic;
    
                -- data in from DUT
                data_DUT : in std_logic;
                -----------------------------------
                -- DECODER
    
                -- config
                tari_101 : in std_logic_vector(tari_width-1 downto 0); -- 1% above tari
                tari_099 : in std_logic_vector(tari_width-1 downto 0); -- 1% below tari
                tari_1616 : in std_logic_vector(tari_width-1 downto 0); -- 1% above 1.6 tari
                tari_1584 : in std_logic_vector(tari_width-1 downto 0); -- 1% below 1.6 tari
                
                -- flag
                clr_err_decoder : in std_logic;
                err_decoder     : out std_logic;
                -----------------------------------
                -- FIFO
    
                -- flags
                rdreq : in std_logic;
                sclr  : in std_logic;
    
                empty : out std_logic;
                full  : out std_logic;
                
                -- data output
                data_out_fifo  : out std_logic_vector(31 downto 0);
                usedw	       : out std_logic_vector(7 downto 0)
            );
        
        end component;
        ----------------------------------------------------------------
                    
        signal reg_settings : std_logic_vector(31 downto 0);
		signal reg_status : std_logic_vector(31 downto 0);
        signal reg_send_tari, reg_send_tari_101, reg_send_tari_099, reg_send_tari_1616, reg_send_tari_1584 : std_logic_vector(15 downto 0);
        signal fifo_data_in : std_logic_vector(data_size-1 downto 0);
        signal fifo_write_req, receiver_err_decoder: std_logic := '0';
        signal receiver_data_out : std_logic_vector(31 downto 0);
        signal receiver_usedw : std_logic_vector(7 downto 0);

        signal pin_tx, pin_rx : std_logic := '0';
        signal loopback   : std_logic := '0';
        begin      

        -- enable loopback mode
        pin_rx <= rfid_rx when loopback = '0' else
                  pin_tx;
        rfid_tx <= pin_tx;
            
            process(clk)
            begin
                if (rising_edge(clk)) then
                    if (rst = '1') then
                        reg_settings    <= (others => '0');
                        fifo_write_req  <= '0';
                    else
                        fifo_write_req <= '0';

                        if (avs_write = '1') then
                            case avs_address is
                            when "000" => --0
                                reg_settings  <= avs_writedata;
                                loopback <= reg_settings(4);
                            when "001" => -- 1
                                reg_send_tari <=  avs_writedata(15 downto 0);
                            when "010" => -- 2
                                fifo_data_in <= avs_writedata(data_size-1 downto 0);
                                fifo_write_req <= '1';
                            when "011" => -- 3
                                reg_send_tari_101 <=  avs_writedata(15 downto 0);
                            when "100" => -- 4
                                reg_send_tari_099 <=  avs_writedata(15 downto 0);
                            when "101" => -- 5
                                reg_send_tari_1616 <=  avs_writedata(15 downto 0);
                            when "110" => -- 6
                                reg_send_tari_1584 <=  avs_writedata(15 downto 0);
                        
                            when others => null;
                            end case;
                        
                        elsif(avs_read = '1') then
                            case avs_address is
                            when "000" => -- 0
                                avs_readdata <= reg_settings;
                            when "001" => -- 1
                                avs_readdata(15 downto 0) <= reg_send_tari;
                            when "011" => -- 3
                                avs_readdata <= reg_status;
                            when "100" => -- 4
                                avs_readdata <= receiver_data_out;
                            --when "101" =>
                               -- avs_readdata(1 downto 0) <= receiver_err_decoder;
                            when "110" => -- 6
                                avs_readdata(7 downto 0) <= receiver_usedw;    
                            when "111" => -- 7
                                avs_readdata <= x"FF0055FF";
                            when others => null;
                            end case;
                        end if;
                    end if;
                end if;
            end process;

        -- reg_settings is available from 0 to 10 for sender
        fm0: FIFO_FM0 port map (
            clk            => clk,
            rst_fm0        => reg_settings(0),
            enable_fm0     => reg_settings(1), 
            clear_fifo     => reg_settings(2), 
            fifo_write_req => fifo_write_req,
            data           => fifo_data_in,
            is_fifo_full   => reg_status(0),
            tari           => reg_send_tari,
            q              => pin_tx );

        -- reg_settings is available from 11 to 31 for receiver
        rfid_receiver: receiver port map(
            -- flags
            clk      => clk, --done
            rst      => reg_settings(11), -- done
            enable   => reg_settings(12), -- done
            -- data in from DUT 
            data_DUT => pin_rx, -- EDITAR PARA A ENTRADA DA TAG
            -----------------------------------
            -- DECODER
            -- config
            tari_101  => reg_send_tari_101,-- 1% above tari done
            tari_099  => reg_send_tari_099,-- 1% below tari done
            tari_1616 => reg_send_tari_1616,-- 1% above 1.6 tari done 
            tari_1584 => reg_send_tari_1584,-- 1% below 1.6 tari done
            -- flag
            clr_err_decoder => reg_status(10),
            err_decoder     => receiver_err_decoder,
            -----------------------------------
            -- FIFO
            -- flags
            rdreq => reg_status(11), -- done
            sclr  => reg_status(12), -- done
            empty => reg_status(13), -- done
            full  => reg_status(14), -- done
            -- data output
            data_out_fifo => receiver_data_out,
            usedw         => receiver_usedw
        );
    end arch ;   