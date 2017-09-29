library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Arke_pkg.all;

entity SYSTEM is
port	(
				CLK			: in	STD_LOGIC;
				RST			: in	STD_LOGIC;
				HSync		: out	STD_LOGIC;
				VSync		: out	STD_LOGIC;
				RGB_O		: out	STD_LOGIC_VECTOR(7 downto 0);
				LEDS_O		: out	STD_LOGIC_VECTOR(7 downto 0);
				UART_RX		: in	STD_LOGIC;
				UART_TX		: out	STD_LOGIC
			);
end SYSTEM;

architecture Structure of SYSTEM is
	
	signal data_in		: Array3D_data(0 to DIM_X-1, 0 to DIM_Y-1, 0 to DIM_Z-1);
	signal data_out		: Array3D_data(0 to DIM_X-1, 0 to DIM_Y-1, 0 to DIM_Z-1);
    signal control_in	: Array3D_control(0 to DIM_X-1, 0 to DIM_Y-1, 0 to DIM_Z-1);
    signal control_out	: Array3D_control(0 to DIM_X-1, 0 to DIM_Y-1, 0 to DIM_Z-1);
	
	signal CLK_50MHz	: STD_LOGIC;
	signal CLK_25MHz	: STD_LOGIC;
		
    signal rst_sync1, rst_sync2: std_logic;    
        
	begin
    
    process(CLK_50MHz)
    begin
        if rising_edge(CLK_50MHz) then
            rst_sync1 <= RST;
            rst_sync2 <= rst_sync1;
        end if;
    end process;
		
	STORM_IP_INST: entity work.STORM_IP
		port map (
			CLK 			=> CLK_50MHz,
			RST 			=> rst_sync2,
			DATA_IN		 	=> data_out(0,0,0),
			CONTROL_IN		=> control_out(0,0,0),
			DATA_OUT		=> data_in(0,0,0),
			CONTROL_OUT		=> control_in(0,0,0)
		);
	
	NOC_INST: entity work.NoC
		port map (
			clk				=> CLK_50MHz,
			rst				=> rst_sync2,
			data_in     	=> data_in,
			data_out    	=> data_out,
			control_in  	=> control_in,
			control_out 	=> control_out
				 );
				 
	VGA_INST: entity work.VGA_test
		port map (
			clk_50MHz		=> CLK_50MHz,
			clk_25MHz		=> CLK_25MHz,
			rst				=> rst_sync2,
			rgb				=> RGB_O,
			Hsync			=> HSync,
			Vsync			=> VSync,
			
			DATA_IN			=> data_out(1,1,0),
			CONTROL_IN		=> control_out(1,1,0),
			DATA_OUT		=> data_in(1,1,0),
			CONTROL_OUT 	=> control_in(1,1,0)
		);
				 
	CLK_DIV_INST: entity work.clk_div
		port map (
			CLK_IN		=> CLK,
			CLK_25MHz 	=> CLK_25MHz,
			CLK_50MHz	=> CLK_50MHz
		);
		
	SERIAL_INST: entity work.UART_Terminal
		generic map(
			RATE_FREQ_BAUD => 434 -- 50MHz at 115200 baud rate
			--RATE_FREQ_BAUD => 5208 -- 50MHz at 9600 baud rate
		)
		port map (
			clk			=> CLK_50MHz,
			rst			=> rst_sync2,
			leds		=> LEDS_O,
			rx_in		=> UART_RX,
			tx_out		=> UART_TX,
			
			DATA_IN		=> data_out(1,0,0),
			CONTROL_IN	=> control_out(1,0,0),
			DATA_OUT	=> data_in(1,0,0),
			CONTROL_OUT => control_in(1,0,0)
		);
		
	-- DATA_MANAGER_INST: entity work.DataManager
		-- generic map(
			-- fileNameIn	=> "storm_program_IN.txt",
			-- fileNameOut	=> "storm_program_OUT.txt"
			-- )
		-- port map (
			-- clk			=> CLK_50MHz,
			-- rst			=> RST,
			-- data_in		=> data_out(0,1,0),
			-- control_in	=> control_out(0,1,0),
			-- data_out	=> data_in(0,1,0),
			-- control_out	=> control_in(0,1,0)
		-- );
end Structure;