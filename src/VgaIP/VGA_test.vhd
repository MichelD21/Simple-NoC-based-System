
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
		data_in		: in std_logic_vector(7 downto 0);
		control_in	: in std_logic_vector(2 downto 0);
		data_out	: out std_logic_vector(7 downto 0);
		control_out	: out std_logic_vector(2 downto 0)
		
    );
end VGA_test;

architecture structural of VGA_test is
	
	-- VRAM address width
    constant ADDR_WIDTH: integer := 16;
    
	-- VRAM signals
	signal VRAM_addr: std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal VRAM_we: std_logic;
	
	-- Signals used by the VGA controller when updating the screen
	signal column_rd, line_rd: std_logic_vector(9 downto 0);
    signal pixel_rd: std_logic_vector(7 downto 0);
	signal visibleArea, visibleArea_s: std_logic;
	
	-- Signals used by the FSM when writing the VRAM
    signal line0_wr, column0_wr, line_wr, column_wr, height_wr, width_wr, pixel_wr: std_logic_vector(7 downto 0);
    signal count: integer;
	
	type State_type is (WAIT_HEADER, READ_LINE, READ_COLUMN, READ_HEIGHT, READ_WIDTH, READ_PIXEL, WRITE_VRAM);
	signal currentState : State_type := WAIT_HEADER;
    
begin
    
       VGA_CTRL: entity work.VGA_Controller(VGA_640x480)
    -- VGA_CTRL: entity work.VGA_Controller(VGA_800x600)
        port map (
            clk         => clk_25MHz,
            rst         => rst,
            Hsync       => Hsync,
            Vsync       => Vsync,
            column      => column_rd,
            line        => line_rd,
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
            we          => VRAM_we,
            address     => VRAM_addr,
            data_in     => pixel_wr,
            data_out    => pixel_rd
        );
		
	process (clk_50MHz, rst) 
	begin
		
		if rst = '1' then
			currentState <= WAIT_HEADER;
			count <= 0;

		elsif rising_edge(clk_50MHz) then
			case currentState is
				when WAIT_HEADER =>
					if control_in(RX) = '1' then
						currentState <= READ_LINE;
					else
						currentState <= WAIT_HEADER;
					end if;
					
				when READ_LINE =>
					if control_in(RX) = '1' then
						line_wr <= data_in;
						line0_wr <= data_in;
						currentState <= READ_COLUMN;
					else
						currentState <= READ_LINE;
					end if;
					
				when READ_COLUMN =>
					if control_in(RX) = '1' then
						column_wr <= data_in;
						column0_wr <= data_in;
						currentState <= READ_HEIGHT;
					else
						currentState <= READ_COLUMN;
					end if;
					
				when READ_HEIGHT =>
					if control_in(RX) = '1' then
						height_wr <= data_in;
						currentState <= READ_WIDTH;
					else
						currentState <= READ_HEIGHT;
					end if;
					
				when READ_WIDTH =>
					if control_in(RX) = '1' then
						width_wr <= data_in;
						currentState <= READ_PIXEL;
					else
						currentState <= READ_WIDTH;
					end if;
					
				when READ_PIXEL =>
					if control_in(RX) = '1' then
						pixel_wr <= data_in;
						currentState <= WRITE_VRAM;
					else
						currentState <= READ_PIXEL;					
					end if;
				
				when WRITE_VRAM =>
					if visibleArea_s = '0' then
						if count = 1 then
							count <= 0;
							
							if height_wr = "00000000" and width_wr = "00000000" then		-- draws from starting address to end of
								column_wr <= std_logic_vector( UNSIGNED(column_wr) + 1 );	-- screen with a single color
								if column_wr = "11111111" then
									line_wr <= std_logic_vector( UNSIGNED(line_wr) + 1 );
									if line_wr = "11111111" then
										currentState <= WAIT_HEADER;
									end if;
								else
									currentState <= WRITE_VRAM;
								end if;
								
							elsif height_wr /= "00000000" and width_wr = "00000000" then	-- draws a single line from starting address to
								line_wr <= std_logic_vector( UNSIGNED(line_wr) + 1 );		-- ending address with a single color
								if line_wr = "11111111" or line_wr = std_logic_vector( UNSIGNED(line0_wr) + UNSIGNED(height_wr) - 1 ) then
									currentState <= WAIT_HEADER;
								else
									currentState <= WRITE_VRAM;
								end if;
								
							elsif height_wr = "00000000" and width_wr /= "00000000" then	-- draws a single column from starting address to
								column_wr <= std_logic_vector( UNSIGNED(column_wr) + 1 );	-- ending address with a single color
								if column_wr = "11111111" or column_wr = std_logic_vector( UNSIGNED(column0_wr) + UNSIGNED(width_wr) - 1 ) then
									currentState <= WAIT_HEADER;
								else
									currentState <= WRITE_VRAM;
								end if;
								
							else
								column_wr <= std_logic_vector( UNSIGNED(column_wr) + 1 );	-- draws an image from starting address to
																							-- ending address with the full set of colors
								if column_wr = "11111111" or column_wr = std_logic_vector( UNSIGNED(column0_wr) + UNSIGNED(width_wr) - 1 ) then
									if line_wr = "11111111" or line_wr = std_logic_vector( UNSIGNED(line0_wr) + UNSIGNED(height_wr) - 1 ) then
										currentState <= WAIT_HEADER;							
									else
										line_wr <= std_logic_vector( UNSIGNED(line_wr) + 1 );
										column_wr <= column0_wr;
										currentState <= READ_PIXEL;
									end if;
								else
									currentState <= READ_PIXEL;
								end if;
								
							end if;
							
						else
							count <= count + 1;
							currentState <= WRITE_VRAM;
						end if;
					else
						currentState <= WRITE_VRAM;
					end if;
					
				when others =>
					currentState <= WAIT_HEADER;
					
			end case;
		end if;
	end process;

	control_out(STALL_GO) 	<= '0' when currentState = WRITE_VRAM else '1';
	control_out(RX)			<= '0';
	control_out(EOP)		<= '0';
	
	VRAM_we	<= '1' when currentState = WRITE_VRAM and visibleArea_s = '0' else '0';
		
	VRAM_addr	<=	line_rd(7 downto 0) & column_rd(7 downto 0) when visibleArea_s = '1' else
						line_wr & column_wr; -- 256*256 window (address: 0-65535)
	
	-- The visibleArea signal refers to the full screen
	-- The area outside the 256x256 window is white
	rgb	<=  pixel_rd when visibleArea = '1' and UNSIGNED(line_rd) < 256 and UNSIGNED(column_rd) < 256 else   -- Inside the 256x256 window
			(others=>'1') when visibleArea = '1' else                                               -- Inside the screen resolution
			(others=>'0');                                                                          -- Outside the screen resolution (no visible area)
	
	process(clk_25MHz)
	begin
		if rising_edge(clk_25MHz) then
			visibleArea <= visibleArea_s;
		end if;
	end process;
        
end structural;