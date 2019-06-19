
module CPU_V1 #(   // parameters configurations , in bits
                        
      parameter Instruction_WIDTH=16  ,
	   parameter Instruction_Memory_Size=16 ,
	   parameter opcode_SIZE =4,
		parameter Data_WIDTH=8 , 
		parameter Data_Memory_Size=16 
		


)

(

	 input              clock,                   // main 50 mhz clock
	 input              clock_ps2,               // ps2 port 
	 input              reset_select_bt,         
	 input				  Keyboard_Data,         // input ps2 port data
    input              globalReset,           // sw6
	 input              cmp_wr_enable,         // assembler enable sw8
	 
	 input               c_u_en_sw,            //control unit enable sw7
    
    // LT24 Interface
    output             LT24Wr_n,
    output             LT24Rd_n,
    output             LT24CS_n,
    output             LT24RS,
    output             LT24Reset_n,
    output             [ 15:0] LT24Data,
    output             LT24LCDOn,
	
	 output  [6:0] display,   // seven segments displays output
 	 output  [6:0] display1,
	 output  [6:0] display2,
	 output  [6:0] display3,
	 output  [6:0] display4,
	 output  [6:0] display5,
	
	
output	cpu_done  // output led for cpu finish executing indication

	 
);

wire [7:0] state; // state variable to be displayed on 7-seg

reg [7:0] k1;  // registers to store digits of each number entered from keyboard
reg [7:0] k2;
reg [7:0] k3;
reg [7:0] k4;



reg    [31:0] key_delay_counter; // counter for delay between each entered digit


reg [7:0] operand1;    
reg [7:0] operand2;
wire [7:0] operator;
reg [7:0] operator_temp;
reg [7:0] result;
wire [7:0] result_tmp;
wire [7:0] key_in_char;

wire [15:0] compiler_out_data;
wire [7:0] cmp_ram_address;
reg [(opcode_SIZE-1):0] cu_opcode;
reg [7:0] cu_operand1;
reg [7:0] cu_operand2;
wire [(opcode_SIZE-1):0] com_opcode;
wire [7:0] cu_A;
wire [7:0] cu_C;
reg Ram_Read_EN;
reg result_Ram_Read_EN;
reg Ram_Write_EN;
reg assembler_en;
wire Assembler_enable;
wire control_unit_enable;
reg control_u_en;

wire RESET;
reg Soft_reset;
reg [7:0] ram_address;
wire control_unit_write_en;
reg key_flag;
wire [7:0] control_unit_ram_address;
wire [15:0] control_unit_write_data;
wire[15:0] control_unit_read_data;

assign operator = operator_temp;
assign Assembler_enable = cmp_wr_enable || assembler_en;
assign control_unit_enable = c_u_en_sw || control_u_en;
assign operator = operator_temp;
assign RESET = Soft_reset || globalReset;






initial begin  // initialise control signals and counters to zero
control_u_en=1'b0;
assembler_en=1'b0;
result_Ram_Read_EN=1'b0;
operator_temp=8'd0;
key_flag=1'b0;

 key_delay_counter=32'd0;
end


// instance of the lcd control module to display the math operation
// and the text lines
LT24Top2  terminal_out(   


    .clock(clock),
	 .reset_select_bt(reset_select_bt),
	 .globalReset(globalReset),
	 .LT24Wr_n    (LT24Wr_n   ),
    .LT24Rd_n    (LT24Rd_n   ),
    .LT24CS_n    (LT24CS_n   ),
    .LT24RS      (LT24RS     ),
    .LT24Reset_n (LT24Reset_n),
    .LT24Data    (LT24Data   ),
    .LT24LCDOn   (LT24LCDOn  ),
	 .operand_1(operand1),
	 .operand_2(operand2),
	 .operator(operator),
	 .result(result)
	
	 
	 );
	 
	 
// instance of the assembler module to generate the assembly instructions
// and opcodes for the required program	
Assembler_v2 #(
   .opcode_SIZE(opcode_SIZE)

)assembler(

	 .clock(clock),
    .assembler_enable(Assembler_enable),
	 .operand_1(operand1),
	 .operand_2(operand2),
	 .operator(operator),
	 .opcode(com_opcode),
	 .assembler_out(compiler_out_data),
	 .assembler_mem_address(cmp_ram_address)
	); 


// this block activates when the assembler  is deactivated to ensure that it 
//finished executing , then pass the data to control unit

	
always @ (negedge Assembler_enable) begin
cu_opcode=com_opcode;
cu_operand1=operand1;
cu_operand2=operand2;

end

