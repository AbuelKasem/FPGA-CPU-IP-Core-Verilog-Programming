	module Decodekeyboard(

 input [7:0] code,
 
 output reg [7:0] key_in
 //output reg [7*1:0] operator  //8  ?
 
);

 
 always@(code) begin
 
	case (code)
	
			8'h45: key_in=8'd0;
			8'h70: key_in=8'd 0;
			8'h16: key_in=8'd 1;
			8'h69: key_in= 8'd1;
			8'h1E: key_in= 8'd2;
			8'h72: key_in= 8'd2;		
			8'h26: key_in= 8'd3; 
			8'h7A: key_in= 8'd3; 
			8'h25: key_in=8'd 4;
			8'h6B: key_in= 8'd4;
			8'h2E: key_in= 8'd5;
			8'h73: key_in= 8'd5;	
			8'h36: key_in= 8'd6;
			8'h74: key_in=8'd 6;
			8'h3D: key_in=8'd 7;	
			8'h6C: key_in= 8'd7;	
			8'h3E: key_in= 8'd8;
			8'h75: key_in= 8'd8;
			8'h46: key_in= 8'd9;
			8'h7D: key_in= 8'd9;
			8'h79: key_in = 8'd20;  //+
			8'h7B: key_in = 8'd21;  //-
			8'h7C: key_in = 8'd22;   //*
			8'h4A: key_in = 8'd23;    //  /
			8'h5A: key_in =8'd 26;   // enter
			8'h55: key_in =8'd 27;   //=
			8'h66: key_in =8'd 28;   //=
			
			
			
			/*
			8'h79: operator = "+";
			8'h7B: operator = "-";
			8'h7C: operator = "*";
			8'h71: operator = ".";
			8'h5A: operator = "=";
			
		*/
	endcase
end


endmodule 