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
        rx      : in std_logic;
        		
		-- NoC interface
		data_in		: in std_logic_vector(7 downto 0);
		control_in	: in std_logic_vector(2 downto 0);
		data_out	: out std_logic_vector(7 downto 0);
		control_out	: out std_logic_vector(2 downto 0)
    );
end UART_Terminal;

architecture structural of UART_Terminal is

    type State_type is (WAIT_SIZE, WAIT_BYTE);
	signal currentState : State_type;
	
	signal data_av, ready: std_logic;
    signal data_rx: std_logic_vector(7 downto 0);	
	signal packetSize: UNSIGNED(7 downto 0);
     
begin
    
    RX_FROM_TERMINAL: entity work.UART_RX
        generic map(
            RATE_FREQ_BAUD    => RATE_FREQ_BAUD
        )
        port map (
            clk         => clk,
            rst         => rst,
            rx          => rx,
            data_out    => data_rx,
            data_av     => data_av
        );   
   
     
	process(clk,rst)
    begin
        if rst = '1' then
			leds <= (others=>'0');
			currentState <= WAIT_SIZE;
        
        elsif rising_edge(clk) then          
			
			if data_av = '1' then
				leds <= data_rx;
			end if;
			
			case currentState is
				-- Wait for the packet size in bytes, including header and payload
				when WAIT_SIZE =>
					if data_av = '1' then
						packetSize <= UNSIGNED(data_rx);
						currentState <= WAIT_BYTE;
					else
						currentState <= WAIT_SIZE;
					end if;
				
				when WAIT_BYTE =>
					if data_av = '1' and control_in(STALL_GO) = '1' then
						packetSize <= packetSize - 1;
						
						if packetSize = 0 then
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
	control_out(EOP) <= '1' when currentState = WAIT_BYTE and packetSize = 0 else '0';
   
end structural;