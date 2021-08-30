	-----------------------------------------
	--              FIFO FM0               --
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

entity FIFO_FM0 is
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


architecture arch of FIFO_FM0 is
    component fm0_encoder
        generic (
                -- defining size of data in and clock speed
                data_width : natural := data_width;
                tari_width : natural := tari_width;
                mask_width : natural := mask_width
        );
        port (
            -- flags 
            clk : in std_logic;
            rst : in std_logic;
            enable : in std_logic;

            -- config
            tari : in std_logic_vector(tari_width-1 downto 0);

            -- fifo data
            is_fifo_empty    : in std_logic;
            data_in          : in std_logic_vector((data_width + mask_width)-1 downto 0); -- format expected : ddddddddmmmm
            request_new_data : out std_logic;

            -- output
            data_out : out std_logic
        );
    end component;

    component fifo_32
        port
        (
            aclr		: in std_logic  := '0';
            data		: in std_logic_vector (31 downto 0);
            rdclk		: in std_logic ;
            rdreq		: in std_logic ;
            wrclk		: in std_logic ;
            wrreq		: in std_logic ;
            
            q		    : out std_logic_vector (15 downto 0);
            rdempty		: out std_logic ;
            wrfull		: out std_logic 
        );
    end component;

    signal fifo_out : std_logic_vector(15 downto 0);
    signal is_fifo_empty, request_new_data, data_out, wrfull : std_logic := '0';

    begin
        fifo : fifo_32 port map (
			aclr    => clear_fifo,
			data    => data,
			rdclk   => clk,
			wrclk   => clk,
			wrreq   => fifo_write_req,
			rdreq   => request_new_data,
            q       => fifo_out,
            rdempty => is_fifo_empty,
            wrfull  => wrfull  );

        fm0 : fm0_encoder port map (
            clk => clk,
            rst => rst_fm0,
            enable => enable_fm0,
            tari => tari,
            data_out => data_out,
            is_fifo_empty => is_fifo_empty,
            data_in => fifo_out((data_width+mask_width)-1 downto 0),
            request_new_data => request_new_data  );

        q <= data_out;
        is_fifo_full <= wrfull;

end arch ; -- arch