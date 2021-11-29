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
--! \FM0_encoder.vhd
--!
--!
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--! \brief https://github.com/pfeinsper/21b-indago-rfid-conformance-tester/blob/main/fpga/RTL/FM0_encoder.vhd
--!
--! For further explanation on how this encoding is done, check the EPC-GEN2 documentation - https://www.gs1.org/sites/default/files/docs/epc/Gen2_Protocol_Standard.pdf
--!
entity FM0_encoder is
    generic (
        -- defining size of data in and clock speed
        data_width : natural := 26; --! Size of the data inside a packet sent between components
        tari_width : natural := 16; --! Bits reserved for the TARI time parameter
        mask_width : natural := 6  --! Size of the mask that indicates how many bits of the packet are in use
    );

    port (
        -- flags
        clk : in std_logic; --! Clock input
        rst : in std_logic; --! Reset high
        enable : in std_logic; --! Enable high
        finished_sending : out std_logic; --! Flag high if sender has no more data to send

        -- config
        tari : in std_logic_vector(tari_width-1 downto 0); --! Time parameter

        -- fifo data
        is_fifo_empty    : in std_logic;--! Flag that indicates if the FIFO has no more data
        data_in          : in std_logic_vector((data_width + mask_width)-1 downto 0); --! packet with 26 data bits and 6 mask bits - format ddddddddddddddddddddddddddmmmmmm
        request_new_data : out std_logic; --! Flag high if requests new packet to encode and send

        -- output
        data_out : out std_logic := '0' --! Modulated in FM0 out signal
    );

end entity;


