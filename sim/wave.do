onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /system_tb/system_inst/clk_div_inst/clk_in
add wave -noupdate -format Logic /system_tb/system_inst/clk_div_inst/clk_50mhz
add wave -noupdate -format Logic /system_tb/rst_s
add wave -noupdate -expand -group {ARM IP}
add wave -noupdate -group {ARM IP} -format Literal -radix hexadecimal /system_tb/system_inst/storm_ip_inst/data_out
add wave -noupdate -group {ARM IP} -format Literal -radix hexadecimal /system_tb/system_inst/storm_ip_inst/control_out
add wave -noupdate -expand -group {VGA IP}
add wave -noupdate -group {VGA IP} -format Literal -radix hexadecimal /system_tb/system_inst/vga_inst/data_in
add wave -noupdate -group {VGA IP} -format Literal -radix hexadecimal /system_tb/system_inst/vga_inst/control_in
add wave -noupdate -expand -group {UART IP}
add wave -noupdate -group {UART IP} -format Literal -radix hexadecimal /system_tb/system_inst/serial_inst/data_in
add wave -noupdate -group {UART IP} -format Literal -radix hexadecimal /system_tb/system_inst/serial_inst/control_in
add wave -noupdate -group {UART IP} -format Literal -radix hexadecimal /system_tb/system_inst/serial_inst/control_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15265610 ps} 0}
configure wave -namecolwidth 153
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 1
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {210 us}
