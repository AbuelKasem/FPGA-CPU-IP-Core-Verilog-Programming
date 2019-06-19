
module code_memory#(
  
     parameter Instruction_WIDTH  ,
	  parameter Instruction_Memory_Size ,
	  parameter Instruction_ADDR_WIDTH,
	  parameter opcode_SIZE
	 // parameter channels = 4,
	 // parameter ADDR_WIDTH = `clog2(Instruction_Memory_Size)
	  

)(
 

 input [(Instruction_ADDR_WIDTH-1):0] addr,   // address of the instruction
 input [(opcode_SIZE-1):0] operator,  // opcode of the operator to be loaded in the memory
 
  output [(Instruction_WIDTH -1):0] instruction_read   // output instruction read by control unit

);



reg [(Instruction_WIDTH -1):0] instr_mem [0:(Instruction_Memory_Size-1)];   // instruction memory

 
// when the operator changes , the assembly program updates the math operation opcode 

 always @ (operator ) begin 

 instr_mem[0][(Instruction_WIDTH -1):( Instruction_WIDTH-opcode_SIZE)]=1;     //load A
 instr_mem[0][7:0]=12'd9;   // operand 1 data memory address 9
 

 instr_mem[1][(Instruction_WIDTH -1):( Instruction_WIDTH-opcode_SIZE)]=2;     //load B	
 instr_mem[1][7:0]=12'd10;  // operand 2 data memory address 10
 

 instr_mem[2][(Instruction_WIDTH -1):( Instruction_WIDTH-opcode_SIZE)]=operator;  //operator  ( based on operator opcode this instruction is either (ADD,SUB,MUL or DIV)
 instr_mem[2][7:0]=12'd1;    
 
 instr_mem[3][(Instruction_WIDTH -1):( Instruction_WIDTH-opcode_SIZE)]=3;        // Store register C into 
 instr_mem[3][7:0]=12'd1;    // address 1 in the data memory
 
 instr_mem[4][(Instruction_WIDTH -1):( Instruction_WIDTH-opcode_SIZE)]=8;
 //instr_mem[4][15:12]=4;
 instr_mem[4][7:0]=12'd0;
 
 instr_mem[5][(Instruction_WIDTH -1):( Instruction_WIDTH-opcode_SIZE)]=0;
 instr_mem[5][7:0]=12'd0;
 
 instr_mem[6][(Instruction_WIDTH -1):( Instruction_WIDTH-opcode_SIZE)]=0;
 instr_mem[6][7:0]=12'd0;
 
 instr_mem[7][(Instruction_WIDTH -1):( Instruction_WIDTH-opcode_SIZE)]=0;
 instr_mem[7][7:0]=12'd0;
 
 instr_mem[8][(Instruction_WIDTH -1):( Instruction_WIDTH-opcode_SIZE)]=0;
 instr_mem[8][7:0]=12'd0;

 instr_mem[9][(Instruction_WIDTH -1):( Instruction_WIDTH-opcode_SIZE)]=0;
 instr_mem[9][7:0]=12'd5;
 
 instr_mem[10][(Instruction_WIDTH -1):( Instruction_WIDTH-opcode_SIZE)]=0;
 instr_mem[10][7:0]=12'd3;
 

instr_mem[9][(Instruction_WIDTH -1):0]=0;
 instr_mem[10][(Instruction_WIDTH -1):0]=0;
 instr_mem[11][(Instruction_WIDTH -1):0]=0;
 instr_mem[12][(Instruction_WIDTH -1):0]=0;
 instr_mem[13][(Instruction_WIDTH -1):0]=0;
 instr_mem[14][(Instruction_WIDTH -1):0]=0;
 instr_mem[15][(Instruction_WIDTH -1):0]=0;

 
 end
 




assign instruction_read=instr_mem[addr];    // output the instruction at address (addr) 






endmodule