-- #######################################################################################################
-- #                           				<<< 7-SEG DISPLAY >>>     				                     #
-- # *************************************************************************************************** #
-- # Last modified: 29.04.2012                                                                           #
-- #######################################################################################################

library IEEE;
use IEEE.STD_LOGIC_1164.all;	
use IEEE.STD_LOGIC_ARITH.all;			 
use ieee.std_logic_unsigned.ALL;

entity DISPLAY is
	port(
		CLK		: in std_logic;
		NUM		: in std_logic_vector(15 downto 0);
		NUM_7S	: out std_logic_vector(6 downto 0);
		S		: out std_logic_vector(3 downto 0)
	);
end DISPLAY;
	
architecture Behavioral of DISPLAY is

signal u, d, c, m, NUM_S : std_logic_vector(3 downto 0);
signal cont_tempo : std_logic_vector(15 downto 0);

	begin

	process(CLK)
		variable k : integer range 0 to 4000;
		begin
				if rising_edge(CLK) then
					
					if k < 1000 then
						S <= "1110";
						NUM_S <= NUM(3 downto 0);
					elsif k < 2000 then
						S <= "1101";
						NUM_S <= NUM(7 downto 4);
					elsif k < 3000 then
						S <= "1011";
						NUM_S <= NUM(11 downto 8);
					else S <= "0111";
						NUM_S <= NUM(15 downto 12);
					end if;
					
					if k < 4000 then
						k := k + 1;
					else
						k := 0;
					end if;
					
				end if;
	end process;

	process(NUM_S)
		begin
		case NUM_S is
			when "0000" => NUM_7S <="1000000";
			when "0001" => NUM_7S <="1111001";
			when "0010" => NUM_7S <="0100100";
			when "0011" => NUM_7S <="0110000";
			when "0100" => NUM_7S <="0011001";
			when "0101" => NUM_7S <="0010010";
			when "0110" => NUM_7S <="0000010";
			when "0111" => NUM_7S <="1111000";
			when "1000" => NUM_7S <="0000000";
			when "1001" => NUM_7S <="0010000";
			when "1010" => NUM_7S <="0001000";
			when "1011" => NUM_7S <="0000011";
			when "1100" => NUM_7S <="1000110";
			when "1101" => NUM_7S <="0100001";
			when "1110" => NUM_7S <="0000110";
			when "1111" => NUM_7S <="0001110";
			when others => NUM_7S <="1000000";
		end case; 
	end process;
	
	end Behavioral;