onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Output from NOC}
add wave -noupdate -format Logic /system_tb/clk_s
add wave -noupdate -format Logic /system_tb/system_inst/vga_inst/clock_divider/clk_25mhz
add wave -noupdate -format Logic /system_tb/rst_s
add wave -noupdate -divider {Output from SC}
add wave -noupdate -divider {Node 00}
add wave -noupdate -format Literal -radix hexadecimal /system_tb/system_inst/noc_inst/mesh_2d/z_coord__0/y_coord__0/x_coord__0/botton_left_corner/router_xyz/data_in(0)
add wave -noupdate -format Literal /system_tb/system_inst/noc_inst/mesh_2d/z_coord__0/y_coord__0/x_coord__0/botton_left_corner/router_xyz/control_in(0)
add wave -noupdate -format Literal -radix hexadecimal /system_tb/system_inst/noc_inst/mesh_2d/z_coord__0/y_coord__0/x_coord__0/botton_left_corner/router_xyz/data_out
add wave -noupdate -divider {Node 10}
add wave -noupdate -format Literal -radix hexadecimal /system_tb/system_inst/noc_inst/mesh_2d/z_coord__0/y_coord__0/x_coord__1/botton_right_corner/router_xyz/data_out
add wave -noupdate -divider {Node 01}
add wave -noupdate -format Literal -radix hexadecimal /system_tb/system_inst/noc_inst/mesh_2d/z_coord__0/y_coord__1/x_coord__0/top_left_corner/router_xyz/data_out
add wave -noupdate -divider {Node 11}
add wave -noupdate -format Literal -radix hexadecimal /system_tb/system_inst/noc_inst/mesh_2d/z_coord__0/y_coord__1/x_coord__1/top_right_corner/router_xyz/data_out
add wave -noupdate -divider VGA
add wave -noupdate -format Literal -radix hexadecimal /system_tb/system_inst/vga_inst/pixel
add wave -noupdate -format Literal -radix hexadecimal /system_tb/system_inst/vga_inst/memoryaddress
add wave -noupdate -format Logic /system_tb/system_inst/vga_inst/visiblearea_s
add wave -noupdate -format Logic /system_tb/system_inst/vga_inst/write_enable
add wave -noupdate -format Logic /system_tb/system_inst/vga_inst/stall_go
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {17 ns} 0}
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
WaveRestoreZoom {0 ns} {58 ns}
