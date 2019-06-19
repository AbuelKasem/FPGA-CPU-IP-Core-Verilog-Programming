
`define clog2(x) ( \
 ((x) <= 2) ? 1 : \
 ((x) <= 4) ? 2 : \
 ((x) <= 8) ? 3 : \
 ((x) <= 16) ? 4 : \
 ((x) <= 32) ? 5 : \
 ((x) <= 64) ? 6 : \
 ((x) <= 128) ? 7 : \
 ((x) <= 256) ? 8 : \
 ((x) <= 512) ? 9 : \
 ((x) <= 1024) ? 10 : \
 ((x) <= 2048) ? 11 : \
 ((x) <= 4096) ? 12 : 16)

module control_unit_v33 #(

    parameter Instruction_WIDTH   ,    
	 parameter Instruction_Memory_Size  ,
		
	 parameter Instruction_ADDR_WIDTH = `clog2(Instruction_Memory_Size),
	 parameter opcode_SIZE,
	 parameter Data_WIDTH,
	 parameter Data_Memory_Size ,
	 parameter DATA_ADDR_WIDTH=`clog2(Data_Memory_Size)	 

)(
    input clock, 
    input reset_bt,  // reset everything to zero values
	 input CU_enable,  // enable the state machine to execute the program
	 input [7:0] operand1,  // first operand
	 input [7:0] operand2,
	 input [(opcode_SIZE-1):0] operator,  // the opcode of the math operation
    output reg [(Instruction_WIDTH-1):0] inst_reg,   // the instruction register
	 
    output reg done,                               // output flag to the 3rd LED indicate when program finish execution
	 output reg [(Data_WIDTH-1):0] A,    // General purpose registers A,B and C
    output reg [(Data_WIDTH-1):0] B,
    output reg [(Data_WIDTH-1):0] C,
	 output   reg   clk_count_sec,     // slower generated clock for test purposes
	 output reg [1:0] state,            // the state machine variable

	 output reg [7:0] ram_address,    
	 
	 output [(Data_WIDTH-1):0] cu_output  // control unit output from ALU

); 




reg  write_en;   // memory control signals
reg   read_en;
wire [(Data_WIDTH-1):0] read_data;   // data read from data memory
reg  [(Data_WIDTH-1):0] write_data;   // data written to the data memory
wire  [(Instruction_WIDTH-1):0] read_inst;  // instruction read from the code memory

	 
reg cu_en;
reg    [31:0] clk_count;

//State-Machine Registers
//reg [1:0] state;
reg [(Instruction_ADDR_WIDTH-1):0] inst_addr; // the instruction address register
reg [(DATA_ADDR_WIDTH-1):0] data_addr;    // local variables to hold memory addresses
reg [(Instruction_WIDTH-1):0] code_address;
reg [(DATA_ADDR_WIDTH-1):0] data_address;



//reg [(Data_WIDTH-1):0] D;
reg [(opcode_SIZE-1):0] opcode;   //opcode variable from decode state
reg [3:0]  cycle_cnt;

reg [(opcode_SIZE-1):0] op;    // operation passed to ALU
wire [(Data_WIDTH-1):0] ALU_output;   // result of ALU calculations



assign cu_output=ALU_output;
reg ALU_on_flag;
reg ALU_en ;


//Local Parameters used to define state names 
localparam reset = 2'b00;
localparam fetch = 2'b01;
localparam decode = 2'b10;
localparam execute = 2'b11;

localparam assembly_ins_length = 8'd4;  // the length of the test assembly programs

always @ (posedge clock)  begin  // generating slower clock for test purposes


   if (clk_count< 32'd5000) begin
         clk_count=clk_count+32'd1;
		
		end
	else begin

             clk_count=32'd0;
    end
    if (clk_count<32'd2500) begin
         clk_count_sec=1'b0;
		
	  end
	  else begin

        clk_count_sec=1'b1;
     end
 end
always @ * begin
cu_en =CU_enable;

end




//the state machine is executed in this block  , it runs through 4 states ,
//1-reset all regestiers to zero  go to >>fetch
//2-fetch instructions from the code memory go to >>decode
//3-decode the fetched assembly instruction into opcode and operands  go to >>execute
//4-execute the instruction based on  the opcode , and increment the instruction
//address register, go to >>fetch 

always @(posedge clock ) begin

	 cycle_cnt=cycle_cnt+4'd1;  // processor clock cycles counter 
	 
if (reset_bt ) begin         
state = reset;
inst_addr =8'd0;
cycle_cnt=4'd0;
				ram_address = inst_addr; 
				inst_reg = 0;
				A=0;
				B=0;
				C=0;
				
				done = 1'b0;
				read_en = 1'b0;
		      write_en = 1'b0;

end	 	 
	 
 if( cu_en &&  !done) begin	 
	
      case (state)
	 
			reset: begin //1-reset all regestiers to zero  go to >>fetch
			
				inst_addr =0; 
				inst_reg = 0;
				A=0;
				B=0;
				C=0;
				
				cycle_cnt=4'd0;
				done = 1'b0;
				read_en = 1'b0;
		      write_en = 1'b0;
				state = fetch;
			end
		
         fetch: begin   //2-fetch instructions from the code memory go to >>decode
			
				cycle_cnt=4'd0;
			   code_address = inst_addr; 
			   inst_reg = read_inst;
				state = decode;
				
         end
		  
		    
        decode: begin      //3-decode the fetched assembly instruction into opcode and operands  go to >>execute
		      read_en = 1'b0;
		      write_en = 1'b0;
			   opcode = inst_reg[( Instruction_WIDTH-1):( Instruction_WIDTH-opcode_SIZE)]; // opcode
			     
			   data_addr= inst_reg[7:0];  //operands
			   state = execute;
        end
		  
		    
        execute: begin //4-execute the instruction based on the case conditon of the opcode , and increment the instruction

				
				
				if (opcode==1) begin  // load A
				
				data_address =inst_reg[7:0];
				read_en = 1'b1;
				write_en = 1'b0;
				ALU_en =1'b0;  
				A=read_data[(Data_WIDTH-1):0];
				
				end
				
				else if (opcode==2)  begin   // load B
				data_address =inst_reg[7:0];
				read_en = 1'b1;
				write_en = 1'b0;
				ALU_en =1'b0;  
				B=read_data[(Data_WIDTH-1):0];
				end
				
				else if (opcode==3) begin   // store C
				
				data_address =data_addr;
				read_en = 1'b0;
				write_en = 1'b1;
				ALU_en =1'b0;  
			  //store from C to ram;
				write_data=C;  
				end
				
				else if (opcode==4) begin  // ADD
				
				read_en = 1'b0;
				write_en = 1'b0;
				ALU_en =1'b1;   
				op = 1;  //ADD to ALU
				C=ALU_output;
				end
				
				
				else if (opcode==5) begin //SUB
				read_en = 1'b0;
				write_en = 1'b0;
				ALU_en =1'b1;   
				op = 2;
				C=ALU_output;
				end
				
				
				else if (opcode==6) begin   //MUL
				read_en = 1'b0;
				write_en = 1'b0;
				ALU_en =1'b1;   //mult
				op = 3;
				C=ALU_output;
				end
				
				
				else if (opcode==7) begin   //DIV
				read_en = 1'b0;
				write_en = 1'b0;
				ALU_en =1'b1;   //div
				op = 4;
				C=ALU_output;
				end
				
				
				else if (opcode==8) begin //HLT
				read_en = 1'b0;
				write_en = 1'b0;
				ALU_en =1'b0;   //halt
				op <= 0;
				done = 1'b1;
				end
				
			
				if( cycle_cnt==4'd3) begin
				         if(inst_addr < assembly_ins_length) begin
			
				             inst_addr = inst_addr+1;
				               state = fetch;
							end
			    			else begin
			                     done = 1'b1;
							end
								
						  
			end	 
			else begin
				 state = execute;
			end
         
			
		end
		  
		  
    endcase
  end
  end


// code memory instance to read the instruction 
 code_memory  #(
  
     .Instruction_WIDTH (Instruction_WIDTH),
	  .Instruction_Memory_Size (Instruction_Memory_Size),
	  .Instruction_ADDR_WIDTH(Instruction_ADDR_WIDTH),
	  .opcode_SIZE(opcode_SIZE)
	  
)
 is1(
 
   .addr ( inst_addr),
	
    .operator(operator),
	.instruction_read ( read_inst )
	
);


// data memory instance to read and write the data
data_memory  #(
  
     .Data_WIDTH (Data_WIDTH),
	  .Data_Memory_Size (Data_Memory_Size),
	  .DATA_ADDR_WIDTH(DATA_ADDR_WIDTH)
	  
)mem(
  
   .addr ( data_address),
	.write_en(write_en),
	.data_in(write_data),
	.operand1(operand1),
	.operand2(operand2),
	.data_out ( read_data )

);

// ALU instance to pass registers values and the required math or logic operation
 ALU   #(
  
      .opcode_SIZE(opcode_SIZE),
		.Data_WIDTH(Data_WIDTH)
	
	  

)alu1(
   
	.A(A), 
   .B(B), 
	.Cin(1'b0), 
	.select(op),  // opcode
	.enable(ALU_en),
	.answer(ALU_output)
	

);


endmodule
