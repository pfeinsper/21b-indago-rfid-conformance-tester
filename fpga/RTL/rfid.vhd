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
--! \rfid.vhd
--!
--!
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.all;
--! \brief Project top level, instantiates the sender, receiver and Avalon Interface.
--!
--! This component encopasses the whole project. Instantiating the Avalon Interface allows for communication between hardware and software, or, in other words, the NIOS II and the IP RFID.
--!
--!
--!
entity rfid is
    generic (
        -- defining size of data in and clock speed     
        data_width : natural := 26; --! Size of the data inside a packet sent between components
        tari_width : natural := 16; --! Bits reserved for the TARI time parameter
        mask_width : natural := 6;  --! Size of the mask that indicates how many bits of the packet are in use
        data_size  : natural :=32   --! Size of the packets including the mask
        
    );
    port (
        
        clk : in std_logic; --! Clock input
        rst : in std_logic; --! Reset high
        
        -- Avalion Memmory Mapped Slave
        avs_address     : in  std_logic_vector(3 downto 0)  := (others => '0'); --! Points to the specific address in the memory bank
        avs_read        : in  std_logic                     := '0';             --! Indicates a read request if high
        avs_readdata    : out std_logic_vector(31 downto 0) := (others => '0'); --! Data being read from the avs_address
        avs_write       : in  std_logic                     := '0';             --! Indicates a write request if high
        avs_writedata   : in  std_logic_vector(31 downto 0) := (others => '0'); --! Data being written to the avs_address
    
        -- -- output
        rfid_tx : out std_logic; --! Reader output
        rfid_rx : in  std_logic  --! Reader input
    );
end entity;

