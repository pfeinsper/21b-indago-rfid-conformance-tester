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

    library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_unsigned.all;
    use IEEE.numeric_std.all;
    use work.all;
    
    entity receiver is
        generic (
            -- defining size of data in and clock speed
            data_width : natural := 26;
            tari_width : natural := 16;
            mask_width : natural := 6
        );
    
        port (
            -- GENERAL
            
            -- flags
            clk    : in std_logic;
            rst    : in std_logic;
            enable : in std_logic;
 
            -- data in from DUT
            data_DUT : in std_logic;
            -----------------------------------
            -- DECODER

            -- config
            tari_101  : in std_logic_vector(tari_width-1 downto 0); -- 1% above tari
            tari_099  : in std_logic_vector(tari_width-1 downto 0); -- 1% below tari
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
            data_out_fifo : out std_logic_vector(31 downto 0);
            usedw	      : out std_logic_vector(7 downto 0)
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
                    clock		: in std_logic ;
                    data		: in std_logic_vector (31 downto 0);
                    rdreq		: in std_logic ;
                    sclr		: in std_logic ;
                    wrreq		: in std_logic ;
                    empty		: out std_logic ;
                    full		: out std_logic ;
                    q		    : out std_logic_vector (31 downto 0);
                    usedw		: out std_logic_vector (7 downto 0)
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
                data_out          : out std_logic_vector((data_width + mask_width)-1 downto 0)
            );
        
        end component;

        signal data_out_pc : std_logic_vector(31 downto 0) := (others => '0');
        
        signal write_request, data_ready, eop, data_out_decoder : std_logic := '0'; 
        
        begin
            fifo : fifo_32_32 port map (
                clock	=> clk,
                data	=> data_out_pc,
                rdreq	=> rdreq,
                sclr	=> sclr,
                wrreq	=> write_request,
                empty	=> empty,
                full	=> full,
                q		=> data_out_fifo,
                usedw	=> usedw
            );
            
            pack_const : package_constructor port map(
                clk               => clk,
                rst               => rst,
                data_ready        => data_ready,
                data_in           => data_out_decoder,
                eop               => eop,
                -- output
                write_request_out => write_request,
                data_out          => data_out_pc
            );

            decoder : FM0_decoder port map(
                clk        => clk,
                rst        => rst,
                enable     => enable,
                clr_err    => clr_err_decoder,
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