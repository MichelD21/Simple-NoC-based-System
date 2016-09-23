
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.Arke_pkg.all;

entity VGA_test is
    port (  
        clk_50MHz	: in std_logic;
		clk_25MHz	: in std_logic;
        rst         : in std_logic;
		
		-- VGA interface
        rgb         : out std_logic_vector(7 downto 0);
        Hsync       : out std_logic;
        Vsync       : out std_logic;
		
		-- NoC interface
		DATA_IN		: in std_logic_vector(7 downto 0);
		CONTROL_IN	: in std_logic_vector(2 downto 0);
		DATA_OUT	: out std_logic_vector(7 downto 0);
		CONTROL_OUT	: out std_logic_vector(2 downto 0)
		
    );
end VGA_test;

architecture structural of VGA_test is

    constant ADDR_WIDTH: integer := 16;
    
    signal column, line: std_logic_vector(9 downto 0);
    signal memoryAddress: std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal pixel, from_noc_line, from_noc_column, from_noc_pixel: std_logic_vector(7 downto 0);
    signal visibleArea, visibleArea_s, write_enable, stall_0: std_logic;
    signal count: UNSIGNED(1 downto 0);
   	signal count_clk25: UNSIGNED(3 downto 0);
	
	type State_type is (WAIT_HEADER, S_line, S_column, S_pixel1, S_pixel2);
	signal State : State_type := WAIT_HEADER;
    
begin
    
       VGA_CTRL: entity work.VGA_Controller(VGA_640x480)
    --VGA_CTRL: entity work.VGA_Controller(VGA_800x600)
        port map (
            clk         => clk_25MHz,
            rst         => rst,
            Hsync       => Hsync,
            Vsync       => Vsync,
            column      => column,
            line        => line,
            visibleArea => visibleArea_s
        );
            
    VRAM: entity work.VMemory
        generic map (
            DATA_WIDTH  => 8,
            ADDR_WIDTH  => ADDR_WIDTH,
            IMAGE       => "bram_pam_256x256.txt"
        )
        port map (
            clk         => clk_25MHz,
            we          => write_enable,
            address     => memoryAddress,
            data_in     => from_noc_pixel,
            data_out    => pixel
        );
		
	process (clk_50MHz, rst) 
	begin
		
		if rst = '1' then
			State <= WAIT_HEADER;
			count_clk25 <= (others=>'0');

		elsif rising_edge(clk_50MHz) then
			case state is
				when WAIT_HEADER =>
					if CONTROL_IN(RX) = '1' then
						State <= S_line;
					else
						State <= WAIT_HEADER;
					end if;
					
				when S_line =>
					if CONTROL_IN(RX) = '1' then
						from_noc_line <= DATA_IN;
						State <= S_column;
					end if;
					
				when S_column =>
					if CONTROL_IN(RX) = '1' then
						from_noc_column <= DATA_IN;
						State <= S_pixel1;
					end if;
					
				when S_pixel1 =>
					if CONTROL_IN(RX) = '1' then
						from_noc_pixel <= DATA_IN;
						State <= S_pixel2;						
					end if;
				
				when S_pixel2 =>
					if visibleArea_s = '0' then
						if count_clk25 = 4 then
							count_clk25 <= (others=>'0');
							State <= WAIT_HEADER;
						else
							count_clk25 <= count_clk25 + 1;
							State <= S_pixel2;
						end if;
					else
						State <= S_pixel2;
					end if;
					
				when others =>
					State <= WAIT_HEADER;
					
			end case;
		end if;
	end process;

	CONTROL_OUT(STALL_GO) 	<= '0' when State = S_pixel2 else '1';
	CONTROL_OUT(RX)			<= '0';
	CONTROL_OUT(EOP)		<= '0';
	
	write_enable	<= '1' when State = S_pixel2 and visibleArea_s = '0' else '0';
		
	memoryAddress	<=	line(7 downto 0) & column(7 downto 0) when visibleArea_s = '1' else
						from_noc_line & from_noc_column; -- 256*256 window (address: 0-65535)
	
	-- The visibleArea signal refers to the full screen
	-- The area outside the 256x256 window is white
	rgb	<=  pixel when visibleArea = '1' and UNSIGNED(line) < 256 and UNSIGNED(column) < 256 else   -- Inside the 256x256 window
			(others=>'1') when visibleArea = '1' else                                               -- Inside the screen resolution
			(others=>'0');                                                                          -- Outside the screen resolution (no visible area)
	
	process(clk_25MHz)
	begin
		if rising_edge(clk_25MHz) then
			visibleArea <= visibleArea_s;
		end if;
	end process;
		
		
		
        
end structural;