architecture arch of rfid is

    

    component sender
    generic (
            -- defining size of data in and clock speed
            data_width       : natural := 26;
            tari_width       : natural := 16;
            pw_width         : natural := 16;
            delimiter_width  : natural := 16;
            RTcal_width      : natural := 16;
            TRcal_width      : natural := 16;
            mask_width       : natural := 6
        );
    
        port (
            -- flags
            clk                  : in std_logic;
            clr_finished_sending : in std_logic;
            enable               : in std_logic;
            rst                  : in std_logic;

            finished_sending : out std_logic;

            -- fifo
            clear_fifo     : in std_logic;
            fifo_write_req : in std_logic;
            is_fifo_full   : out std_logic;
            usedw          : out std_logic_vector(7 downto 0);

            -- controller
            has_gen          : in std_logic;
            start_controller : in std_logic;

            -- generator
            is_preamble : in std_logic;
    
            -- config
            tari      : in std_logic_vector(tari_width-1 downto 0);
            pw        : in std_logic_vector(pw_width-1 downto 0);
            delimiter : in std_logic_vector(delimiter_width-1 downto 0);
            RTcal     : in std_logic_vector(RTcal_width-1 downto 0);
            TRcal     : in std_logic_vector(TRcal_width-1 downto 0);           
    
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
            data_width : natural := 26;
            tari_width : natural := 16;
            mask_width : natural := 6
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
    
        -- reg
    signal reg_settings : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_status   : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_send_tari, reg_send_tari_101, reg_send_tari_099, reg_send_tari_1616, reg_send_tari_1584,reg_send_pw ,reg_send_delimiter, reg_send_RTcal, reg_send_TRcal : std_logic_vector(15 downto 0);
        
        -- fifo
    signal fifo_data_in : std_logic_vector(data_size-1 downto 0);
    signal fifo_write_req, fifo_write : std_logic := '0';
        
        -- receiver
    signal receiver_data_out       : std_logic_vector(31 downto 0);
    signal reg_read_usedw_receiver : std_logic_vector(7 downto 0);

        -- sender
    signal reg_read_usedw_sender : std_logic_vector(7 downto 0);


        -- other signals
    signal pin_tx, pin_rx : std_logic := '0';
        
    begin      

    -- rfid_tx
    -- rfid_rx w
    -- enable loopback mode
    pin_rx <= rfid_rx when reg_settings(8) = '0' else pin_tx;
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
                        when "0000" => --0
                            reg_settings  <= avs_writedata;
                        when "0001" => -- 1
                            reg_send_tari <=  avs_writedata(15 downto 0);
                        when "0010" => -- 2
                            fifo_data_in <= avs_writedata(data_size-1 downto 0);
                            fifo_write_req <= '1';
                        when "0011" => -- 3
                            reg_send_tari_101 <=  avs_writedata(15 downto 0);
                        when "0100" => -- 4
                            reg_send_tari_099 <=  avs_writedata(15 downto 0);
                        when "0101" => -- 5
                            reg_send_tari_1616 <=  avs_writedata(15 downto 0);
                        when "0110" => -- 6
                            reg_send_tari_1584 <=  avs_writedata(15 downto 0);
                        when "0111" => -- 7
                            reg_send_pw <= avs_writedata(15 downto 0);
                        when "1000" => -- 8
                            reg_send_delimiter <= avs_writedata(15 downto 0);
                        when "1001" => -- 9
                            reg_send_RTcal <= avs_writedata(15 downto 0);  
                        when "1010" => -- 10
                            reg_send_TRcal <= avs_writedata(15 downto 0);
                        when others => null;
                        end case;
                    
                    elsif(avs_read = '1') then
                        case avs_address is
                        when "0000" => -- 0
                            avs_readdata <= reg_settings;
                        when "0001" => -- 1
                            avs_readdata(15 downto 0) <= reg_send_tari;
                        when "0011" => -- 3
                            avs_readdata <= reg_status;
                        when "0100" => -- 4
                            avs_readdata <= receiver_data_out;
                        when "0101" => -- 5
                            avs_readdata(7 downto 0) <= reg_read_usedw_sender;
                        when "0110" => -- 6
                            avs_readdata(7 downto 0) <= reg_read_usedw_receiver;    
                        when "0111" => -- 7
                            avs_readdata <= x"FF0055FF";
                        when others => null;
                        end case;
                    end if;
                end if;
            end if;
        end process;
		  
	 aa : process( clk, fifo_write_req )
        variable already_seted : std_logic := '0';
        begin
            if (rising_edge(clk)) then

                fifo_write <= '0';

                if (fifo_write_req = '1' and already_seted = '0') then
                    fifo_write <= '1';
						  already_seted := '1';
					 elsif (fifo_write_req = '0') then
						  already_seted := '0';
					 end if;
            end if ;
        end process ; -- aa

    rfid_sender: sender port map(
        clk                   => clk,
        clr_finished_sending  => reg_settings(10), -- escrita quando terminou o pacote pulsar esse fio
        enable                => reg_settings(1),
        rst                   => reg_settings(0),
        finished_sending      => reg_status(3), -- leitura termino de envio de pacote
        clear_fifo            => reg_settings(2),
        fifo_write_req        => fifo_write,
        is_fifo_full          => reg_status(0),  
        usedw                 => reg_read_usedw_sender,
        has_gen               => reg_settings(5), -- nios escrita - preamble/framesync 1  0 se n vai usar
        start_controller      => reg_settings(6), -- nios escrita enable pulso to send package
        is_preamble           => reg_settings(7), -- nios escrita 1 preamble 0 fs
        tari                  => reg_send_tari,
        pw                    => reg_send_pw, -- ver desenhos
        delimiter             => reg_send_delimiter, -- e testbench
        RTcal                 => reg_send_RTcal, -- 
        TRcal                 => reg_send_TRcal, -- 
        data                  => fifo_data_in,
        q                     => pin_tx
    );


    -- reg_settings is available from 11 to 31 for receiver
    rfid_receiver: receiver port map(
        -- flags
        clk      => clk, --done
        rst      => reg_settings(11), -- done
        enable   => reg_settings(4), -- done
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
        err_decoder     => reg_status(9),
        -----------------------------------
        -- FIFO
        -- flags
        rdreq => reg_settings(12), -- done
        sclr  => reg_status(12), -- done
        empty => reg_status(13), -- done
        full  => reg_status(14), -- done
        -- data output
        data_out_fifo => receiver_data_out,
        usedw         => reg_read_usedw_receiver
    );

                        

end arch ;   