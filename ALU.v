module ALU#(

     parameter opcode_SIZE, 
	   parameter Data_WIDTH
	  
)(

	input signed [(Data_WIDTH-1):0]A, 
	input signed [(Data_WIDTH-1):0]B, 
	input Cin, 
	input [(opcode_SIZE-1):0] select,  // opcode
	input enable,
	//input clock, 
	//input reset,
	
	output reg signed [(Data_WIDTH-1):0] answer, 
	output reg Cout,
	output reg negFlag, 
	output reg overflowFlag,
	output reg zeroFlag,
	output reg equalFlag,
	output reg greaterthanFlag

);


	reg [8:0] hold_answer;
	integer j;
	integer k;
	integer i;
	
	/*
	wire [8:0] add_answer;
	wire [8:0] minus_answer;
	wire [8:0] mult_answer;
	wire [7:0] div_answer;
	wire [7:0] ANDanswer;
	wire [7:0] ORanswer;
	wire [7:0] Rshiftanswer;
	wire [7:0] Lshiftanswer;
	wire [7:0] XORanswer;
	wire [7:0] NANDanswer;
	wire [7:0] NORanswer;
	wire [7:0] XNORanswer;
	*/
	
	
	
	
	
	/*
	Arithmetic Arithmetic(
	.A (A),
	.B (B),
	.Cin (Cin),
	
	.add_answer (hold_answer[0]),
	.minus_answer (minus_answer),
	.mult_answer (mult_answer),
	.div_answer (div_answer)
	
	);
	
	LogicUnit LogicUnit(
	.A (A), 
	.B (B), 
	
	.ANDanswer (ANDanswer), 
	.ORanswer (ORanswer),
	.Rshiftanswer (Rshiftanswer),
	.Lshiftanswer (Lshiftanswer),
	.XORanswer (XORanswer),
	.NANDanswer (NANDanswer), 
	.NORanswer (NORanswer),
	.XNORanswer (XNORanswer)
	
	
	);
	
	*/
	initial begin 
 
				answer=0;
				
 end

	



	// always @(posedge enable)begin 
	 always @ * begin 
	  if(	enable)begin
			if (hold_answer > 255) begin
			Cout<=hold_answer[8];
			end
			else begin
			Cout<= 0; 
			end
		
			if (A>B) begin
			greaterthanFlag <= 1;
			end
			else begin
			greaterthanFlag <=0;
			end
			
		
		
			if (answer==0) begin
			zeroFlag <= 1;
			end
			else begin
			zeroFlag <=0;
			end
			
		
			if (answer<0) begin
			negFlag <= 1;
			end
			else begin
			negFlag <=0;
			end
		
			if (A==B) begin
			equalFlag <= 1;
			end
			else begin
			equalFlag <=0;
			end
		

		
 

		
		
		
		
		
		
	 
		case (select)
	 
		1: begin
	  // answer <= A+B+Cin; 
		//hold_answer <= A+B+Cin;
		answer <= A+B; 
		hold_answer <= A+B;
		
		end
		
		2: begin
		answer <= A-B;
		hold_answer<=0;
		end
		
		3: begin
		answer <= A*B;
		hold_answer<=0;
		end
		
		4: begin
		j=A;
		k=B;
		
		for (i=1; i<100; i=i+1)begin
		j = j-k;
		
		if (j==0)begin
		answer <= i;
		end
		
	
		end
		
		end
		
		5: begin
		answer <= A & B;
		hold_answer<=0;
		end
		
		6: begin
		answer <= A | B; 
		end
		
		7: begin
		answer <= A>>B; 
		hold_answer<=0;
		end
		
		8: begin
		answer <= A<<B;
		end
		
		9: begin
		answer <= A^B;
		hold_answer<=0;
		end
		
		10: begin
		answer <= ~(A&B);
		hold_answer<=0;
		end
		
		11: begin
		answer <= ~(A|B);
		hold_answer<=0;
		end
		
		12: begin
		answer <= ~(A^B);
		hold_answer<=0;
		end
		
		
		default: begin
		answer <= 0;
		Cout <= 8'b00000000;
		end
	 
		
		endcase
	 
	 
	 end
	end
	 
	 
	 



endmodule 