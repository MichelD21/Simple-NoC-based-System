-------------------------------------------------------------------------------
--
-- Title       : VGA_Controller
-- Design      : VGA_Controller
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\VGA_Controller\src\VGA_Controller.vhd
-- Generated   : Sat Dec 26 17:20:13 2015
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
                      

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity VGA_Controller is
    port(
        clk         : in std_logic;
        rst         : in std_logic;
        Hsync       : out std_logic;    -- Horizontal synchronization signal
        Vsync       : out std_logic;    -- Vertical synchronization signal
        column      : out std_logic_vector(9 downto 0);     -- Current display pixel column
        line        : out std_logic_vector(9 downto 0);     -- Current display pixel line
        visibleArea : out std_logic -- Indicates the scan on visible display area (visible column and line)
    );
end VGA_Controller;
                               
architecture VGA_640x480 of VGA_Controller is

    -- Horizontal times
    constant H_SYNC_PULSE       : integer := 96;
    constant H_BACK_PORCH       : integer := 48;
    constant H_ACTIVE_VIDEO     : integer := 640;
    constant H_FRONT_PORCH      : integer := 16;
    constant HORIZONTAL_SCAN    : integer := H_SYNC_PULSE + H_BACK_PORCH + H_ACTIVE_VIDEO + H_FRONT_PORCH;
    
    constant H_ACTIVE_VIDEO_PRE   : integer := H_SYNC_PULSE + H_BACK_PORCH;
    constant H_ACTIVE_VIDEO_POST  : integer := H_SYNC_PULSE + H_BACK_PORCH + H_ACTIVE_VIDEO;
    
    -- Vertical times
    constant V_SYNC_PULSE   : integer := 2;
    constant V_BACK_PORCH   : integer := 29;
    constant v_ACTIVE_VIDEO : integer := 480;
    constant V_FRONT_PORCH  : integer := 10;
    constant VERTICAL_SCAN  : integer := V_SYNC_PULSE + V_BACK_PORCH + v_ACTIVE_VIDEO + V_FRONT_PORCH;
    
    constant v_ACTIVE_VIDEO_PRE     : integer := V_SYNC_PULSE + V_BACK_PORCH;
    constant v_ACTIVE_VIDEO_POST    : integer := V_SYNC_PULSE + V_BACK_PORCH + v_ACTIVE_VIDEO;
    
    signal horizontalCounter    : integer;
    signal verticalCounter      : integer;
    
    signal vclk: std_logic;
    
    signal visibleArea_s: std_logic;
       
begin
   
    -- Process to generate the VGA horizontal and vertical signals (Hsynch/Vsynch)
    process(clk,rst)
    begin            
        if rising_edge(clk) then        
            if rst = '1' then
                horizontalCounter <= 0;
                verticalCounter <= 0;
                Hsync <= '0';
                Vsync <= '0';                
            else
                horizontalCounter <= horizontalCounter + 1;
                
                if  horizontalCounter = H_SYNC_PULSE-1 then  
                    Hsync <= '1';
                    
                elsif horizontalCounter = HORIZONTAL_SCAN-1 then  
                    Hsync <= '0';
                    horizontalCounter <= 0;
                    
                    -- At each complete horizontal scan, increments the verticalCounter
                    verticalCounter <= verticalCounter + 1;
                
                    if verticalCounter = V_SYNC_PULSE-1 then 
                        Vsync <= '1';
                    
                    elsif verticalCounter = VERTICAL_SCAN-1 then -- One frame complete
                        Vsync <= '0';
                        verticalCounter <= 0;             
                    end if;
                end if;
            end if;
        end if;
    end process;    
        
    visibleArea_s <= '1' when (horizontalCounter > H_ACTIVE_VIDEO_PRE-1 and horizontalCounter < H_ACTIVE_VIDEO_POST) and (verticalCounter > v_ACTIVE_VIDEO_PRE-1 and verticalCounter < v_ACTIVE_VIDEO_POST) else '0';
    
    -- Current scanning column (valid only when visibleArea = '1')
    column <= std_logic_vector(TO_UNSIGNED(horizontalCounter - H_ACTIVE_VIDEO_PRE,10)) when visibleArea_s = '1' else (others=>'U'); -- Simulation
    --column <= std_logic_vector(TO_UNSIGNED(horizontalCounter - H_ACTIVE_VIDEO_PRE,10)); -- Synthesis
    
    -- Current scanning line (valid only when visibleArea = '1')
    line <= std_logic_vector(TO_UNSIGNED(verticalCounter - v_ACTIVE_VIDEO_PRE,10)) when visibleArea_s = '1' else (others=>'U'); -- Simulation
    --line <= std_logic_vector(TO_UNSIGNED(verticalCounter - v_ACTIVE_VIDEO_PRE,10)); -- Synthesis
     
    -- Indicates that the scanning is on a visible screen area
    visibleArea <= visibleArea_s;
     
