vlib work
vlog memory1_tb.v
vsim top +tastcase=test_bd_wr_fd_rd
##add wave -position insertpoint sim:/top/dut/*
do wave.do
run -all