// instance of the control unit that takes in the clock and reset and enable signals 
//either from keyboard or switch and the math operation data
// it outputs the result in addition to instruction register and state
//for debugging


control_unit_v33 #(
  
     .Instruction_WIDTH (Instruction_WIDTH),
	  .Instruction_Memory_Size (Instruction_Memory_Size),
	  
	  .opcode_SIZE(opcode_SIZE),
	  .Data_WIDTH(Data_WIDTH),
	  .Data_Memory_Size (Data_Memory_Size)
	
	
	  

)c_u_ins1(
     .clock( clock ), 
    .reset_bt(RESET),
	 .CU_enable(control_unit_enable),
	 .operand1(cu_operand1),
	 .operand2(cu_operand2),
	 .operator(cu_opcode),
	 .inst_reg(control_unit_read_data),
	 .state(state),
    .done(cpu_done),
	 .A (cu_A),
	 .B(cu_C),
	
	 .ram_address(control_unit_ram_address),
	 .C(result_tmp)
	 
	
); 
	
// instance from keyboard module , the receive input from ps2 clock 
// and ps2 data , and outputs the entered key code

Keyboard Data_in(
	
	.Keyboard_clock(clock_ps2),
	.Keyboard_Data(Keyboard_Data),
	
	.key_in (key_in_char)


);

// 6 instances of the seven segments display modules to display test
// and debug data


SevenSegDisplay SevenSegDisplay(

	.number (state),
	
	.display (display)

);

SevenSegDisplay SevenSegDisplay1(

	.number (control_unit_ram_address),
	
	.display (display1)

);

SevenSegDisplay SevenSegDisplay2(

	.number (control_unit_read_data[7:0]),
	
	.display (display2)

); 


SevenSegDisplay SevenSegDisplay3(

	.number (control_unit_read_data[15:12]),
	
	.display (display3)

); 


SevenSegDisplay SevenSegDisplay4(

	.number (k1),
	
	.display (display4)

); 
SevenSegDisplay SevenSegDisplay5(

	.number (k2),
	
	.display (display5)

); 

// this blocks interpret the incoming key codes from the keyboard into
//either numbers or operators , and make delay for the two digit numbers
//entering and set and clear the assembler and control unit control signals
// based on the entered keys from keyboard

always @ (posedge clock) begin

if( RESET) begin
result=8'd0;
operand1=8'd0;
operand2=8'd0;
k1=8'd0;
k2=8'd0;
k3=8'd0;
k4=8'd0;
key_delay_counter=32'd0;

end
else begin
result=result_tmp;
end

if(key_in_char >=8'd0   && key_in_char <=8'd9  &&  key_flag ==1'b0) begin
				key_delay_counter=key_delay_counter+32'd1;
				if(key_delay_counter <32'd5000000) begin
						k1 = key_in_char;
						
				end
				else if	(key_delay_counter > 32'd5000000) begin
						k2 = key_in_char;
					
						operand1 = (k1*8'd10)+k2;
		       end
		     else if	(key_delay_counter > 32'd10000000) begin
						key_delay_counter=32'd0;
							       
				end
	end
   else if (key_in_char >= 8'd20 && key_in_char <= 8'd23) begin

      operator_temp =  key_in_char;
      key_flag=1'b1;
		key_delay_counter=32'd0;
		
		end

else if (key_in_char >=8'd0   && key_in_char <=8'd9  &&  key_flag ==1'b1) begin
    
	         key_delay_counter=key_delay_counter+32'd1;
				if(key_delay_counter <32'd5000000) begin
						k3 = key_in_char;
						
				end
				else if	(key_delay_counter > 32'd5000000) begin
						k4= key_in_char;
					
						operand2 = (k3*8'd10)+k4;
		       end
		     else if	(key_delay_counter > 32'd10000000) begin
						key_delay_counter=32'd0;					
		       
				end
      		
	   end
		
else if (key_in_char ==8'd26)   begin  //enter
		key_flag=1'b0;
		assembler_en=1'b1;
		control_u_en=1'b0;
      Soft_reset=1'b0;
		key_delay_counter=32'd0;
end
else if (key_in_char ==8'd27)   begin  // =
		
		assembler_en=1'b0;   
		control_u_en=1'b1;
		Soft_reset=1'b0;

end
else if (key_in_char ==8'd28)   begin  // =

		assembler_en=1'b0;   
		control_u_en=1'b0;
		Soft_reset=1'b1;

end
else begin
assembler_en=1'b0;   
control_u_en=1'b0;
Soft_reset=1'b0;
end
end

endmodule