architecture arch of FM0_encoder is
    ------------------------------
    --          values          --
    ------------------------------
    signal data       : std_logic_vector(data_width-1 downto 0);
    signal mask       : std_logic_vector(mask_width-1 downto 0);
    signal mask_value : integer;
    signal tari_value : integer;


    ------------------------------
    --          flags           --
    ------------------------------
    signal data_sender_start : std_logic := '0';
    signal data_sender_end   : std_logic := '0';

    signal half_tari_start, half_tari_end : std_logic := '0';
    signal full_tari_start, full_tari_end : std_logic := '0';
    signal tari_CS_start, tari_CS_end     : std_logic := '0';

    ------------------------------
    --          states          --
    ------------------------------
    -- This controller is created using four states, we followed the diagram present in 
    -- the documentention of rfid (https://www.gs1.org/sites/default/files/docs/epc/Gen2_Protocol_Standard.pdf) page 32
    -- So we designed a Miller-Signaling State Diagram as suggested by the doc.

    type state_type_controller is (c_wait, c_wait_send, c_request, c_wait_tari_CS, c_start_send, c_wait_request);
    signal state_controller	: state_type_controller := c_wait;

    type state_type_sender is (s_wait, s_send_s1, s_send_s2, s_send_s2_part2, s_send_s3, s_send_s3_part2, s_send_s4, s_end);
    signal state_sender     : state_type_sender := s_wait;

    begin

        ------------------------------
        --          update          --
        ------------------------------
        data       <= data_in((data_width + mask_width)-1 downto mask_width);
        mask       <= data_in(mask_width-1 downto 0);
        mask_value <= to_integer(unsigned(mask));
        tari_value <= to_integer(unsigned(tari));


        ------------------------------
        --        controller        --
        ------------------------------
        -- State machine using this diagram
        -- (https://raw.githubusercontent.com/pfeinsper/21b-indago-rfid-conformance-tester/main/Diagrams/diagram-FM0-encoder.png)
        fm0_controller: process ( clk, rst, enable )
            begin
                if (rst = '1') then
                    data_sender_start <= '0';
                    state_controller  <= c_wait;
                    finished_sending <= '0';
                    request_new_data <= '0';
                elsif (rising_edge(clk) and enable = '1') then
                    case state_controller is
                        when c_wait =>
                            data_sender_start <= '0';
                            finished_sending <= '0';
                            request_new_data <= '0';
                            if (is_fifo_empty = '0') then
                                if (mask_value = 0 and unsigned(data) = 0) then
                                    request_new_data <= '1';
                                    state_controller <= c_wait_request;
                                else
                                    state_controller <= c_start_send;
                                end if;
                            end if;

                        when c_start_send =>
                            data_sender_start <= '1';
                            request_new_data <= '0';
                            state_controller <= c_wait_send;
                            
                        when c_wait_send =>
                            request_new_data <= '0';
                            data_sender_start <= '0';
                            if (data_sender_end = '1') then
                                state_controller <= c_request;
                            end if;
                        
                        when c_request =>
                            request_new_data <= '1';
                            data_sender_start <= '0';
                            state_controller <= c_wait_request;

                        when c_wait_request =>
                            request_new_data <= '0';
                            if (mask_value = 0 and unsigned(data) = 0) then
                                if (data_sender_end = '1') then
                                    tari_CS_start <= '1';
                                    state_controller <= c_wait_tari_CS;
                                else
                                    state_controller <= c_start_send;
                                end if ;
                            else
                                state_controller <= c_start_send;
                            end if;

                        when c_wait_tari_CS =>
                            request_new_data <= '0';
                            if (tari_CS_end = '1') then
                                tari_CS_start <= '0';
                                state_controller <= c_wait;
                                finished_sending <= '1';
                            end if;

                        when others =>
                            state_controller <= c_wait;
                        end case;
                end if;
        end process;


        ------------------------------
        --          sender          --
        ------------------------------
        -- This section is responsable to encode and send the date received using the Miller-Signaling State Diagram mentioned before --
        data_sender :  process ( clk, rst, enable, data_sender_end )
            variable index_bit : integer range 0 to data_width + 1;
            variable last_state_bit : state_type_sender := s_send_s2;
            begin
                if (rst = '1') then
                    state_sender <= s_wait;
                    half_tari_start <= '0';
                    full_tari_start <= '0';
                    data_out <= '0';
                    last_state_bit := s_send_s2;

                elsif (rising_edge(clk) and (enable = '1' or data_sender_end = '1')) then
                    
                    case state_sender is

                        when s_wait =>
                            data_sender_end <= '0';
                            if (mask_value = 0 and unsigned(data) = 0) then
                                last_state_bit := s_send_s2;
                                data_out <= '0';
                                data_sender_end <= '1';

                            elsif (data_sender_start = '1') then
                                index_bit := 0;
                                if (data(index_bit) = '1') then
                                    -- going to the correct state to maintain FM0 when data_in is updated
                                    if (last_state_bit = s_send_s1) then
                                        state_sender <= s_send_s4;
                                    elsif (last_state_bit = s_send_s2) then
                                        state_sender <= s_send_s1;
                                    elsif (last_state_bit = s_send_s3) then
                                        state_sender <= s_send_s4;
                                    elsif (last_state_bit = s_send_s4) then
                                        state_sender <= s_send_s1;
                                    end if ;
                                    full_tari_start <= '1';
                                else
                                    -- going to the correct state to maintain FM0 when data_in is updated
                                    if (last_state_bit = s_send_s1) then
                                        state_sender <= s_send_s3;
                                    elsif (last_state_bit = s_send_s2) then
                                        state_sender <= s_send_s2;
                                    elsif (last_state_bit = s_send_s3) then
                                        state_sender <= s_send_s3;
                                    elsif (last_state_bit = s_send_s4) then
                                        state_sender <= s_send_s2;
                                    end if ;
                                    half_tari_start <= '1';
                                end if;
                            end if;

                        when s_send_s1 => -- data 1, out 1 1
                            data_out <= '1';
                            last_state_bit := s_send_s1;

                            if (full_tari_end = '1') then
                                index_bit := index_bit + 1;
                                if (index_bit >= mask_value) then
                                    state_sender <= s_end;
                                    
                                else
                                    if (data(index_bit) = '1') then
                                        full_tari_start <= '1';
                                        state_sender <= s_send_s4;
                                    else
                                        half_tari_start <= '1';
                                        state_sender <= s_send_s3;
                                    end if;
                                end if;
                            end if;

                        ------------------------------------
                        when s_send_s2 => -- data 0, out 1 0
                            last_state_bit := s_send_s2;
                            data_out <= '1';
                            if (half_tari_end = '1') then
                                half_tari_start <= '0';
                                half_tari_start <= '1';
                                state_sender    <= s_send_s2_part2;
                            end if;

                        when s_send_s2_part2 => -- data 0, out 1 0
                            data_out <= '0';

                            if (half_tari_end = '1') then
                                half_tari_start <= '0';
                                index_bit := index_bit + 1;
                                if (index_bit >= mask_value) then
                                    state_sender <= s_end;
                                else
                                    if (data(index_bit) = '1') then
                                        full_tari_start <= '1';
                                        state_sender <= s_send_s1;
                                    else
                                        half_tari_start <= '1';
                                        state_sender <= s_send_s2;
                                    end if;
                                end if;
                            end if;
                        ------------------------------------
                        when s_send_s3 => -- data 0, out 0 1
                            last_state_bit := s_send_s3;

                            data_out <= '0';
                            if (half_tari_end = '1') then
                                half_tari_start <= '0';
                                half_tari_start <= '1';
                                state_sender    <= s_send_s3_part2;
                            end if;

                        when s_send_s3_part2 =>  -- data 0, out 0 1
                            data_out <= '1';
                            if (half_tari_end = '1') then
                                half_tari_start <= '0';
                                index_bit := index_bit + 1;
                                if (index_bit >= mask_value) then
                                    state_sender <= s_end;
                                else
                                    if (data(index_bit) = '1') then
                                        full_tari_start <= '1';
                                        state_sender <= s_send_s4;
                                    else
                                        half_tari_start <= '1';
                                        state_sender <= s_send_s3;
                                    end if;
                                end if;
                            end if;
                            
                        ------------------------------------
                        when s_send_s4 =>  -- data 1, out 0 0
                            last_state_bit := s_send_s4;

                            data_out <= '0';

                            if (full_tari_end = '1') then
                                full_tari_start <= '0';
                                index_bit := index_bit + 1;
                                if (index_bit >= mask_value) then
                                    state_sender <= s_end;
                                else
                                    if (data(index_bit) = '1') then
                                        full_tari_start <= '1';
                                        state_sender <= s_send_s1;
                                    else
                                        half_tari_start <= '1';
                                        state_sender <= s_send_s2;
                                    end if;
                                end if ;
                            end if;
                        ------------------------------------
                        when s_end =>
                            half_tari_start <= '0';
                            full_tari_start <= '0';
                            index_bit := 0;
                            state_sender <= s_wait;
                            data_sender_end <= '1';


                        when others =>
                            state_sender <= s_wait;
                    end case;
                end if;
        end process;


        ------------------------------
        --          timers          --
        ------------------------------
        -- tari is the time unit used to syncronize our data send and receive, here the chip clock speed is used to to simulate 
        -- this tari pulse, as a full, half and a waitTari. the full represents a cycle, the half tari a half cycle and the
        -- wait Tari is the time that flags the state machine that the command ended --
        half_tari : process ( clk, rst, enable )
            variable i : integer range 0 to 700 := 0;
            begin
                if (rst = '1') then
                    i := 0;
                    half_tari_end <= '0';

                elsif (rising_edge(clk) and enable = '1') then
                    half_tari_end <= '0';
                    
                    if (half_tari_start = '1') then
                        i := i + 1;
                        if (i = tari_value / 2) then
                            i := 0;
                            half_tari_end <= '1';
                        end if;
                    end if;
                end if;
        end process;

        full_tari : process ( clk, rst, enable )
            variable i2 : integer range 0 to 700 := 0;
            begin
                if (rst = '1') then
                    i2 := 0;
                    full_tari_end <= '0';

                elsif (rising_edge(clk) and enable = '1') then
                    full_tari_end <= '0';
                    if(	full_tari_start = '1') then
                        i2 := i2 + 1;
                        if (i2 = tari_value) then
                            i2 := 0;
                            full_tari_end <= '1';
                        end if;
                    end if;
                end if;

        end process;

        wait_CS_tari : process ( clk, rst, enable )
            variable i3 : integer range 0 to 1600 := 0;
            begin
                if (rst = '1') then
                    i3 := 0;
                    tari_CS_end <= '0';

                elsif (rising_edge(clk) and enable = '1') then
                    tari_CS_end <= '0';
                    if(	tari_CS_start = '1') then
                        i3 := i3 + 1;
                        if (i3 = tari_value + tari_value) then
                            i3 := 0;
                            tari_CS_end <= '1';
                        end if;
                    end if;
                end if;
        end process;

end arch ; -- arch