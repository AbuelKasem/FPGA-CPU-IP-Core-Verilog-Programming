// instruction set opcodes encoding
`define BRA 0    //(4’b0000)         // branch 
`define LD_A 1   //4’b0001           // load memory address data into register A
`define LD_B 2 //4’b0010             // load memory address data into register B
`define STR 3 //4’b0011              // store data from register C into a memory address

`define ADD 4    //’b0100           // Addition of register A + B  and save the result in register C 
`define SUB 5   //4’b0110           // subtraaction of register A - B  and save the result in register C 
`define MUL 6 //4’b0101            // multiplication of register A * B  and save the result in register C 

`define DIV 7 // 4’b0111           // division of register A / B  and save the result in register C 
`define HLT 8   //4’b1000          // halt
`define OR 9    //4’b1001 
`define AND 10    //4’b1001        // c=A & B

`define plus 1  //8’d1
`define minus 2  // 8’d2
`define multiply 3 //8’d3
`define or_sign 4   //8’d4
`define ampersend 5    //8’d5

module Assembler_v2#(
   parameter opcode_SIZE

)(

input assembler_enable,   // start converting math operation to assembly
input clock,              

input [7:0] operand_1,    // first number from keyboard
input [7:0] operator,      //  // math operator code + ,- , * , /
input [7:0] operand_2,       // 2nd number from keyboard
output [15:0] assembler_out,  // output instructions of the assembler
output reg [(opcode_SIZE-1):0] opcode,      // the opcode of the math instruction 
output [15:0] assembler_mem_address    // the memory address of each instruction to be written

); 
 
 
  reg [15:0] instructions[0:15];  // instructions array  initialized with the instruction set
  reg [15:0] program_assembly[0:20];  // temporary array for storing the generated assembly instructions
  
   reg write_en;                      // write enable instruction signal
  reg [7:0]  inst_addr;               //  address of each instruction 
 

 assign assembler_mem_address = inst_addr;   // storing the generated address of each instruction 
 
 
 
 
 
 //  this block initialize the instruction addresss to zero and the array of inctruction set  to the opcode and operands 
 // of each instruction
initial begin                    
  inst_addr=8'd0;                     
  write_en=1'b0;

 instructions[0][15:12]=`BRA;
 instructions[0][11:0]=12'd0;
 

 instructions[1][15:12]=`LD_A;
 instructions[1][11:0]=12'd9;  // operand 1 address in ram
 
 instructions[2][15:12]=`LD_B;
 instructions[2][11:0]=12'd10;    // operand 2 address in ram
 
 instructions[3][15:12]=`STR;
 instructions[3][11:0]=12'd15;    // result  write addres in ram
 
 instructions[4][15:12]=`ADD;

 instructions[4][11:0]=12'd1;
 
 instructions[5][15:12]=`MUL;
 instructions[5][11:0]=12'd3;
 
 instructions[6][15:12]=`SUB;
 instructions[6][11:0]=12'd2;
 
 instructions[7][15:12]=`AND;
 instructions[7][11:0]=12'd0;
 
 instructions[8][15:12]=`HLT;
 instructions[8][11:0]=12'd5;
 
 instructions[9][15:12]=`OR;
 instructions[9][11:0]=12'd0;
 
 instructions[10][15:12]=`DIV;
 instructions[10][11:0]=12'd0;
 

 instructions[11][15:0]=16'd0;
 instructions[12][15:0]=16'd0;
 instructions[13][15:0]=16'd0;
 instructions[14][15:0]=16'd0;
 instructions[15][15:0]=16'd0;
 /*
 program_assembly[0]=0;  
 program_assembly[1]=0;  
 program_assembly[2]=0;  
 program_assembly[3]=0;  
 program_assembly[4]=0;
 program_assembly[5]=0;  
 program_assembly[6]=0;  
 program_assembly[7]=0;  
 program_assembly[8]=0;  
 program_assembly[9]=0;
 program_assembly[10]=0;
 program_assembly[11]=0;
 program_assembly[12]=0;
 program_assembly[13]=0;
 program_assembly[14]=0;
 program_assembly[15]=0;
 */
 end

// this block is assigning the assembly instruction needed for each math operation into the program array based on the 
// entered operator , according to a case condition  on the code of each operator from the keyboard

 
 
always @ (operator) begin  

case (operator) 
8'd20:  begin         // + code
       opcode=4;
      program_assembly[0]=instructions[1];  // ld_a
      program_assembly[1]=instructions[2];  // ld_b
		program_assembly[2]=instructions[4];  // add
      program_assembly[3]=instructions[3];  // store
      program_assembly[4]=instructions[8];  // hlt
		//program_assembly[10]=operand_1;
		//program_assembly[11]=operand_2;
		end
	
		
8'd21:   begin        // - code
      opcode=5;       
      program_assembly[0]=instructions[1];  // ld_a
      program_assembly[1]=instructions[2];  // ld_b
		program_assembly[2]=instructions[6];  // sub
      program_assembly[3]=instructions[3];  // store
      program_assembly[4]=instructions[8];  // hlt
		program_assembly[10]=operand_1;
		program_assembly[11]=operand_2;
       end

8'd22:  begin              // * code
         opcode=6; 
       program_assembly[0]=instructions[1];  // ld_a
      program_assembly[1]=instructions[2];  // ld_b
		program_assembly[2]=instructions[5];  // Mul
      program_assembly[3]=instructions[3];  // store
      program_assembly[4]=instructions[8];  // hlt
		program_assembly[10]=operand_1;
		program_assembly[11]=operand_2;
      end

8'd23:  begin      // / code

      opcode=7;
      program_assembly[0]=instructions[1];  // ld_a
      program_assembly[1]=instructions[2];  // ld_b
		program_assembly[2]=instructions[10];  // div
      program_assembly[3]=instructions[3];  // store
      program_assembly[4]=instructions[8];  // hlt
		program_assembly[10]=operand_1;
		program_assembly[11]=operand_2;
       end

endcase
 
end



// as long as insturcions address register is less than 15 ,
//on each clock increment the instruction address register by one 
always @ (posedge clock) begin


if((assembler_enable) && (inst_addr <=15)) begin
 
	
          write_en=1'b1;
          inst_addr=inst_addr+8'd1;
			 
   end
	
else begin
write_en=1'b0;
inst_addr=8'd0;
end
end

// assigning each generated instruction based on its address to the output of the module 


assign assembler_out=program_assembly[inst_addr];

	




 
endmodule 