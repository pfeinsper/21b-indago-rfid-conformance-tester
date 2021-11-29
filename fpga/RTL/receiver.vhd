	-----------------------------------------
	--              Receiver               --
	-- Projeto Final de Engenharia         --
	-- Professor Orientador: Rafael Corsi  --
	-- Orientador: Shephard                --
	-- Alunos:                             --
	-- 		Alexandre Edington             --
	-- 		Bruno Domingues                --
	-- 		Lucas Leal                     --
	-- 		Rafael Santos                  --
	-----------------------------------------
    --! \receiver.vhd
    --!
    --!
    library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_unsigned.all;
    use IEEE.numeric_std.all;
    use work.all;
    --! \brief https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/RTL/receiver.vhd
    --!
    --! The data is received bit by bit, and thus needs to be first gouped in pairs, in order to be decoded, since the TAG also uses the FM0 encoding.
    --! After this, the decoded bits are stored in a FIFO until the packet is complete and ready to be sent back to the NIOS II.
    --! If the command ends before the packet is completed, a mask is sent to denote which bits of the packet are actually data.
    --!
    entity receiver is
        generic (
            -- defining size of data in and clock speed
            data_width : natural := 26; --! Size of the data inside a packet sent between components
            tari_width : natural := 16; --! Bits reserved for the TARI time parameter
            mask_width : natural := 6  --! Size of the mask that indicates how many bits of the packet are in use
        );
    
        port (
            -- GENERAL
            
            -- flags
            clk : in std_logic; --! Clock input
            rst : in std_logic; --! Reset high
            enable : in std_logic; --! Enable high
 
            -- data in from DUT
            data_DUT : in std_logic; --! Encoded data received from the TAG
            -----------------------------------
            -- DECODER

            -- config
            tari_101  : in std_logic_vector(tari_width-1 downto 0); --! 1% above tari limit
            tari_099  : in std_logic_vector(tari_width-1 downto 0); --! 1% below tari limit
            tari_1616 : in std_logic_vector(tari_width-1 downto 0); --! 1% above 1.6 tari limit
            tari_1584 : in std_logic_vector(tari_width-1 downto 0); --! 1% below 1.6 tari limit
            
            -- flag
            clr_err_decoder : in std_logic;  --! Flag clears decoder error
            err_decoder     : out std_logic; --! Flag decoder error indicator
            -----------------------------------
            -- FIFO

            -- flags
            rdreq : in std_logic; --! Flag FIFO read request
            sclr  : in std_logic; --! Flag FIFO clear

            empty : out std_logic; --! Flag that indicates if the FIFO has no more data stored
            full  : out std_logic; --! Flag that indicates if the FIFO has run out of space
            
            -- data output
            data_out_fifo : out std_logic_vector(31 downto 0); --! Packet sent from the FIFO to the Avalon Interface
            usedw	      : out std_logic_vector(7 downto 0) --! Number of valid packets in the FIFO
        );
    
    end entity;
    
    
    architecture arch of receiver is
        component FM0_decoder is
            generic (
                -- defining size of data in and clock speed
                tari_width : natural := 16
            );
        
            port (
                -- flags
                clk     : in std_logic;
                rst     : in std_logic;
                enable  : in std_logic;
                clr_err : in std_logic;
                clr_eop : in std_logic;
        
                err : out std_logic := '0';
                eop : out std_logic := '0';
        
                -- config
                tari_101  : in std_logic_vector(tari_width-1 downto 0); -- 1% above tari
                tari_099  : in std_logic_vector(tari_width-1 downto 0); -- 1% below tari
                tari_1616 : in std_logic_vector(tari_width-1 downto 0); -- 1% above 1.6 tari
                tari_1584 : in std_logic_vector(tari_width-1 downto 0); -- 1% below 1.6 tari
        
                data_in : in std_logic := '0';
        
                -- output
                data_ready : out std_logic := '0';
                data_out   : out std_logic := '0'
            );
        
        end component;

        component fifo_32_32 IS
            port
                (
                    clock : in std_logic;
                    data  : in std_logic_vector (31 downto 0);
                    rdreq : in std_logic;
                    sclr  : in std_logic;
                    wrreq : in std_logic;
                    empty : out std_logic;
                    full  : out std_logic;
                    q     : out std_logic_vector (31 downto 0);
                    usedw : out std_logic_vector (7 downto 0)
                );
        end component;

        component package_constructor is
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
                data_out          : out std_logic_vector((data_width + mask_width)-1 downto 0);
                clr_eop           : out std_logic := '0'
            );
        
        end component;

        signal data_out_pc : std_logic_vector(31 downto 0) := (others => '0');
        
        signal write_request, data_ready, eop, data_out_decoder, rdreq_pulse, clr_eop : std_logic := '0'; 
        
        begin
            pulse_generator : process( rst, clk, rdreq )
                variable already_read : boolean := false;
                begin
                    if rst = '1' then
                        already_read := false;
                        rdreq_pulse <= '0';

                    elsif (rising_edge(clk)) then
                        if (rdreq = '1' and not already_read) then
                            already_read := true;
                            rdreq_pulse <= '1';
                        else
                            rdreq_pulse <= '0';
                        end if;
                        if (rdreq = '0') then
                            already_read := false;
                        end if;         
                    end if;
                
            end process ; -- pulse_generator


            fifo : fifo_32_32 port map (
                sclr    => sclr,
                data    => data_out_pc,
                clock   => clk,
                wrreq   => write_request,
                rdreq   => rdreq_pulse,
                q       => data_out_fifo,
                empty   => empty,
                full    => full,
                usedw   => usedw
            );
            
            pack_const : package_constructor port map(
                clk               => clk,
                rst               => rst,
                data_ready        => data_ready,
                data_in           => data_out_decoder,
                eop               => eop,
                -- output
                write_request_out => write_request,
                data_out          => data_out_pc,
                clr_eop           => clr_eop
            );

            decoder : FM0_decoder port map(
                clk        => clk,
                rst        => rst,
                enable     => enable,
                clr_err    => clr_err_decoder,
                clr_eop    => clr_eop,
                err        => err_decoder,
                eop        => eop,
                -- config
                tari_101   => tari_101,
                tari_099   => tari_099,
                tari_1616  => tari_1616,
                tari_1584  => tari_1584,
                data_in    => data_DUT,
                data_ready => data_ready,
                data_out   => data_out_decoder
            );
    
    end arch ; -- arch