library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DataManager is
	port (        
				clk			: in std_logic;
				DATA_IN     : in STD_LOGIC_VECTOR(7 downto 0);
				CONTROL_IN  : in STD_LOGIC_VECTOR(2 downto 0);
        
				DATA_OUT	: out STD_LOGIC_VECTOR(15 downto 0);
				CONTROL_OUT : out STD_LOGIC_VECTOR(2 downto 0)
		 );
end DataManager;

architecture Structure of DataManager is
	
	signal stall_go : STD_LOGIC_VECTOR(2 downto 0) := "100";
	signal last_data: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
	
begin
	
	process(clk)
	begin
		if rising_edge(clk) then
			if control_in(1) = '1' then
				DATA_OUT <= "00000000" & DATA_IN;
				last_data <= "00000000" & DATA_IN;
			else
				DATA_OUT <= last_data;
			end if;
		end if;
	end process;
	
	CONTROL_OUT <= stall_go;
	
end Structure;