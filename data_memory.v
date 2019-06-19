module data_memory#(

      parameter Data_Memory_Size ,
		 parameter DATA_ADDR_WIDTH,
	   parameter Data_WIDTH
	  
)(
  
  input [(DATA_ADDR_WIDTH-1):0] addr,   // data address
 input [(Data_WIDTH-1):0] data_in,   // write data
 input [(Data_WIDTH-1):0] operand1,   // operand 1 value
 input [(Data_WIDTH-1):0] operand2,
 input write_en,
 // input [15:0] data_write,
  output [(Data_WIDTH-1):0] data_out   // read data out

);





reg [(Data_WIDTH-1):0] data_mem [0:(Data_Memory_Size-1)];  // data memory array

 
 
 
//initial begin
always @ ( operand1 or operand2) begin   // when either operands change
  
 data_mem[0][(Data_WIDTH-1):0]=16'd0;
 data_mem[1][(Data_WIDTH-1):0]=16'd0;

 data_mem[2][(Data_WIDTH-1):0]=16'd0;
 data_mem[3][(Data_WIDTH-1):0]=16'd0;
 data_mem[4][(Data_WIDTH-1):0]=16'd0;
 data_mem[5][(Data_WIDTH-1):0]=16'd0;
 data_mem[6][(Data_WIDTH-1):0]=16'd0;
 data_mem[7][(Data_WIDTH-1):0]=16'd0;
 data_mem[8][(Data_WIDTH-1):0]=16'd0;

 data_mem[9][(Data_WIDTH-1):0]=operand1;    // save the values of numbers in address 9 and 10
 data_mem[10][(Data_WIDTH-1):0]=operand2;
 data_mem[11][(Data_WIDTH-1):0]=16'd0;
 data_mem[12][(Data_WIDTH-1):0]=16'd0;
 data_mem[13][(Data_WIDTH-1):0]=16'd0;
 data_mem[14][(Data_WIDTH-1):0]=16'd0;
 

 
 end
 




assign data_out=data_mem[addr];  // data read from memory

always @(posedge write_en ) begin  // data write in memory
if(write_en) begin
data_mem[15]=data_in;
end
end

//assign data_mem[addr]=data_write;





endmodule