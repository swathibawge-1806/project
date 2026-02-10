onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/dut/clk
add wave -noupdate /top/dut/rst
add wave -noupdate -expand -group handshake /top/dut/valid
add wave -noupdate -expand -group handshake /top/dut/ready
add wave -noupdate -expand -group datasignals -radix unsigned /top/dut/addr
add wave -noupdate -expand -group datasignals /top/dut/wr_rd
add wave -noupdate -expand -group datasignals -radix unsigned /top/dut/wdata
add wave -noupdate -expand -group datasignals -radix unsigned /top/dut/rdata
add wave -noupdate /top/dut/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {236 ps}
