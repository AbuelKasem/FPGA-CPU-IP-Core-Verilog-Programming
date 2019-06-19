//Designeg by Rex-Rim-Rukeh
//Elec5566 FPGA Servo Assignment
//March 2019

//This module takes the 8-bit input and the servo channel input and converts them to decimal digits to be indivdually diplayed on the
//7 segmented display. 
module SevenSegDisplay #(

	parameter INVERT_OUTPUT = 1
)(

	input [7:0] number, 
	
	output reg [6:0] display

);

	
	always @ (number) begin
	
//the decimal value are them converted to an 8 bit digits that controls each LED on the 7 segment display	
	
	if (INVERT_OUTPUT == 0) begin
	
		case (number) //case ( expression )
		
			0: display = 7'b0111111; // constantExpr: action;
			1: display = 7'b0000110; // constantExpr: action;
			2: display = 7'b1011011; // constantExpr: action;
			3: display = 7'b1001111; // constantExpr: action;
			4: display = 7'b1100110; // constantExpr: action;
			5: display = 7'b1101101; // constantExpr: action;
			6: display = 7'b1111101; // constantExpr: action;
			7: display = 7'b0000111; // constantExpr: action;
			8: display = 7'b1111111; // constantExpr: action;
			9: display = 7'b1101111; // constantExpr: action;
			10: display =7'b1110111; 
			11: display = 7'b111111;
			12: display = 7'b0111001; // d for deicmal ,h hexadecimal did not work
			13: display = 7'b0111111;
			14: display = 7'b1111001;
			15: display = 7'b1110001;

		default: display = 7'b0000000; // default: action;
		
	endcase
	
	end
	
	else begin
	
	case (number) //case ( expression )
		
			0: display = ~7'b0111111; // constantExpr: action;
			1: display = ~7'b0000110; // constantExpr: action;
			2: display = ~7'b1011011; // constantExpr: action;
			3: display = ~7'b1001111; // constantExpr: action;
			4: display = ~7'b1100110; // constantExpr: action;
			5: display = ~7'b1101101; // constantExpr: action;
			6: display = ~7'b1111101; // constantExpr: action;
			7: display = ~7'b0000111; // constantExpr: action;
			8: display = ~7'b1111111; // constantExpr: action;
			9: display = ~7'b1101111; // constantExpr: action;
			10: display =~7'b1110111; 
			11: display =~ 7'b111111;
			12: display = ~7'b0111001; // d for deicmal ,h hexadecimal did not work
			13: display = ~7'b0111111;
			14: display = ~7'b1111001;
			15: display = ~7'b1110001;
			

		default: display = ~7'b0000000; // default: action;
		
	endcase
	
	
	end
	
	
end



endmodule

