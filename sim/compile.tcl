# Sets the compiler
set compiler vcom

# Creates the work library if it does not exist
if { ![file exist work] } {
	vlib work
}

# Source files listed in hierarchical order: bottom -> top

set sourceFiles {

	../src/Arke/Arke_pkg.vhd
	../src/Arke/Crossbar.vhd
	../src/Arke/InputBuffer.vhd
	../src/Arke/ProgramablePriorityEncoder.vhd
	../src/Arke/Router.vhd
	../src/Arke/SwitchControl.vhd
	../src/Arke/NoC.vhd
	
	../src/StormIP/StormCore/CORE_PKG.vhd
	../src/StormIP/StormCore/ALU.vhd
	../src/StormIP/StormCore/BARREL_SHIFTER.vhd
	../src/StormIP/StormCore/BUS_UNIT.vhd
	../src/StormIP/StormCore/CACHE.vhd
	../src/StormIP/StormCore/CORE.vhd
	../src/StormIP/StormCore/FLOW_CTRL.vhd
	../src/StormIP/StormCore/LOAD_STORE_UNIT.vhd
	../src/StormIP/StormCore/MC_SYS.vhd
	../src/StormIP/StormCore/MS_UNIT.vhd
	../src/StormIP/StormCore/MULTIPLY_UNIT.vhd
	../src/StormIP/StormCore/OPCODE_DECODER.vhd
	../src/StormIP/StormCore/OPERAND_UNIT.vhd
	../src/StormIP/StormCore/REG_FILE.vhd
	../src/StormIP/StormCore/WB_UNIT.vhd
	../src/StormIP/StormCore/STORM_TOP.vhd
	
	../src/StormIP/GP_IO_CTRL.vhd
	../src/StormIP/MEMORY.vhd
	../src/StormIP/Synchronizer.vhd
	../src/StormIP/STORM_IP.vhd
	
	../src/DisplayIP/DataManager.vhd
	../src/DisplayIP/DISPLAY.vhd
	
	../src/VgaIP/Util_package.vhd
	../src/VgaIP/VMemory.vhd
	../src/VgaIP/VGA_Controller/VGA_Controller.vhd
	../src/VgaIP/VGA_test.vhd
	
	../src/UartIP/UART_TX.vhd
	../src/UartIP/UART_RX.vhd
	../src/UartIP/UART_Terminal.vhd
	
	../src/clk_div.vhd
	../src/System.vhd
	
	SYSTEM_TB.vhd
	}

set top SYSTEM_TB

if { [llength $sourceFiles] > 0 } {
	
	foreach file $sourceFiles {
		if [ catch {$compiler $file} ] {
			puts "\n*** ERROR compiling file $file :( ***" 
			return;
		}
	}
}

if { [llength $sourceFiles] > 0 } {
	
	puts "\n*** Compiled files:"  
	
	foreach file $sourceFiles {
		puts \t$file
	}
}

puts "\n*** Compilation OK ;) ***"

set StdArithNoWarnings 1