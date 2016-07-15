onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group vga
add wave -noupdate -group vga -format Logic -radix hexadecimal /system_tb/system_inst/vga_inst/clk
add wave -noupdate -group vga -format Logic -radix hexadecimal /system_tb/system_inst/vga_inst/rst
add wave -noupdate -group vga -format Literal -radix hexadecimal /system_tb/system_inst/vga_inst/data_in
add wave -noupdate -group vga -format Literal -radix hexadecimal /system_tb/system_inst/vga_inst/control_in
add wave -noupdate -group vga -format Literal -radix hexadecimal /system_tb/system_inst/vga_inst/data_out
add wave -noupdate -group vga -format Literal -radix hexadecimal /system_tb/system_inst/vga_inst/control_out
add wave -noupdate -group vga -format Literal -radix hexadecimal /system_tb/system_inst/vga_inst/column
add wave -noupdate -group vga -format Literal -radix hexadecimal /system_tb/system_inst/vga_inst/line
add wave -noupdate -group vga -format Literal -radix hexadecimal /system_tb/system_inst/vga_inst/memoryaddress
add wave -noupdate -group vga -format Literal -radix hexadecimal /system_tb/system_inst/vga_inst/pixel
add wave -noupdate -group vga -format Literal -radix hexadecimal /system_tb/system_inst/vga_inst/rgb
add wave -noupdate -group vga -format Literal -radix hexadecimal /system_tb/system_inst/vga_inst/from_noc_line
add wave -noupdate -group vga -format Literal -radix hexadecimal /system_tb/system_inst/vga_inst/from_noc_column
add wave -noupdate -group vga -format Literal -radix hexadecimal /system_tb/system_inst/vga_inst/from_noc_pixel
add wave -noupdate -group vga -format Logic -radix hexadecimal /system_tb/system_inst/vga_inst/visiblearea_s
add wave -noupdate -group vga -format Logic -radix hexadecimal /system_tb/system_inst/vga_inst/write_enable
add wave -noupdate -group vga -format Logic -radix hexadecimal /system_tb/system_inst/vga_inst/clk_25mhz
add wave -noupdate -group vga -format Literal -radix hexadecimal /system_tb/system_inst/vga_inst/state
add wave -noupdate -expand -group {core local node}
add wave -noupdate -group {core local node} -format Literal -radix hexadecimal /system_tb/system_inst/noc_inst/mesh_2d/z_coord__0/y_coord__0/x_coord__0/botton_left_corner/router_xyz/portbuffers__0/input_buffer/data_in
add wave -noupdate -group {core local node} -format Literal -radix hexadecimal /system_tb/system_inst/noc_inst/mesh_2d/z_coord__0/y_coord__0/x_coord__0/botton_left_corner/router_xyz/portbuffers__0/input_buffer/control_in
add wave -noupdate -group {core local node} -format Literal -radix hexadecimal /system_tb/system_inst/noc_inst/mesh_2d/z_coord__0/y_coord__0/x_coord__0/botton_left_corner/router_xyz/portbuffers__0/input_buffer/data_out
add wave -noupdate -group {core local node} -format Literal -radix hexadecimal /system_tb/system_inst/noc_inst/mesh_2d/z_coord__0/y_coord__0/x_coord__0/botton_left_corner/router_xyz/portbuffers__0/input_buffer/control_out
add wave -noupdate -group {core local node} -format Literal -radix hexadecimal /system_tb/system_inst/noc_inst/mesh_2d/z_coord__0/y_coord__0/x_coord__0/botton_left_corner/router_xyz/portbuffers__0/input_buffer/currentstate
add wave -noupdate -group {core local node} -format Literal -radix hexadecimal /system_tb/system_inst/noc_inst/mesh_2d/z_coord__0/y_coord__0/x_coord__0/botton_left_corner/router_xyz/portbuffers__0/input_buffer/first
add wave -noupdate -group {core local node} -format Literal -radix hexadecimal /system_tb/system_inst/noc_inst/mesh_2d/z_coord__0/y_coord__0/x_coord__0/botton_left_corner/router_xyz/portbuffers__0/input_buffer/queue
add wave -noupdate -group {core local node} -format Literal -radix hexadecimal /system_tb/system_inst/noc_inst/mesh_2d/z_coord__0/y_coord__0/x_coord__0/botton_left_corner/router_xyz/portbuffers__0/input_buffer/last
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {199859 ns} 0}
configure wave -namecolwidth 150
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
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {199826 ns} {200010 ns}
