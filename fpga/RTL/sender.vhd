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
    --! \sender.vhd
    --!
    --!
    library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_unsigned.all;
    use IEEE.numeric_std.all;
    use work.all;
    --! \brief Component responsible for encoding packets and sending them to the TAG.
    --!
    --! This component receives individual packets from the Avalon Interface and stores them in a FIFO until each packet is ready to be encoded. Currently only supports the FM0 encoding.
    --! After this, it is also responsible for sendind the encoded packets to the TAG, while respecting the restrictions of the preamble, framesync and TARI.
    --!
    --!
    --!
    entity sender is
        generic (
            -- defining size of data in and clock speed
            data_width       : natural := 26; --! Size of the data inside a packet sent between components
            tari_width       : natural := 16; --! Bits reserved for the TARI time parameter
            pw_width         : natural := 16; --! Bits reserved for the PW time parameter
            delimiter_width  : natural := 16; --! Bits reserved for the delimiter time parameter
            RTcal_width      : natural := 16; --! Bits reserved for the receiver transmitter callibration time parameter
            TRcal_width      : natural := 16; --! Bits reserved for the transmitter receiver callibration time parameter
            mask_width       : natural := 6  --! Size of the mask that indicates how many bits of the packet are in use
        );
    
        port (
            -- flags
            clk                  : in std_logic; --! Clock input
            clr_finished_sending : in std_logic; --! Clears the finished_sending flag
            enable               : in std_logic; --! Enable high
            rst                  : in std_logic; --! Reset high

            finished_sending : out std_logic;    --! Flag that indicates the packet has been sent

            -- fifo
            clear_fifo     : in std_logic;      --! Clears all data from the FIFO
            fifo_write_req : in std_logic;      --! Flag to write new data on the FIFO
            is_fifo_full   : out std_logic;     --! Flag that indicates if the FIFO has run out of space
            usedw          : out std_logic_vector(7 downto 0); --! Number of valid packets in the FIFO

            -- controller
            has_gen          : in std_logic; --! Flag high if using the preamble or framesync
            start_controller : in std_logic; --! Flag high to start sending the data

            -- generator
            is_preamble : in std_logic; --! Flag indicates preamble if high; framesync if low
    
            -- config
            tari      : in std_logic_vector(tari_width-1 downto 0); --! Time parameter
            pw        : in std_logic_vector(pw_width-1 downto 0);   --! PW parameter
            delimiter : in std_logic_vector(delimiter_width-1 downto 0); --! Delimiter parameter
            RTcal     : in std_logic_vector(RTcal_width-1 downto 0);  --! Receiver transmitter callibration parameter
            TRcal     : in std_logic_vector(TRcal_width-1 downto 0);  --! Transmitter receiver callibration parameter
    
            -- data
            data : in std_logic_vector(31 downto 0); --! Packet to be encoded and sent to the TAG
    
            -- output
            q : out std_logic --! Modulated in FM0 out signal
        );
    
    end entity;
    
    
    architecture arch of sender is
        component FIFO_FM0
            generic (
                -- defining size of data in and clock speed
                data_width : natural := data_width;
                tari_width : natural := tari_width;
                mask_width : natural := mask_width
            );
        
            port (
                -- flags
                clk : in std_logic;

                -- fm0
                rst_fm0       : in std_logic;
                enable_fm0    : in std_logic;
                encoder_ended : out std_logic;

                -- fifo
                clear_fifo     : in std_logic;
                fifo_write_req : in std_logic;
                is_fifo_full   : out std_logic;
                usedw          : out std_logic_vector(7 downto 0);
        
                -- config
                tari : in std_logic_vector(tari_width-1 downto 0);
        
                -- data
                data : in std_logic_vector(31 downto 0);
        
                -- output
                q : out std_logic
            );
        end component;

        component sender_controller is
            port (
                -- flags
                clk                    : in std_logic;
                rst                    : in std_logic;
                enable                 : in std_logic;
                signal_generator_ended : in std_logic;
                encoder_ended          : in std_logic;
                has_gen                : in std_logic;
                clr_finished_sending   : in std_logic;
                start                  : in std_logic;
                
                mux              : out std_logic;
                finished_sending : out std_logic;
                start_encoder    : out std_logic;
                start_generator  : out std_logic
            );
        
        end component;

        component signal_generator is
            generic (
                -- defining size of data in and clock speed
                tari_width       : natural := tari_width;
                pw_width         : natural := pw_width;
                delimiter_width  : natural := delimiter_width;
                RTcal_width      : natural := RTcal_width;
                TRcal_width      : natural := TRcal_width
            );
        
            port (
                -- flags
                clk         : in std_logic;
                rst         : in std_logic;
                enable      : in std_logic;
                start_send  : in std_logic;
                is_preamble : in std_logic; -- if 1 is preamble, else is frame - sync 
    
                -- config
                tari      : in std_logic_vector(tari_width-1 downto 0);
                pw        : in std_logic_vector(pw_width-1 downto 0);
                delimiter : in std_logic_vector(delimiter_width-1 downto 0);
                RTcal     : in std_logic_vector(RTcal_width-1 downto 0);
                TRcal     : in std_logic_vector(TRcal_width-1 downto 0);
                
                -- output
                has_ended : out std_logic := '0';
                data_out  : out std_logic := '0'
            );
        
        end component;

        signal encoder_ended, generator_ended, generator_out, encoder_out, signal_generator_ended, start_encoder, start_generator, mux : std_logic := '0';
    
        begin
            controller: sender_controller port map (
                clk                    => clk,
                rst                    => rst,
                enable                 => enable,
                signal_generator_ended => signal_generator_ended,
                encoder_ended          => encoder_ended,
                has_gen                => has_gen,
                start_encoder          => start_encoder,
                start_generator        => start_generator,
                mux                    => mux,
                clr_finished_sending   => clr_finished_sending,
                finished_sending       => finished_sending,
                start                  => start_controller
            );


            generator : signal_generator port map (
                clk         => clk,
                rst         => rst,
                enable      => enable,
                start_send  => start_generator,
                is_preamble => is_preamble,
                tari        => tari,
                pw          => pw,
                delimiter   => delimiter,
                RTcal       => RTcal,
                TRcal       => TRcal,
                has_ended   => signal_generator_ended,
                data_out    => generator_out
            );


            fifo_fm0_c : fifo_fm0 port map (
                clk            => clk,
                rst_fm0        => rst,
                encoder_ended  => encoder_ended,
                enable_fm0     => start_encoder,
                clear_fifo     => clear_fifo,
                fifo_write_req => fifo_write_req,
                is_fifo_full   => is_fifo_full,
                tari           => tari,
                data           => data,
                usedw          => usedw,
                q              => encoder_out
            );

            q <= encoder_out when mux = '1' else
                 generator_out;
    
    end arch ; -- arch