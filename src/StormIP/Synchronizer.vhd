library IEEE;
use IEEE.std_logic_1164.all;

entity Synchronizer  is
	port (  
		clock       : in std_logic;
		reset	    : in std_logic; 
		input       : in std_logic;
        output      : out std_logic
	);
end Synchronizer ;


architecture Behavioral of Synchronizer  is

   type State is (S0, S1, S2);
   signal currentState: State;

begin

	output <= '1' when currentState = S1 else '0';
    
    process(clock, reset)
	begin
		if reset = '1' then
			currentState <= S0;
		
		elsif rising_edge(clock) then
            case currentState is
                when S0 =>
                    if input = '1' then
                        currentState <= S1;
                    else
                        currentState <= S0;
                    end if;
                    
                when S1 =>
                    if input = '1' then
                        currentState <= S2;
                    else
                        currentState <= S0;
                    end if;
                    
                when others =>
                    if input = '1' then
                        currentState <= S2;
                    else
                        currentState <= S0;
                    end if;
            end case;
		end if;
	end process;
    
    
end Behavioral;