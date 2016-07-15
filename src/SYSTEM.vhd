library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Arke_pkg.all;

entity SYSTEM is
port	(
				CLK			: in  STD_LOGIC;
				RST			: in  STD_LOGIC;
				RGB_O		: out STD_LOGIC_VECTOR(7 downto 0);
				HSync		: out STD_LOGIC;
				VSync		: out STD_LOGIC
			);
end SYSTEM;

architecture Structure of SYSTEM is
	
	signal data_in     : Array3D_data(0 to DIM_X-1, 0 to DIM_Y-1, 0 to DIM_Z-1);
	signal data_out    : Array3D_data(0 to DIM_X-1, 0 to DIM_Y-1, 0 to DIM_Z-1);
    signal control_in  : Array3D_control(0 to DIM_X-1, 0 to DIM_Y-1, 0 to DIM_Z-1);
    signal control_out : Array3D_control(0 to DIM_X-1, 0 to DIM_Y-1, 0 to DIM_Z-1);
		
	begin
		
	STORM_IP_INST: entity work.STORM_IP
		port map (
			CLK 			=> CLK,
			RST 			=> RST,
			DATA_IN		 	=> data_out(0,0,0),
			CONTROL_IN		=> control_out(0,0,0),
			DATA_OUT		=> data_in(0,0,0),
			CONTROL_OUT		=> control_in(0,0,0)
		);
	
	NOC_INST: entity work.NoC
		port map (
			clk				=> CLK,
			rst				=> RST,
			data_in     	=> data_in,
			data_out    	=> data_out,
			control_in  	=> control_in,
			control_out 	=> control_out
				 );
				 
	VGA_INST: entity work.VGA_test
		port map (
			clk				=> CLK,
			rst				=> rst,
			rgb				=> RGB_O,
			Hsync			=> HSync,
			Vsync			=> VSync,
			
			DATA_IN			=> data_out(1,1,0),
			CONTROL_IN		=> control_out(1,1,0),
			DATA_OUT		=> data_in(1,1,0),
			CONTROL_OUT 	=> control_in(1,1,0)
				 );
				 
	-- CLK_DIV_INST: entity work.clk_div
		-- port map (
					-- CLK_100MHz	=> CLK_I,
					-- CLK_50MHz 	=> CLK,
					-- RESET		=> RST,
					-- LOCKED		=> open
		-- );
end Structure;