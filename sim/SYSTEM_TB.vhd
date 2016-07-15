library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SYSTEM_TB is
end SYSTEM_TB;

architecture Structure of SYSTEM_TB is
	
	signal CLK_S		:	STD_LOGIC := '0';
	signal RST_S		:	STD_LOGIC;
	
	component SYSTEM
		port (
				CLK			: in  STD_LOGIC;
				RST			: in  STD_LOGIC
			 );
	end component;
	
begin

	CLK_S <= not CLK_S after 5 ns; -- 100MHz
	RST_S  <= '1', '0' after 400 ns;
		
	SYSTEM_INST: SYSTEM
		port map	(
						CLK			=>	CLK_S,
						RST			=>	RST_S
					);
end Structure;