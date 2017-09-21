# System_NoC
An Arke NoC implementation featuring StormCore, an ARM-based processor.
____________________________________________________________________________________________________________________________________________________________________________________________________________________

# Overview

    This project features the following structure:
    
        An interconnecting ARKE NoC.
        A StormCore (ARM) instance in NoC node #00;
        A VGA driver in node #11;
        An UART serial I/O in node #10;
        
         ______                      ______
        |      |                    |      |
        |      |                    | VGA  |
        |      |                    |      |
        |______|                    |______|
               \____            ____/
               |R-01|__________|R-11|
               |____|          |____|     
                 |                |       
                 |                |
                 |       2x2      |
                 |       NoC      |
                 |                |
                _|__            __|_
               |R-00|__________|R-10|
               |____|          |____|
         ______/                    \______
        |      |                    |      |
        | ARM  |                    | UART |
        |      |                    |      |
        |______|                    |______|

        
        Currently, the UART is capable of sending image packets to the VGA and/or program packets to the StormCore.
        The processor is able to send data to VGA as image packets and/or UART as text for the user terminal.
____________________________________________________________________________________________________________________________________________________________________________________________________________________
        
# Operation
    
    StormCore:
        The StormCore instance starts off with a simple program designed to send packets to the VGA instance and the UART instance.
        After a hard system reset, the processor program counter starts reading and executing instructions from address #0 on the program memory (MEMORY.VHD).
        The resulting program output is then sent to the GPIO_OUT register which is connected to the Local Port of the #00 node of the NoC.
        
        
    NoC:
        A 2x2 ARKE NoC is present, connecting all the IPs. One of the NoC nodes (#01) is left unconnected.
        Packets that go in the NoC must have a flit size of 8 bits and thus might need adjustment when working with larger frames.
        The first flit of a packet entering the network must contain the address node (Header) in the least significant bits (in the 2 LSBs in this case).
        The last flit of a packet to enter the network must drive a logical high in the end-of-packet (EOP) bit of the IP->NoC interface.
        The stall-go signal can be used IP-side to pause the communication when required. The NoC eventually stalls/goes an IP due to a variety of factors.
        
    VGA:
        The VGA works in two stages:
            -> When the device is able to draw, the VGA IP disables memory writing and draws on the screen using the present memory image.
            During this stage the NoC is stalled if there any active packet transmissions to the VGA.
            -> The VGA IP stops drawing and enables memory writing.
        These stages switch between each other during normal VGA operation.
        
        VGA's packet frame is as follows:
            
            | HEADER | STARTING COLUMN | STARTING LINE | HEIGHT | WIDTH | PIXEL PAYLOAD |
            |   8b   |        8b       |      8b       |   8b   |   8b  |     k x 8b    |
            
            k = HEIGHT x WIDTH (except in special modes)
                
        Where:                  
            HEADER is the address of the VGA node in the NoC, 0b00000011 in this case.
            STARTING COLUMN and STARTING LINE represent the point where the image should begin to be drawn, with both #0 being the leftmost top pixel and both #255 being the rightmost bottom pixel;
            HEIGHT and WIDTH represent the size of the image in pixels. Maximum size is 255x255 for an image that starts at coordenates #0 (see Notes);
            PIXEL PAYLOAD carry the color data in each 8-bit flit. The VGA registers the image size (HEIGHT x WIDTH) and expects the PAYLOAD to be of equal size.
            
        Special Modes:
            Three special drawing modes are possible in the current packet frame.
            1 - To fill the screen, starting with the pixel in the address [STARTING COLUMN, STARTING LINE] and ending at the rightmost bottom pixel using a single color [PIXEL PAYLOAD], set both HEIGHT and WIDTH as 0b00000000.
            2 - To draw a line, starting with the pixel in the address [STARTING COLUMN, STARTING LINE] and ending at the [STARTING COLUMN + WIDTH] pixel of that line using a single color [PIXEL PAYLOAD], set HEIGHT to 0b00000000.
            3 - To draw a column, starting with the pixel in the address [STARTING COLUMN, STARTING LINE] and ending at the [STARTING LINE + HEIGHT] pixel of that line using a single color [PIXEL PAYLOAD], set WIDTH to 0b00000000.
            In all the above cases, PIXEL PAYLOAD has a size of one byte.
            
        The VGA instance's memory has a preset data of a 256x256 pixels picture of Pamela Anderson in Baywatch attire.
    
    UART:
        
        The UART instance is able to receive/transmit packets from/to any sources;

        A packet sent by the host computer through the UART to one of the NoC nodes presents the following frame:
        
            | PACKET SIZE | HEADER | PAYLOAD |
            |     32b     |   8b   | m x 8b  |
            
            m = PACKET SIZE - 1
        
        Where:
            PACKET SIZE is the total size of the incoming packet, itself excluded, given in flits. This data is retained on the UART IP and is not propagated through the NoC;
            HEADER is the address of the target NoC node (in this case, 0b00000000 if the processor is the receiver or 0b00000011 if the VGA is);
            PAYLOAD is the relevant data to be transmitted.
        
        A packet sent by one of the IPs in the NoC through the UART to the host computer presents the following frame:
            
            | HEADER | PAYLOAD |
            |   8b   | n x 8b  |
            
            n = Unknown integer representing the total size of the payload.
            
        Where:
            HEADER is the address of the UART NoC node (in this case, 0b00000010). This data is retained on the UART IP and is not propagated to the host computer;
            PAYLOAD is the relevant data to be transmitted.
            Note that there is no PACKET SIZE field in a packet originated inside the NoC. The UART IP will instead wait for an End-Of-Packet (EOP) signal to end the current transmission.
            
        In this project, the UART was configured to use a 115200 baud rate, no parity bit, an 8 bit size data frame and one stop bit;
        To use a differente baud rate, change the value set in the RATE_FREQ_BAUD field of the generic map of the UART instantiation in the "System.vhd" source file;
        The desired new value can be found using the formula: (UART Frequency [Hz] / Baud rate [bit/s]).
        
    APPLICATIONS EXECUTED BY STORM IP:
    
        hello.c
        Destined for the StormCore IP program memory. Writes a small image over the current one and sends a text message to the terminal through the UART.
        Usage: See "makefile".
        
        startup.c
        Included in the StormCore IP program memory as default. Fills the bottom of the screen with a single color and sends a text message to the terminal through the UART.
        Usage: See "makefile".
        
    AUXILIAR PROGRAM:
    
        bmp_to_serial.c
        Program used to convert a BMP image file to a binary UART-compatible file. The resulting .bin is ready to be transmitted by a serial communication tool (e.g. HyperTerminal) 
        Usage: $ bmp_to_serial <file_name>.bmp <file_name>.bin
        
    MAKEFILE:    
        
        makefile
        A makefile is provided to automate some steps. Running the command $ make <file_name>.elf will create several files, explained below.
        Please note that in order to run makefile the user must have installed and added to the PATH system variables the ARM compiler, not provided in this project.
        
        storm_to_serial.c
        Run by the makefile. Will create a binary file "program_uart.bin" containing a new program to the core IP program memory from the file in the argument of makefile.
        This .bin is ready to be transmitted by a serial communication tool.
        Usage: See "makefile".
        
        storm_program.c
        Original program attached to the StormCore project and run by makefile. Generates a modified binary file "storm_program.dat" and a text file "storm_program.txt" from the file in the argument of makefile.
        The contents of the latter can be pasted directly into the memory VHDL file of the IP program memory to change the default program.
        Usage: See "makefile".
____________________________________________________________________________________________________________________________________________________________________________________________________________________

Below are given step-by-steps to simulate, synthesize and program a FPGA to work with this project. Have in mind that they were based in the default programming of the processor IP (see startup.c).
    
# Simulation step-by-step:
    
    1. Open your choice simulation tool and compile all "src" folder files, along with the "SYSTEM_TB.vhd" file present in the "sim" folder;
    2. Find the testbench "system_tb" inside your work library and simulate it;
    3. Navigate the project hierarchy and locate the signals you wish to verify;
    4. In the simulation, two packets will be sent from the processor: one to UART and one to VGA.
    
    Notes:
        * In some simulation tools (e.g. ModelSim), the UNISIM library may not be present as default. In this case, add the library "unisim" included in the "sim" folder of this project;
        * In some simulation tools (e.g. ModelSim), an error may be thrown due to simulation resolution. In this case set it to 1 (one) ps;
        * A TCL script is provided (compile.tcl) in the "sim" folder for an automated first step; 
        * A wave.do file is included in the "sim" folder presenting a selection of relevant signals.
____________________________________________________________________________________________________________________________________________________________________________________________________________________

# Synthesis step-by-step:
    
    1. Open your choice Synthesis tool and create a new project suitable for the FPGA you are using;
    2. Add all the VHDL files contained in the "src" folder and it's subfolders. Add the "bram_pam_256x256.txt" (bitmap) file in the src/VGA/ folder. (arquivo de imagem no mesmo dir do vhdl da memoria)
    3. Adjust the user constraints file (.ucf) to the FPGA you are using. The attached ucf file is already set for the Digilent Nexys 3 board;
    4. Execute the synthesis and design implementation steps (warnings are expected);
    
    Notes:
        * The FPGA used in development was the SPARTAN 6 device XC6SLX16 package CSG324;
        * Keep the bitmap file for the VGA memory start-up in the same folder as the vhdl source files.
____________________________________________________________________________________________________________________________________________________________________________________________________________________

# FPGA use step-by-step (after following the synthesis step-by-step above):
    
    1. Generate the programming file;
    2. Connect the FPGA to a VGA screen and to a computer's serial I/O, and then turn the FPGA on;
    3. Find out which serial communication port was attributed by the computer to the FPGA;
    4. Open your choice serial communication tool in your computer (e.g. HyperTerminal). Currently in this project it is used a 115200 baud rate, no parity bit, 8 data bits, 1 (one) stop bit and no flow control;
    5. Locate the bitstream file and apply the programming process;
    6. After the FPGA start up and programming processes is complete, press the corresponding reset button on the kit. This button was set up in the third step of the synthesis, during UCF adjustments;
    5. A picture corresponding to the text file included during the second step of synthesis should appear on screen;
    7. From here, you can either send a new program to the ARM IP or a new image to the VGA IP.
    
    Notes:
        * A program to be sent to the StormCore IP is provided for testing (hello.c). It behaves transmitting a packet containing an image to the VGA IP and a message through the UART IP to the connected user terminal;
        * An image to be sent to the VGA IP is provided for testing (any 255x255 or lower size 8-color BMP will work). The packet is received in the UART IP and travels through the NoC, replacing the bitmap of the VGA IP memory;
        * To create and test a different program. Follow the pattern shown in the test program given.