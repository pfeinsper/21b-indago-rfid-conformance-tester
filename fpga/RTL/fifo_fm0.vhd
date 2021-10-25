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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FIFO_FM0 IS
    GENERIC (
        -- defining size of data in and clock speed
        data_width : NATURAL := 26;
        tari_width : NATURAL := 16;
        mask_width : NATURAL := 6
    );

    PORT (
        -- flags
        clk : IN STD_LOGIC;

        -- fm0
        rst_fm0 : IN STD_LOGIC;
        enable_fm0 : IN STD_LOGIC;
        encoder_ended : OUT STD_LOGIC;

        -- fifo
        clear_fifo : IN STD_LOGIC;
        fifo_write_req : IN STD_LOGIC;
        is_fifo_full : OUT STD_LOGIC;

        -- config
        tari : IN STD_LOGIC_VECTOR(tari_width - 1 DOWNTO 0);

        -- data
        data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- output
        q : OUT STD_LOGIC
    );

END ENTITY;
ARCHITECTURE arch OF FIFO_FM0 IS
    COMPONENT fm0_encoder
        GENERIC (
            -- defining size of data in and clock speed
            data_width : NATURAL := data_width;
            tari_width : NATURAL := tari_width;
            mask_width : NATURAL := mask_width
        );

        PORT (
            -- flags 
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            finished_sending : OUT STD_LOGIC;

            -- config
            tari : IN STD_LOGIC_VECTOR(tari_width - 1 DOWNTO 0);

            -- fifo data
            is_fifo_empty : IN STD_LOGIC;
            data_in : IN STD_LOGIC_VECTOR((data_width + mask_width) - 1 DOWNTO 0); -- format expected : ddddddddmmmm
            request_new_data : OUT STD_LOGIC;

            -- output
            data_out : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT fifo_32_32 IS
        PORT (
            clock : IN STD_LOGIC;
            data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            rdreq : IN STD_LOGIC;
            sclr : IN STD_LOGIC;
            wrreq : IN STD_LOGIC;
            empty : OUT STD_LOGIC;
            full : OUT STD_LOGIC;
            q : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
            -- usedw		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL fifo_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL is_fifo_empty, request_new_data, data_out, wrfull : STD_LOGIC := '0';
    -- signal usedw : std_logic_vector(7 downto 0);

BEGIN
    fifo : fifo_32_32 PORT MAP(
        sclr => clear_fifo,
        data => data,
        clock => clk,
        wrreq => fifo_write_req,
        rdreq => request_new_data,
        q => fifo_out,
        empty => is_fifo_empty,
        full => wrfull
        -- usedw   => usedw  
    );

    fm0 : fm0_encoder PORT MAP(
        clk => clk,
        rst => rst_fm0,
        finished_sending => encoder_ended,
        enable => enable_fm0,
        tari => tari,
        data_out => data_out,
        is_fifo_empty => is_fifo_empty,
        data_in => fifo_out((data_width + mask_width) - 1 DOWNTO 0),
        request_new_data => request_new_data);

    q <= data_out;
    is_fifo_full <= wrfull;

END arch; -- arch