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

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;
USE work.ALL;

ENTITY rfid IS
    GENERIC (
        -- defining size of data in and clock speed     
        data_width : NATURAL := 26;
        tari_width : NATURAL := 16;
        mask_width : NATURAL := 6;
        data_size : NATURAL := 32

    );
    PORT (
        -- globals
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;

        -- Avalon Memmory Mapped Slave
        avs_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
        avs_read : IN STD_LOGIC := '0';
        avs_readdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        avs_write : IN STD_LOGIC := '0';
        avs_writedata : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

        -- -- output
        rfid_tx : OUT STD_LOGIC;
        rfid_rx : IN STD_LOGIC
    );
END ENTITY;

ARCHITECTURE arch OF rfid IS
    COMPONENT FIFO_FM0
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
    END COMPONENT;
    ----------------------------------------------------------------

    COMPONENT receiver
        GENERIC (
            -- defining size of data in and clock speed
            data_width : NATURAL := 11;
            tari_width : NATURAL := 16;
            mask_width : NATURAL := 5
        );

        PORT (

            -- flags
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            enable : IN STD_LOGIC;

            -- data in from DUT
            data_DUT : IN STD_LOGIC;
            -----------------------------------
            -- DECODER

            -- config
            tari_101 : IN STD_LOGIC_VECTOR(tari_width - 1 DOWNTO 0); -- 1% above tari
            tari_099 : IN STD_LOGIC_VECTOR(tari_width - 1 DOWNTO 0); -- 1% below tari
            tari_1616 : IN STD_LOGIC_VECTOR(tari_width - 1 DOWNTO 0); -- 1% above 1.6 tari
            tari_1584 : IN STD_LOGIC_VECTOR(tari_width - 1 DOWNTO 0); -- 1% below 1.6 tari

            -- flag
            clr_err_decoder : IN STD_LOGIC;
            err_decoder : OUT STD_LOGIC;
            -----------------------------------
            -- FIFO

            -- flags
            rdreq : IN STD_LOGIC;
            sclr : IN STD_LOGIC;

            empty : OUT STD_LOGIC;
            full : OUT STD_LOGIC;

            -- data output
            data_out_fifo : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            usedw : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );

    END COMPONENT;
    ----------------------------------------------------------------
    -- reg signals
    SIGNAL reg_settings : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reg_status : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reg_send_tari, reg_send_tari_101, reg_send_tari_099, reg_send_tari_1616, reg_send_tari_1584 : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- fifo signals
    SIGNAL fifo_data_in : STD_LOGIC_VECTOR(data_size - 1 DOWNTO 0);
    SIGNAL fifo_write_req : STD_LOGIC := '0';

    -- receiver signals
    -- signal receiver_err_decoder : std_logic := '0';
    SIGNAL receiver_data_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL receiver_usedw : STD_LOGIC_VECTOR(7 DOWNTO 0);

    -- other signals
    SIGNAL pin_tx, pin_rx : STD_LOGIC := '0';
    SIGNAL loopback : STD_LOGIC := '0';

BEGIN
    -- rfid_tx
    -- rfid_rx w
    -- enable loopback mode
    pin_rx <= rfid_rx WHEN loopback = '0' ELSE
        pin_tx;
    rfid_tx <= pin_tx;

    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            IF (rst = '1') THEN
                reg_settings <= (OTHERS => '0');
                fifo_write_req <= '0';
            ELSE
                fifo_write_req <= '0';

                IF (avs_write = '1') THEN
                    CASE avs_address IS
                        WHEN "000" => --0
                            reg_settings <= avs_writedata;
                            loopback <= reg_settings(4);
                        WHEN "001" => -- 1
                            reg_send_tari <= avs_writedata(15 DOWNTO 0);
                        WHEN "010" => -- 2
                            fifo_data_in <= avs_writedata(data_size - 1 DOWNTO 0);
                            fifo_write_req <= '1';
                        WHEN "011" => -- 3
                            reg_send_tari_101 <= avs_writedata(15 DOWNTO 0);
                        WHEN "100" => -- 4
                            reg_send_tari_099 <= avs_writedata(15 DOWNTO 0);
                        WHEN "101" => -- 5
                            reg_send_tari_1616 <= avs_writedata(15 DOWNTO 0);
                        WHEN "110" => -- 6
                            reg_send_tari_1584 <= avs_writedata(15 DOWNTO 0);

                        WHEN OTHERS => NULL;
                    END CASE;

                ELSIF (avs_read = '1') THEN
                    CASE avs_address IS
                        WHEN "000" => -- 0
                            avs_readdata <= reg_settings;
                        WHEN "001" => -- 1
                            avs_readdata(15 DOWNTO 0) <= reg_send_tari;
                        WHEN "011" => -- 3
                            avs_readdata <= reg_status;
                        WHEN "100" => -- 4
                            avs_readdata <= receiver_data_out;
                            --when "101" =>
                            -- avs_readdata(1 downto 0) <= receiver_err_decoder;
                        WHEN "110" => -- 6
                            avs_readdata(7 DOWNTO 0) <= receiver_usedw;
                        WHEN "111" => -- 7
                            avs_readdata <= x"FF0055FF";
                        WHEN OTHERS => NULL;
                    END CASE;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- reg_settings is available from 0 to 10 for sender
    fm0 : FIFO_FM0 PORT MAP(
        clk => clk,
        rst_fm0 => reg_settings(0),
        enable_fm0 => reg_settings(1),
        clear_fifo => reg_settings(2),
        fifo_write_req => fifo_write_req,
        data => fifo_data_in,
        is_fifo_full => reg_status(0),
        tari => reg_send_tari,
        q => pin_tx);

    -- reg_settings is available from 11 to 31 for receiver
    rfid_receiver : receiver PORT MAP(
        -- flags
        clk => clk, --done
        rst => reg_settings(11), -- done
        enable => reg_settings(12), -- done
        -- data in from DUT 
        data_DUT => rfid_rx, -- EDITAR PARA A ENTRADA DA TAG
        -----------------------------------
        -- DECODER
        -- config
        tari_101 => reg_send_tari_101, -- 1% above tari done
        tari_099 => reg_send_tari_099, -- 1% below tari done
        tari_1616 => reg_send_tari_1616, -- 1% above 1.6 tari done 
        tari_1584 => reg_send_tari_1584, -- 1% below 1.6 tari done
        -- flag
        clr_err_decoder => reg_status(10),
        err_decoder => receiver_err_decoder,
        -----------------------------------
        -- FIFO
        -- flags
        rdreq => reg_status(11), -- done
        sclr => reg_status(12), -- done
        empty => reg_status(13), -- done
        full => reg_status(14), -- done
        -- data output
        data_out_fifo => receiver_data_out,
        usedw => receiver_usedw
    );
END arch;