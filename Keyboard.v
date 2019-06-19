

module Keyboard (

	input Keyboard_clock,
	input Keyboard_Data,
	output reg [7:0] cnt,
	//output reg [7:0] code,
	output [7:0] key_in
//	output  [7:0] operator
	//output  [6:0] display
	

);

	reg [10:0] Data;
	reg [7 :0] HoldCode1;
	reg [7 :0] HoldCode2;
	reg [7:0] code = 0;
	
	//wire [3: 0] number;
	
	integer Counter = 0;
	
	
Decodekeyboard Decodekeyboard(

	.code (code),
	//.cnt(cnt),
	.key_in (key_in)
//	.operator(operator)

);
/*
SevenSegDisplay SevenSegDisplay(

	.number (number),
	
	.display (display)

);
	
*/	
	always @(negedge Keyboard_clock) begin 
	
		Data[Counter] = Keyboard_Data;
		Counter = Counter + 1;
			
			if (Counter > 11) begin 
		
			HoldCode1 = Data [8:1];
				
				if (HoldCode1 == 8'hF0) begin
					code = HoldCode2;
				end 
				 
				else begin
					HoldCode2 = HoldCode1;
				end
				
					Counter = 1;
					
					if(cnt<8'd6) begin
                cnt=cnt+8'd1;
					end
					else begin
					cnt=8'd0;
						end
			end 

	
	end
	


endmodule 
