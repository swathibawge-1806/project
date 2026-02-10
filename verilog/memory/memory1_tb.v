//implementation of test bench

`include "memory1.v"
`define PRINT 1
module top;

parameter DEPTH=16;
parameter WIDTH=16;
parameter ADDR_WIDTH= $clog2(DEPTH);

//declaration of input & output ports
reg clk,rst,wr_rd,valid;
reg [ADDR_WIDTH-1:0]addr;
reg [WIDTH-1:0]wdata;
wire [WIDTH-1:0]rdata;
wire ready;
integer i;
reg[25*8:0]testname;

memory1 #(.DEPTH(DEPTH),.WIDTH(WIDTH)) dut(
                                         .clk   (clk),
                                         .rst   (rst),
                                         .wr_rd (wr_rd),
                                         .addr  (addr),
                                         .wdata (wdata),
                                         .rdata (rdata),
                                         .valid (valid),
                                         .ready (ready));
//clock generation
 initial begin
   clk =0;
   forever #5 clk=~clk;
   end
//finishing the simmulation
   initial begin
   		reset_mem();
		$value$plusargs("testcase=%s",testname);
		$display("===========================================");
		$display("the passing testcase name is =%0s",testname);
		$display("===========================================");

		case(testname)
			"test_5wr_5rd":begin
			write_mem(0,5);
			read_mem(0,5);
			end
			"test_5writes":begin
			write_mem(0,5);
			end
			"test_1wr_1rd":begin
				write_mem(0,1);
				read_mem(0,1);
			end
            "test_5wr_3rd":begin
					write_mem(0,5);
			read_mem(0,3);
			end
			"test_wr_rd":begin
				write_mem(0,DEPTH);
				read_mem(0,DEPTH);
			end
			"test_full_portion":begin
				write_mem(0,4*(DEPTH/4));
				read_mem(0,4*(DEPTH/4));
			end
			"test_half_portion":begin
				write_mem(0,2*(DEPTH/4));
				read_mem(0,2*(DEPTH/4));
			end
			"test_3/4_portion":begin
				write_mem(0,3*(DEPTH/4));
				read_mem(0,3*(DEPTH/4));
			end
			"test_1/4_portion":begin
				write_mem(0,1*(DEPTH/4));
				read_mem(0,1*(DEPTH/4));
			end
			"test_4th_portion":begin
				write_mem(3*(DEPTH/4),4*(DEPTH/4));
				read_mem(3*(DEPTH/4),4*(DEPTH/4));
			end
			"test_3rd_portion":begin
				write_mem(DEPTH/2,3*(DEPTH/4));
				read_mem(DEPTH/2,3*(DEPTH/4));
			end
			"test_2nd_portion":begin
				write_mem(DEPTH/4,2*(DEPTH/4));
				read_mem(DEPTH/4,2*(DEPTH/4));
			end
			"test_1st_portion":begin
				write_mem(0,1*(DEPTH/4));
				read_mem(0,1*(DEPTH/4));
			end
			"test_bd_wr_bd_rd":begin
				mem_bd_write();
				mem_bd_read();
			end
			"test_bd_wr_fd_rd":begin
				mem_bd_write();
				read_mem(0,DEPTH);
			end
			"test_fd_wr_bd_rd":begin
				write_mem(0,DEPTH);
				mem_bd_read();
			end
			"test_fd_wr_fd_rd":begin
				write_mem(0,DEPTH);
				read_mem(0,DEPTH);
			end
		endcase
		#100;
		$finish();
	end

//apply and realease reset(reset using task)
     task reset_mem();
	 	begin
	 		rst  =1;
			wr_rd=0;
			addr =0;
			wdata=0;
			valid=0;
	 		repeat(2)@(posedge clk);
	 		rst  =0;
	 	end
	 endtask
//implementation of memory write task
	task write_mem(input integer start_loc,input integer end_loc);
		begin
		if(`PRINT==1)$display("--------------write operation------------");
		for(i=start_loc; i<end_loc; i=i+1)begin
			@(posedge clk);
			valid=1;
			wait(ready==1);
			wr_rd=1;
			addr =i;//i=0,1,2........DEPTH locations
			wdata=$random;
		if(`PRINT==1)$display("address=%0d || write_data=%0d",addr,wdata);
			//wait(ready==1);
		end
			@(posedge clk);
			valid=0;
			wr_rd=0;
			addr =0;
			wdata=0;
		end
	endtask
//memory read task
	task read_mem(input integer start_loc,input integer end_loc);
		begin
		if(`PRINT==1)$display("--------------read operation------------");

		for(i=start_loc; i<end_loc; i=i+1)begin
			@(posedge clk);
			valid=1;
			wait(ready==1);
			wr_rd=0;
			addr =i;
			#1;
		
		if(`PRINT==1)$display("address=%0d || read data=%0d",addr,rdata);
			//wait(ready==1);
		end
			@(posedge clk);
			valid=0;
			wr_rd=0;
			addr =0;
		end
	endtask
//memory_backdoor_acces
task mem_bd_write();
	begin
	$display("------back_door_write_task------");
	$readmemh("data.hex",dut.mem);
	end
endtask
task mem_bd_read();
	begin
	$display("------back_door_read_task--------");
	$writememb("output.bin",dut.mem);
	end
endtask
endmodule
