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
        tx_o    : out std_logic;
		
		-- NoC interface
		DATA_IN		: in std_logic_vector(7 downto 0);
		CONTROL_IN	: in std_logic_vector(2 downto 0);
		DATA_OUT	: out std_logic_vector(7 downto 0);
		CONTROL_OUT	: out std_logic_vector(2 downto 0)
    );
end UART_Terminal;

architecture structural of UART_Terminal is

    signal data_av, data_av_reg, start_tx, ready: std_logic;
    signal data: std_logic_vector(7 downto 0);
	signal dataL, dataH: std_logic_vector(3 downto 0);
	signal data_ascii: unsigned(3 downto 0);
	
	type State_type is (HEADER0, HEADER1, LINE0, LINE1, COLUMN0, COLUMN1, PIXEL0, PIXEL1);
	signal State : State_type := HEADER0;
     
begin
    
    RX_FROM_TERMINAL: entity work.UART_RX
        generic map(
            RATE_FREQ_BAUD    => RATE_FREQ_BAUD
        )
        port map (
            clk         => clk,
            rst         => rst,
            rx          => rx,
            data_out    => data,
            data_av     => data_av
        );   
    
    TX_TO_TERMINAL: entity work.UART_TX
        generic map(
            RATE_FREQ_BAUD    => RATE_FREQ_BAUD
        )
        port map (
            clk     => clk,
            rst     => rst,
            data_in => data,
            data_av => start_tx,
            tx      => tx_o,
            ready   => ready
        );
        
    process(clk,rst)
    begin
        if rst = '1' then
            start_tx <= '0';
			CONTROL_OUT(EOP) <= '0';
			CONTROL_OUT(TX) <= '0';
			State <= HEADER0;
        
        elsif rising_edge(clk) then
            
			            
			case state is
				when HEADER0 =>
					data_av_reg <= data_av;
					CONTROL_OUT(EOP) <= '0';
					CONTROL_OUT(TX) <= '0';
					
					if data_av_reg = '1' and ready = '1' and CONTROL_IN(STALL_GO) = '1' then
						start_tx <= '1';
						dataH <= dataL;
						State <= HEADER1;
					else
						start_tx <= '0';
						CONTROL_OUT(TX) <= '0';
						State <= HEADER0;
					end if;
					
				when HEADER1 =>
					data_av_reg <= data_av;
					CONTROL_OUT(EOP) <= '0';
					
					if data_av_reg = '1' and ready = '1' and CONTROL_IN(STALL_GO) = '1' then
						start_tx <= '1';
						DATA_OUT <= dataH & dataL;
						CONTROL_OUT(TX) <= '1';
						State <= LINE0;
					else
						start_tx <= '0';
						CONTROL_OUT(TX) <= '0';
						State <= HEADER1;
					end if;
										
				when LINE0 =>
					data_av_reg <= data_av;
					CONTROL_OUT(EOP) <= '0';
					CONTROL_OUT(TX) <= '0';
					
					if data_av_reg = '1' and ready = '1' and CONTROL_IN(STALL_GO) = '1' then
						start_tx <= '1';
						dataH <= dataL;
						State <= LINE1;
					else
						start_tx <= '0';
						State <= LINE0;
					end if;
					
				when LINE1 =>
					data_av_reg <= data_av;
					CONTROL_OUT(EOP) <= '0';
					
					if data_av_reg = '1' and ready = '1' and CONTROL_IN(STALL_GO) = '1' then
						start_tx <= '1';
						DATA_OUT <= dataH & dataL;
						CONTROL_OUT(TX) <= '1';
						State <= COLUMN0;
					else
						start_tx <= '0';
						CONTROL_OUT(TX) <= '0';
						State <= LINE1;
					end if;
					
				when COLUMN0 =>
					data_av_reg <= data_av;
					CONTROL_OUT(EOP) <= '0';
					CONTROL_OUT(TX) <= '0';
					
					if data_av_reg = '1' and ready = '1' and CONTROL_IN(STALL_GO) = '1' then
						start_tx <= '1';
						dataH <= dataL;
						State <= COLUMN1;
					else
						start_tx <= '0';
						CONTROL_OUT(TX) <= '0';
						State <= COLUMN0;
					end if;
					
				when COLUMN1 =>
					data_av_reg <= data_av;
					CONTROL_OUT(EOP) <= '0';
					
					if data_av_reg = '1' and ready = '1' and CONTROL_IN(STALL_GO) = '1' then
						start_tx <= '1';
						DATA_OUT <= dataH & dataL;
						CONTROL_OUT(TX) <= '1';
						State <= PIXEL0;
					else
						start_tx <= '0';
						CONTROL_OUT(TX) <= '0';
						State <= COLUMN1;
					end if;
					
				when PIXEL0 =>
					data_av_reg <= data_av;
					CONTROL_OUT(EOP) <= '0';
					CONTROL_OUT(TX) <= '0';
					
					if data_av_reg = '1' and ready = '1' and CONTROL_IN(STALL_GO) = '1' then
						start_tx <= '1';
						dataH <= dataL;
						State <= PIXEL1;
					else
						start_tx <= '0';
						CONTROL_OUT(TX) <= '0';
						State <= PIXEL0;
					end if;
					
				when PIXEL1 =>
					data_av_reg <= data_av;
					
					if data_av_reg = '1' and ready = '1' and CONTROL_IN(STALL_GO) = '1' then
						start_tx <= '1';
						DATA_OUT <= dataH & dataL;
						CONTROL_OUT(EOP) <= '1';
						CONTROL_OUT(TX) <= '1';
						State <= HEADER0;
					else
						start_tx <= '0';
						CONTROL_OUT(EOP) <= '0';
						CONTROL_OUT(TX) <= '0';
						State <= PIXEL0;
					end if;
				
				when others =>
					State <= HEADER0;
					
			end case;
        end if;
        
    end process;
	
	data_ascii <= unsigned( data(3 downto 0) );
	dataL	<= "0000" when data = "00000000" else
				std_logic_vector( data_ascii - 87 ) when data(6 downto 5) = "11" else
				std_logic_vector( data_ascii - 55 ) when data(6 downto 5) = "10" else
				std_logic_vector( data_ascii - 48 );
	
	CONTROL_OUT( STALL_GO )	<= '1';
	
	leds					<= dataH & dataL;
   
end structural;