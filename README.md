# System_NoC
An Arke NoC implementation featuring StormCore, an ARM-based processor.

# Overview

	This project features the following structure:
	
		A StormCore instance in NoC node #00;
		A VGA driver in node #11;
		An UART serial I/O in node #10;
		An interconnecting ARKE NoC.
		
		
		OOOOOOOO                    OOOOOOOO
		O      O                    O      O
		O      O                    O VGA  O
		O      O                    O      O
		OOOOOOOO                    OOOOOOOO
               \                    /
               NoC ============== NoC			   
                ||                ||	   
                ||                ||
                ||      2x2       ||
                ||      NoC       ||
                ||                ||
                ||                ||
               NoC ============== NoC
               /                    \
		OOOOOOOO                    OOOOOOOO
		O      O                    O      O
		O  SC  O                    O UART O
		O      O                    O      O
		OOOOOOOO                    OOOOOOOO

		
		Currently, the UART is capable of both sending image packets to the VGA and/or program packets to the StormCore.
		The processor is able to send data to both VGA as image packets  and/or UART as text for the user terminal.
		
# Operation
	
	The StormCore instance starts off with a simple program designed to send packets to the VGA instance and the UART instance.
	Packets that go in the NoC have a flit size of 8 bits. 

# Simulation step-by-step:
	
	1. Open your choice simulation tool and compile all "src" folder files, along with the "SYSTEM_TB.vhd" file present in the "sim" folder. *********
	2. Find the testbench "system_tb" inside your work library and simulate it.
	3. Navigate the project hierarchy and locate the signals you wish to verify.
	****
	4. In simulation, two packets will be sent from the processor: one to UART and one to VGA.
	
	Notes:
		* A TCL script is provided (compile.tcl) in the "sim" folder for an automated first step; 
		* The preset StormCore program is expected to send data to both UART and VGA nodes.

# Synthesis step-by-step:
	
	1. Open ISE Design Suite and create a new project suitable for the FPGA you are using. The FPGA used in development was the SPARTAN 6 device XC6SLX16 package CSG324.
	2. Navigate to the Design tab. Right click on the project hierarchy area and choose the option "Add Source".
	3. Add all the VHDL files contained in the "src" folder and it's subfolders. Add the "bram_pam_256x256.txt" file in the src/VGA/ folder.
	4. Adjust the user constraints file (.ucf) to the FPGA you are using.
	5. Navigate in the hierarchy to the "SYSTEM - Structure" tab and click it. Below the project hierarchy a number of itens should appear.
	6. To execute the synthesis and design implementation, simply double-click the desired item in the window below the project hierarchy.
	7. After each step resolution, a '!' sign should replace the void space (as the step was completed successfully, but warnings were given).
	
			- Run the attached StormCore program "hello.c" through makefile. ($ make <file_name>.elf)
			- Run your custom StormCore program through the same step above.
			- Run the "bmp_to_serial" program to convert a .bmp file. ($ bmp_to_serial <file_name>.bmp <file_name>.bin)

# FPGA use step-by-step (following the synthesis step-by-step above):
	
	1. Generate the programming file by double-clicking "Generate Programming File". After completion, a bitstream file (<project_name>.bit) will be created in the project directory.
	2. Connect the FPGA to a VGA screen and to a computer's serial I/O, and then turn the FPGA on.
	3. Locate the bitstream file and apply the programming process (using a provided tool like Digilent Adept or another method like a flash drive).
	4. After the FPGA start up and programming processes, press the corresponding reset button on the kit.
	5. A picture corresponding to the text file included during synthesis should appear on screen. This file image is pre-loaded in the VGA memory.

	# Interacting with the programmed system step-by-step:
	
		1. Find out which serial communication port was attributed by the computer to the FPGA.
		2. Open your serial communication tool in your computer. Configure it to use a 115200 baud rate, no parity bit, 8 data bits and 1 (one) stop bit.
		3. Run the "hello.c" file through makefile ($ make <file_name>.elf).
		4. Using your serial communication tool, send the resulting file (program_uart.bin) as a text file.
   
	