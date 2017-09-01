# System_NoC
An Arke NoC implementation featuring StormCore, an ARM-based processor.

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
