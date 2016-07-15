library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity STORM_IP_TB is
end STORM_IP_TB;

architecture Structure of STORM_IP_TB is

	signal CLK_S	:	std_logic := '0';
	signal RST_S	:	std_logic;
	
	signal CONTROL_IN_S		: std_logic_vector(2 downto 0) := "000";
	signal DATA_IN_S		: std_logic_vector(7 downto 0) := "00000000";
	
	signal CONTROL_OUT_S	: std_logic_vector(2 downto 0);
	signal DATA_OUT_S		: std_logic_vector(7 downto 0);

	component STORM_IP
		port	(
					CLK					: in  STD_LOGIC;
					RST					: in  STD_LOGIC;
					
					DATA_IN     : in STD_LOGIC_VECTOR(7 downto 0);
					CONTROL_IN  : in STD_LOGIC_VECTOR(2 downto 0);
			
					DATA_OUT	: out STD_LOGIC_VECTOR(7 downto 0);
					CONTROL_OUT : out STD_LOGIC_VECTOR(2 downto 0)
				);
	end component;
	
begin
	
	CLK_S <= not CLK_S after 5 ns; -- 100MHz
	RST_S  <= '1', '0' after 400 ns;
		
	STORM_IP_INST:	STORM_IP
		port map	(
						CLK			=> CLK_S,
						RST			=> RST_S,
						
						DATA_IN		=> DATA_IN_S,
						CONTROL_IN	=> CONTROL_IN_S,
						
						DATA_OUT	=> DATA_OUT_S,
						CONTROL_OUT => CONTROL_OUT_S
					);
	
end Structure;