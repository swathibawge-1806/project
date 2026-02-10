//implementation of memoru design

module memory1(clk,rst,wr_rd,addr,wdata,rdata,valid,ready);
//declaration of parameters
parameter DEPTH=16;
parameter WIDTH=08;
parameter ADDR_WIDTH= $clog2(DEPTH);

//declaration of input & output ports
input clk,rst,wr_rd,valid;
input [ADDR_WIDTH-1:0]addr;
input [WIDTH-1:0]wdata;
output reg [WIDTH-1:0]rdata;
output reg ready;

//declaration of memory
reg [WIDTH-1:0] mem[DEPTH-1:0];

//internal signals
integer i;

//memory fumctionality

always@(posedge clk)begin
      if (rst==1)begin
	  	rdata=0;
	 	 ready=0; 
	       	for(i=0; i<DEPTH; i=i+1)begin
	         	 mem[i]=0;
	       	end
      end
	  else begin
	    	if (valid==1)begin
	        	ready=1;
		       	if(wr_rd==1)begin
		          	mem[addr] = wdata;
		      	end
		    	else begin
		       		rdata = mem[addr];
	        	end
      		end
		  	else ready=0;
       end
end
endmodule


