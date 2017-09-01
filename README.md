# System_NoC
An Arke NoC implementation featuring StormCore, an ARM-based processor.

# Overview

	This project features the following structure:
	
		A StormCore instance in NoC node #00;
		A VGA driver in node #11;
		An UART serial I/O in node #10;
		An interconnecting ARKE NoC.
		
		*insert visual clue here*
		
		Currently, the UART is capable of both sending image packets to the VGA and/or program packets to the StormCore.
		The processor is able to send data to both the VGA (as image packets) and/or the UART (as text for the user terminal).

# Simulation step-by-step:
	
	1. Open your choice simulation tool and compile all "src" folder files, along with the "SYSTEM_TB.vhd" file present in the "sim" folder.
	2. Find the testbench "system_tb" inside your work library and simulate it.
	3.
	
	Notes:
		* A TCL script is provided (compile.tcl) in the "sim" folder for an automated first step;
		* The preset StormCore program is expected to send data to both UART and VGA nodes.

# Operation:

	1. Adjust the .ucf file for the FPGA you are using.
	2. Connect the FPGA to a VGA screen and to a computer's serial I/O.
	3. Generate the .bit file using ISE and program the FPGA with it.
	4. Starting up, press the corresponding reset button on the kit. A picture should appear on screen.
	5. Open your serial communication tool and configure it to use a 115200 baud rate, no parity bit, 8 data bits and 1 (one) stop bit.
	6. Either:
			- Run the attached StormCore program "hello.c" through makefile. ($ make <file_name>.elf)
			- Run your custom StormCore program through the same step above.
			- Run the "bmp_to_serial" program to convert a .bmp file. ($ bmp_to_serial <file_name>.bmp <file_name>.bin)
	7. And then send the resulting binary file through the serial input.
