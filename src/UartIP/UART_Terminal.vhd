library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.Arke_pkg.all;

entity UART_Terminal is
    generic (
        RATE_FREQ_BAUD : integer := 434 -- 50MHz at 115200 baud rate
    );    
    port (
        clk     : in std_logic;
        rst     : in std_logic;
		
		-- serial interface
        leds    : out std_logic_vector(7 downto 0);
        rx_in   : in std_logic;
		tx_out  : out std_logic;
        		
		-- NoC interface
		data_in		: in std_logic_vector(7 downto 0);
		control_in	: in std_logic_vector(2 downto 0);
		data_out	: out std_logic_vector(7 downto 0);
		control_out	: out std_logic_vector(2 downto 0)
    );
end UART_Terminal;

architecture structural of UART_Terminal is
begin
	
	RX_BLOCK: block
	
			type State_type is (WAIT_SIZE, WAIT_BYTE);
			signal currentState : State_type;
			
			signal data_av: std_logic;
			signal data_rx: std_logic_vector(7 downto 0);	
			signal packetSize: std_logic_vector(31 downto 0);
			signal count: integer := 0;
     
		begin
   
		RX_FROM_TERMINAL: entity work.UART_RX
			generic map(
				RATE_FREQ_BAUD    => RATE_FREQ_BAUD
			)
			port map (
				clk         => clk,
				rst         => rst,
				rx          => rx_in,
				data_out    => data_rx,
				data_av     => data_av
			);   
     
		process(clk,rst)
		begin
			if rst = '1' then
				currentState <= WAIT_SIZE;
			
			elsif rising_edge(clk) then          
				
				case currentState is
					-- Wait for the packet size in bytes, including header and payload
					when WAIT_SIZE =>
						if data_av = '1' then
							if count = 0 then
								count <= count + 1;
								packetSize(31 downto 24) <= data_rx;
								currentState <= WAIT_SIZE;
							elsif count = 1 then
								count <= count + 1;
								packetSize(23 downto 16) <= data_rx;
								currentState <= WAIT_SIZE;
							elsif count = 2 then
								count <= count + 1;
								packetSize(15 downto 8) <= data_rx;
								currentState <= WAIT_SIZE;
							else
								count <= 0;
								packetSize(7 downto 0) <= data_rx;
								currentState <= WAIT_BYTE;
							end if;
						else
							currentState <= WAIT_SIZE;
						end if;
					
					when WAIT_BYTE =>
						if data_av = '1' then
							packetSize <= std_logic_vector(UNSIGNED(packetSize) - 1);
							
							if packetSize = x"00000001" then
								currentState <= WAIT_SIZE;
							else
								currentState <= WAIT_BYTE;
							end if;
						else
							currentState <= WAIT_BYTE;
						end if;
				end case;
			end if;
		end process;

		data_out <= data_rx;
		control_out(TX) <= '1' when currentState = WAIT_BYTE and data_av = '1' else '0';
		control_out(EOP) <= '1' when currentState = WAIT_BYTE and packetSize = x"00000001" else '0';
        
     
        leds(0) <= '1' when currentState = WAIT_SIZE else '0';
        leds(1) <= '1' when currentState = WAIT_BYTE else '0';
        leds(2) <= '1' when packetSize = x"00000000" else '0';
        leds(3) <= '1' when packetSize = x"00000001" else '0';
        leds(4) <= '1' when packetSize > x"00000001" else '0';
	
	end block;
	
	TX_BLOCK: block
		
			type State_type is (WAIT_HEADER, WAIT_BYTE, START, TRANSMIT);
			signal currentState : State_type;
			
			signal start_tx, ready: std_logic;
			signal data_tx: std_logic_vector(7 downto 0);
			signal packetSize: UNSIGNED(31 downto 0);
			signal count: integer := 0;

		
		begin
		
		TX_TO_TERMINAL: entity work.UART_TX
			generic map(
				RATE_FREQ_BAUD    => RATE_FREQ_BAUD
			)
			port map (
				clk     => clk,
				rst     => rst,
				data_in => data_tx,
				data_av => start_tx,
				tx      => tx_out,
				ready   => ready
			);
		
		process(clk,rst)
		begin
		
			if rst = '1' then
				currentState <= WAIT_HEADER;
			
			elsif rising_edge(clk) then
				
				case currentState is
				
					when WAIT_HEADER =>
                        
						if control_in(RX) = '1' then
							currentState <= WAIT_BYTE;
						else
							currentState <= WAIT_HEADER;
						end if;
					
					when WAIT_BYTE =>
						
						if control_in(RX) = '1' then
							currentState <= START;
						else
							currentState <= WAIT_BYTE;
						end if;
					
					when START =>
                    
						currentState <= TRANSMIT;
					
					when TRANSMIT =>
                        
						if ready = '1' then
							if control_in(EOP) = '1' then
								currentState <= WAIT_HEADER;
							else
								currentState <= WAIT_BYTE;
							end if;
						else
							currentState <= TRANSMIT;
						end if;
						
				end case;
			end if;
		
		end process;
		
		data_tx <= data_in;
		start_tx <= '1' when currentState = START else '0';
		control_out(STALL_GO) <= '0' when currentState = TRANSMIT or currentState = START else '1';
        
        leds(5) <= '1' when currentState = WAIT_HEADER else '0';
        leds(6) <= '1' when currentState = WAIT_BYTE else '0';
        leds(7) <= '1' when currentState = TRANSMIT else '0';
		
	end block;
end structural;