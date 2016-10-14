library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SYSTEM_TB is
end SYSTEM_TB;

architecture Structure of SYSTEM_TB is
	
	signal CLK_S		:	STD_LOGIC := '0';
	signal RST_S		:	STD_LOGIC;
	signal uart_rx	:	STD_LOGIC;
	
	component SYSTEM
		port (
				CLK			: in  STD_LOGIC;
				RST			: in  STD_LOGIC;
				UART_RX		: in  STD_LOGIC
			 );
	end component;
	
	signal clk_tx: std_logic := '0';
	signal data: std_logic_vector(7 downto 0); 
	
begin

	CLK_S <= not CLK_S after 5 ns; -- 100MHz
	RST_S  <= '1', '0' after 400 ns;
		
	SYSTEM_INST: SYSTEM
		port map	(
						CLK			=>	CLK_S,
						RST			=>	RST_S,
						UART_RX		=>	uart_rx
					);
					
	clk_tx <= not clk_tx after 4.3 us;      -- 115200 bits
	
	process
    begin
        uart_rx <= '1';  -- idle
        data <= x"06";       
        
        wait until clk_tx = '1';
        uart_rx <= '0';  -- start bit
        
        wait until clk_tx = '1';
        for i in 0 to 7 loop            
            uart_rx <= data(i);
            wait until clk_tx = '1';
        end loop;
        
        uart_rx <= '1';  -- stop bit
        
        wait for 10 us;
		
		
		
		data <= x"03";
		wait until clk_tx = '1';
        uart_rx <= '0';  -- start bit
        
        wait until clk_tx = '1';
        for i in 0 to 7 loop            
            uart_rx <= data(i);
            wait until clk_tx = '1';
        end loop;
        
        uart_rx <= '1';  -- stop bit
        
        wait for 10 us;
		
		
		data <= x"32";
		wait until clk_tx = '1';
        uart_rx <= '0';  -- start bit
        
        wait until clk_tx = '1';
        for i in 0 to 7 loop            
            uart_rx <= data(i);
            wait until clk_tx = '1';
        end loop;
        
        uart_rx <= '1';  -- stop bit
        
        wait for 10 us;
		
		
		data <= x"33";
		wait until clk_tx = '1';
        uart_rx <= '0';  -- start bit
        
        wait until clk_tx = '1';
        for i in 0 to 7 loop            
            uart_rx <= data(i);
            wait until clk_tx = '1';
        end loop;
        
        uart_rx <= '1';  -- stop bit
        
        wait for 10 us;
		
		
		data <= x"01";
		wait until clk_tx = '1';
        uart_rx <= '0';  -- start bit
        
        wait until clk_tx = '1';
        for i in 0 to 7 loop            
            uart_rx <= data(i);
            wait until clk_tx = '1';
        end loop;
        
        uart_rx <= '1';  -- stop bit
        
        wait for 10 us;
		
		
		
		data <= x"00";
		wait until clk_tx = '1';
        uart_rx <= '0';  -- start bit
        
        wait until clk_tx = '1';
        for i in 0 to 7 loop            
            uart_rx <= data(i);
            wait until clk_tx = '1';
        end loop;
        
        uart_rx <= '1';  -- stop bit
        
        wait for 10 us;
		
		
		data <= x"FF";
		wait until clk_tx = '1';
        uart_rx <= '0';  -- start bit
        
        wait until clk_tx = '1';
        for i in 0 to 7 loop            
            uart_rx <= data(i);
            wait until clk_tx = '1';
        end loop;
        
        uart_rx <= '1';  -- stop bit
        
        wait;
        
    end process;
	
	
end Structure;