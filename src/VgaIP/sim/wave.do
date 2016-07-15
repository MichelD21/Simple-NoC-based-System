onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix decimal /vga_test_tb/uut/clk
add wave -noupdate -format Logic -radix decimal /vga_test_tb/uut/rst
add wave -noupdate -format Literal -radix decimal /vga_test_tb/uut/vga_ctrl/horizontalcounter
add wave -noupdate -format Literal -radix hexadecimal /vga_test_tb/uut/rgb
add wave -noupdate -format Logic -radix decimal /vga_test_tb/uut/hsync
add wave -noupdate -format Logic -radix decimal /vga_test_tb/uut/vsync
add wave -noupdate -format Literal -radix unsigned /vga_test_tb/uut/column
add wave -noupdate -format Literal -radix decimal /vga_test_tb/uut/line
add wave -noupdate -format Literal -radix decimal /vga_test_tb/uut/memoryaddress
add wave -noupdate -format Literal -radix hexadecimal /vga_test_tb/uut/pixel
add wave -noupdate -format Logic -radix decimal /vga_test_tb/uut/visiblearea
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1023403 ns} 0}
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
WaveRestoreZoom {1022840 ns} {1023840 ns}
