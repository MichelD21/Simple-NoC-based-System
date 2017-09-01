library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.Arke_pkg.all;

entity PROGRAM_PUMP is

	generic	(
		MEM_SIZE      : natural := 256;  -- memory cells
		LOG2_MEM_SIZE : natural := 8    -- log2(memory cells)
		);
	port (
		CLK			: in	STD_LOGIC;
		RST			: in	STD_LOGIC;
		DATA_IN		: in	STD_LOGIC_VECTOR(7 downto 0);
		CONTROL_IN  : in	STD_LOGIC_VECTOR(2 downto 0);
		STALL_GO	: out 	STD_LOGIC;
		RST_PP		: out	STD_LOGIC;
		MEM_DATA	: out	STD_LOGIC_VECTOR(31 downto 0);
		MEM_ADDR	: out	STD_LOGIC_VECTOR(LOG2_MEM_SIZE-1 downto 0);
		MEM_WE		: out	STD_LOGIC;
		MEM_VALID	: out	STD_LOGIC
		);
end PROGRAM_PUMP;

architecture Structure of PROGRAM_PUMP is
	
	type State_type is (WAIT_HEADER, PUMP, MEM_WRITE);
	signal currentState : 	State_type;
	signal mem_buffer : 	STD_LOGIC_VECTOR(31 downto 0);
	signal count: 			integer := 0;
	signal addr:			STD_LOGIC_VECTOR(LOG2_MEM_SIZE-1 downto 0);
	signal last_flit	:	boolean;
	
	begin
	
		process(CLK,RST)
			begin
			
				if RST = '1' then
					currentState <= WAIT_HEADER;
					addr <= (others=>'0');
					last_flit <= false;
				elsif rising_edge(clk) then
					case currentState is
					
						when WAIT_HEADER =>
							if CONTROL_IN(RX) = '1' then
								addr <= (others=>'0');
								currentState <= PUMP;
							else
								currentState <= WAIT_HEADER;
							end if;
							
						when PUMP =>
							if CONTROL_IN(RX) = '1' then
								if count = 0 then
									mem_buffer(31 downto 24) <= DATA_IN;
									count <= count + 1;
									currentState <= PUMP;
								elsif count = 1 then
									mem_buffer(23 downto 16) <= DATA_IN;
									count <= count + 1;
									currentState <= PUMP;
								elsif count = 2 then
									mem_buffer(15 downto 8) <= DATA_IN;
									count <= count + 1;
									currentState <= PUMP;
								else
									mem_buffer(7 downto 0) <= DATA_IN;
									count <= 0;
									if CONTROL_IN(EOP) = '1' then
										last_flit <= true;
									end if;
									currentState <= MEM_WRITE;
								end if;
							end if;
							
						when MEM_WRITE =>
							addr <= addr + "00000001";
							if last_flit then
								last_flit <= false;
								currentState <= WAIT_HEADER;
							else
								currentState <= PUMP;
							end if;
							
					end case;
				end if;
	end process;
	
	RST_PP <= '0' when currentState = WAIT_HEADER else '1';
	
	MEM_ADDR <= addr;
	MEM_DATA <= mem_buffer;
	MEM_VALID <= '1';
	MEM_WE <= '1' when currentState = MEM_WRITE else '0';
	
	STALL_GO <= '0' when currentState = MEM_WRITE else '1';
end Structure;