end VGA_640x480;


architecture VGA_800x600 of VGA_Controller is

    -- Horizontal times
    constant H_SYNC_PULSE       : integer := 128;
    constant H_BACK_PORCH       : integer := 88;
    constant H_ACTIVE_VIDEO     : integer := 800;
    constant H_FRONT_PORCH      : integer := 40;
    constant HORIZONTAL_SCAN    : integer := H_SYNC_PULSE + H_BACK_PORCH + H_ACTIVE_VIDEO + H_FRONT_PORCH;
    
    constant H_ACTIVE_VIDEO_PRE   : integer := H_SYNC_PULSE + H_BACK_PORCH;
    constant H_ACTIVE_VIDEO_POST  : integer := H_SYNC_PULSE + H_BACK_PORCH + H_ACTIVE_VIDEO;
    
    -- Vertical times
    constant V_SYNC_PULSE   : integer := 2;
    constant V_BACK_PORCH   : integer := 23;
    constant v_ACTIVE_VIDEO : integer := 600;
    constant V_FRONT_PORCH  : integer := 1;
    constant VERTICAL_SCAN  : integer := V_SYNC_PULSE + V_BACK_PORCH + v_ACTIVE_VIDEO + V_FRONT_PORCH;
    
    constant v_ACTIVE_VIDEO_PRE     : integer := V_SYNC_PULSE + V_BACK_PORCH;
    constant v_ACTIVE_VIDEO_POST    : integer := V_SYNC_PULSE + V_BACK_PORCH + v_ACTIVE_VIDEO;
    
    signal horizontalCounter    : integer;
    signal verticalCounter      : integer;
    
    signal visibleArea_s        : std_logic;
       
begin
   
    -- Process to generate the VGA horizontal and vertical signals (Hsynch/Vsynch)
    process(clk,rst)
    begin            
        if rising_edge(clk) then        
            if rst = '1' then
                horizontalCounter <= 0;
                verticalCounter <= 0;
                Hsync <= '0';
                Vsync <= '0';                
            else
                horizontalCounter <= horizontalCounter + 1;
                
                if  horizontalCounter = H_SYNC_PULSE-1 then  
                    Hsync <= '1';
                    
                elsif horizontalCounter = HORIZONTAL_SCAN-1 then  
                    Hsync <= '0';
                    horizontalCounter <= 0;
                    
                    -- At each complete horizontal scan, increments the verticalCounter
                    verticalCounter <= verticalCounter + 1;
                
                    if verticalCounter = V_SYNC_PULSE-1 then 
                        Vsync <= '1';
                    
                    elsif verticalCounter = VERTICAL_SCAN-1 then -- One frame complete
                        Vsync <= '0';
                        verticalCounter <= 0;             
                    end if;
                end if;
            end if;
        end if;
    end process;    
        
    visibleArea_s <= '1' when (horizontalCounter > H_ACTIVE_VIDEO_PRE-1 and horizontalCounter < H_ACTIVE_VIDEO_POST) and (verticalCounter > v_ACTIVE_VIDEO_PRE-1 and verticalCounter < v_ACTIVE_VIDEO_POST) else '0';
    
    -- Current scanning column (valid only when visibleArea = '1')
    column <= std_logic_vector(TO_UNSIGNED(horizontalCounter - H_ACTIVE_VIDEO_PRE,10)) when visibleArea_s = '1' else (others=>'U'); -- Simulation
    --column <= std_logic_vector(TO_UNSIGNED(horizontalCounter - H_ACTIVE_VIDEO_PRE,10)); -- Synthesis
    
    -- Current scanning line (valid only when visibleArea = '1')
    line <= std_logic_vector(TO_UNSIGNED(verticalCounter - v_ACTIVE_VIDEO_PRE,10)) when visibleArea_s = '1' else (others=>'U'); -- Simulation
    --line <= std_logic_vector(TO_UNSIGNED(verticalCounter - v_ACTIVE_VIDEO_PRE,10)); -- Synthesis
     
    -- Indicates that the scanning is on a visible screen area
    visibleArea <= visibleArea_s;
    
end VGA_800x600;
