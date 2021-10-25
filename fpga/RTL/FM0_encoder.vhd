-----------------------------------------
--            FM0 COMPONENT            --
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

ENTITY FM0_encoder IS
    GENERIC (
        -- defining size of data in and clock speed
        data_width : NATURAL := 26;
        tari_width : NATURAL := 16;
        mask_width : NATURAL := 6
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
        data_in : IN STD_LOGIC_VECTOR((data_width + mask_width) - 1 DOWNTO 0); -- format expected : dddddddddddmmmmm
        request_new_data : OUT STD_LOGIC;

        -- output
        data_out : OUT STD_LOGIC := '0'
    );

END ENTITY;
ARCHITECTURE arch OF FM0_encoder IS
    ------------------------------
    --          values          --
    ------------------------------
    SIGNAL data : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL mask : STD_LOGIC_VECTOR(mask_width - 1 DOWNTO 0);
    SIGNAL mask_value : INTEGER;
    SIGNAL tari_value : INTEGER;
    ------------------------------
    --          flags           --
    ------------------------------
    SIGNAL data_sender_start : STD_LOGIC := '0';
    SIGNAL data_sender_end : STD_LOGIC := '0';

    SIGNAL half_tari_start, half_tari_end : STD_LOGIC := '0';
    SIGNAL full_tari_start, full_tari_end : STD_LOGIC := '0';
    SIGNAL tari_CS_start, tari_CS_end : STD_LOGIC := '0';

    ------------------------------
    --          states          --
    ------------------------------
    -- This controller is created using four states, we followed the diagram present in 
    -- the documentention of rfid (https://www.gs1.org/sites/default/files/docs/epc/Gen2_Protocol_Standard.pdf) page 32
    -- So we designed a Miller-Signaling State Diagram as suggested by the doc.

    TYPE state_type_controller IS (c_wait, c_send, c_request, c_wait_tari);
    SIGNAL state_controller : state_type_controller := c_wait;

    TYPE state_type_sender IS (s_wait, s_send_s1, s_send_s2, s_send_s2_part2, s_send_s3, s_send_s3_part2, s_send_s4, s_end);
    SIGNAL state_sender : state_type_sender := s_wait;

BEGIN

    ------------------------------
    --          update          --
    ------------------------------
    data <= data_in((data_width + mask_width) - 1 DOWNTO mask_width);
    mask <= data_in(mask_width - 1 DOWNTO 0);
    mask_value <= to_integer(unsigned(mask));
    tari_value <= to_integer(unsigned(tari));
    ------------------------------
    --        controller        --
    ------------------------------
    -- State machine using this diagram
    -- (https://raw.githubusercontent.com/pfeinsper/21b-indago-rfid-conformance-tester/main/Diagrams/diagram-FM0-encoder.png)

    fm0_controller : PROCESS (clk, rst, enable)
    BEGIN
        IF (rst = '1') THEN
            data_sender_start <= '0';
            state_controller <= c_wait;

        ELSIF (rising_edge(clk) AND enable = '1') THEN
            CASE state_controller IS
                WHEN c_wait =>
                    request_new_data <= '0';

                    IF (is_fifo_empty = '0') THEN
                        state_controller <= c_send;
                        data_sender_start <= '1';
                    END IF;

                WHEN c_send =>
                    IF (data_sender_end = '1') THEN
                        data_sender_start <= '0';
                        request_new_data <= '1';
                        state_controller <= c_request;
                    END IF;

                WHEN c_request =>
                    data_sender_start <= '0';

                    IF (is_fifo_empty = '1') THEN
                        tari_CS_start <= '1';
                        state_controller <= c_wait_tari;
                        
                    ELSE
                        state_controller <= c_wait;
                    END IF;

                WHEN c_wait_tari =>
                    request_new_data <= '0';

                    IF (tari_CS_end = '1') THEN
                        tari_CS_start <= '0';
                        state_controller <= c_wait;
                    END IF;

                WHEN OTHERS =>
                    state_controller <= c_wait;
            END CASE;
        END IF;
    END PROCESS;

    ------------------------------
    --          sender          --
    ------------------------------
    -- This section is responsable to encode and send the date received using the Miller-Signaling State Diagram mentioned before --
    data_sender : PROCESS (clk, rst)
        VARIABLE index_bit : INTEGER RANGE 0 TO data_width + 1;
        VARIABLE last_state_bit : state_type_sender := s_send_s2;

    BEGIN
        IF (rst = '1') THEN
            state_sender <= s_wait;
            half_tari_start <= '0';
            full_tari_start <= '0';
            data_out <= '0';
            last_state_bit := s_send_s2;

        ELSIF (rising_edge(clk) AND enable = '1') THEN
            CASE state_sender IS
                WHEN s_wait =>
                    data_sender_end <= '0';
                    finished_sending <= '0';

                    IF (mask_value = 0) THEN
                        last_state_bit := s_send_s1;
                        data_out <= '0';
                        data_sender_end <= '1';
                        state_sender <= s_end;
                        finished_sending <= '1';

                    ELSIF (data_sender_start = '1') THEN
                        index_bit := 0;

                        IF (data(index_bit) = '1') THEN
                            -- going to the correct state to maintain FM0 when data_in is updated
                            IF (last_state_bit = s_send_s1) THEN
                                state_sender <= s_send_s4;
                            ELSIF (last_state_bit = s_send_s2) THEN
                                state_sender <= s_send_s1;
                            ELSIF (last_state_bit = s_send_s3) THEN
                                state_sender <= s_send_s4;
                            ELSIF (last_state_bit = s_send_s4) THEN
                                state_sender <= s_send_s1;
                            END IF;
                            full_tari_start <= '1';

                        ELSE
                            -- going to the correct state to maintain FM0 when data_in is updated
                            IF (last_state_bit = s_send_s1) THEN
                                state_sender <= s_send_s3;
                            ELSIF (last_state_bit = s_send_s2) THEN
                                state_sender <= s_send_s2;
                            ELSIF (last_state_bit = s_send_s3) THEN
                                state_sender <= s_send_s3;
                            ELSIF (last_state_bit = s_send_s4) THEN
                                state_sender <= s_send_s2;
                            END IF;
                            half_tari_start <= '1';
                        END IF;
                    END IF;

                WHEN s_send_s1 => -- data 1, out 1 1
                    data_out <= '1';
                    last_state_bit := s_send_s1;

                    IF (full_tari_end = '1') THEN
                        index_bit := index_bit + 1;

                        IF (index_bit = mask_value) THEN
                            state_sender <= s_end;
                            data_sender_end <= '1';

                        ELSE
                            IF (data(index_bit) = '1') THEN
                                full_tari_start <= '1';
                                state_sender <= s_send_s4;

                            ELSE
                                half_tari_start <= '1';
                                state_sender <= s_send_s3;
                            END IF;
                        END IF;
                    END IF;

                    ------------------------------------
                WHEN s_send_s2 => -- data 0, out 1 0
                    last_state_bit := s_send_s2;
                    data_out <= '1';

                    IF (half_tari_end = '1') THEN
                        half_tari_start <= '0';
                        half_tari_start <= '1';
                        state_sender <= s_send_s2_part2;
                    END IF;

                WHEN s_send_s2_part2 => -- data 0, out 1 0
                    data_out <= '0';

                    IF (half_tari_end = '1') THEN
                        half_tari_start <= '0';
                        index_bit := index_bit + 1;

                        IF (index_bit = mask_value) THEN
                            state_sender <= s_end;
                            data_sender_end <= '1';

                        ELSE
                            IF (data(index_bit) = '1') THEN
                                full_tari_start <= '1';
                                state_sender <= s_send_s1;

                            ELSE
                                half_tari_start <= '1';
                                state_sender <= s_send_s2;
                            END IF;
                        END IF;
                    END IF;
                    ------------------------------------
                WHEN s_send_s3 => -- data 0, out 0 1
                    last_state_bit := s_send_s3;
                    data_out <= '0';

                    IF (half_tari_end = '1') THEN
                        half_tari_start <= '0';
                        half_tari_start <= '1';
                        state_sender <= s_send_s3_part2;
                    END IF;

                WHEN s_send_s3_part2 => -- data 0, out 0 1
                    data_out <= '1';

                    IF (half_tari_end = '1') THEN
                        half_tari_start <= '0';
                        index_bit := index_bit + 1;

                        IF (index_bit = mask_value) THEN
                            state_sender <= s_end;
                            data_sender_end <= '1';

                        ELSE
                            IF (data(index_bit) = '1') THEN
                                full_tari_start <= '1';
                                state_sender <= s_send_s4;

                            ELSE
                                half_tari_start <= '1';
                                state_sender <= s_send_s3;
                            END IF;
                        END IF;
                    END IF;

                    ------------------------------------
                WHEN s_send_s4 => -- data 1, out 0 0
                    last_state_bit := s_send_s4;
                    data_out <= '0';

                    IF (full_tari_end = '1') THEN
                        full_tari_start <= '0';
                        index_bit := index_bit + 1;

                        IF (index_bit = mask_value) THEN
                            state_sender <= s_end;
                            data_sender_end <= '1';

                        ELSE
                            IF (data(index_bit) = '1') THEN
                                full_tari_start <= '1';
                                state_sender <= s_send_s1;

                            ELSE
                                half_tari_start <= '1';
                                state_sender <= s_send_s2;
                            END IF;
                        END IF;
                    END IF;
                    ------------------------------------
                WHEN s_end =>
                    half_tari_start <= '0';
                    full_tari_start <= '0';
                    index_bit := 0;
                    state_sender <= s_wait;
                    data_sender_end <= '0';

                WHEN OTHERS =>
                    state_sender <= s_wait;
            END CASE;
        END IF;
    END PROCESS;
    ------------------------------
    --          timers          --
    ------------------------------
    -- tari is the time unit used to syncronize our data send and receive, here the chip clock speed is used to to simulate 
    -- this tari pulse, as a full, half and a waitTari. the full represents a cycle, the half tari a half cycle and the
    -- wait Tari is the time that flags the state machine that the command ended --
    half_tari : PROCESS (clk, rst)
        VARIABLE i : INTEGER RANGE 0 TO 700 := 0;

    BEGIN
        IF (rst = '1') THEN
            i := 0;
            half_tari_end <= '0';

        ELSIF (rising_edge(clk) AND enable = '1') THEN
            half_tari_end <= '0';

            IF (half_tari_start = '1') THEN
                i := i + 1;

                IF (i = tari_value / 2) THEN
                    i := 0;
                    half_tari_end <= '1';
                END IF;
            END IF;
        END IF;
    END PROCESS;

    full_tari : PROCESS (clk, rst)
        VARIABLE i2 : INTEGER RANGE 0 TO 700 := 0;

    BEGIN
        IF (rst = '1') THEN
            i2 := 0;
            full_tari_end <= '0';

        ELSIF (rising_edge(clk) AND enable = '1') THEN
            full_tari_end <= '0';

            IF (full_tari_start = '1') THEN
                i2 := i2 + 1;

                IF (i2 = tari_value) THEN
                    i2 := 0;
                    full_tari_end <= '1';
                END IF;
            END IF;
        END IF;

    END PROCESS;

    wait_CS_tari : PROCESS (clk, rst)
        VARIABLE i3 : INTEGER RANGE 0 TO 1600 := 0;

    BEGIN
        IF (rst = '1') THEN
            i3 := 0;
            tari_CS_end <= '0';

        ELSIF (rising_edge(clk) AND enable = '1') THEN
            tari_CS_end <= '0';

            IF (tari_CS_start = '1') THEN
                i3 := i3 + 1;
                
                IF (i3 = tari_value + tari_value) THEN
                    i3 := 0;
                    tari_CS_end <= '1';
                END IF;
            END IF;
        END IF;
    END PROCESS;

END arch; -- arch