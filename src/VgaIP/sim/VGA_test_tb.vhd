library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity VGA_test_tb is
end VGA_test_tb;

architecture behavioral of VGA_test_tb is

    signal clk: std_logic := '0';
    signal rst: std_logic;
	
	signal DATA_IN		: std_logic_vector(7 downto 0) := x"00";
	signal CONTROL_IN	: std_logic_vector(2 downto 0) := "100";
    
begin

    UUT: entity work.VGA_test
        port map (
            clk => clk,
            rst => rst,
			DATA_IN => DATA_IN,
			CONTROL_IN => CONTROL_IN
        );

        
    clk <= not clk after 5 ns;       -- 100MHz (T = 10 ns)
    rst <= '1', '0' after 215 ns;
	
	DATA_IN <= x"0F" after 505 ns;
	DATA_IN <= x"00" after 1005 ns;
	
	CONTROL_IN <= "110";

end behavioral;
