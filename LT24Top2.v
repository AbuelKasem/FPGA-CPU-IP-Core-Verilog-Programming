/*
 * LT24 Test Pattern Top
 * ------------------------
 * By: Thomas Carpenter
 * For: University of Leeds
 * Date: 13th February 2019
 *
 * Short Description
 * -----------------
 * This module is designed to interface with the LT24 Display Module
 * from Terasic. It makes use of the LT24Display IP core to show a
 * simple test pattern on the display.
 *
 */

module LT24Top2 (
    // Global Clock/Reset
    // - Clock
    input              clock,
	 input              reset_select_bt,  // switch input to select auto reset or button reset of lcd
	 input [7:0] operand_1,  
   
	 input [7:0] operand_2, 
	 input [7:0] operator,
	 input [7:0] result,
    input              globalReset,
    // - Application Reset - for debug
    output             resetApp,
    
    // LT24 Interface
    output             LT24Wr_n,
    output             LT24Rd_n,
    output             LT24CS_n,
    output             LT24RS,
    output             LT24Reset_n,
    output             [ 15:0] LT24Data,
    output             LT24LCDOn,
	 output reg     clk_count_sec
);

//
// declaration of the local variables used in the module 
//
reg s_globalReset;
reg g_Reset;

reg [7:0] res1;   // first digit of the result
reg [7:0] res2;
reg [7:0] operand_11;
reg [7:0] operand_12;
reg [7:0] operand_21;
reg [7:0] operand_22;
wire [ 7:0] xAddr;      // pixel coordinate on the lcd
wire [ 8:0] yAddr;
reg [ 7:0] xtemp;     
reg [ 8:0] ytemp;
reg   [ 7:0] x_init ;
reg   [ 8:0] y_init ;
reg  [15:0] pixelData;
wire  [15:0] pixelData1;
reg    [9:0] k;
reg    [31:0] clk_count;
wire        pixelReady;
reg         pixelWrite;
wire [7:0] totaop2_char_data[0:7];
reg [7:0] char_data[0:7];
wire [7:0] C[0:7];
wire [7:0] A[0:7];
wire [7:0] L[0:7];
wire [7:0] U[0:7];
wire [7:0] T[0:7];
wire [7:0] O[0:7];
wire [7:0] R[0:7];
wire [7:0] P[0:7];
wire [7:0] op11_char_data[0:7];
wire [7:0] op12_char_data[0:7];
wire [7:0] op21_char_data[0:7];
wire [7:0] op22_char_data[0:7];
wire [7:0] op2_char_data[0:7];
wire [7:0] operator_char_data [0:7];
wire [7:0] equal_char_data [0:7];
wire [7:0] res1_char_data[0:7];
wire [7:0] res2_char_data[0:7];
reg [7:0] w[0:7];
wire [7:0] rom_data;
reg  [ 7:0] i;
reg  [ 7:0] j;
reg rom_clk;
reg  [ 7:0] char_width;
reg  [ 8:0] char_height;
reg  [ 8:0] new_line;
reg  [ 7:0] space;
wire  [ 7:0] x_off;
wire  [ 8:0] y_off;
wire  [ 7:0] x_off2;
wire  [ 8:0] y_off2;
wire  [ 7:0] x_off3;
wire  [ 8:0] y_off3;
reg  [ 7:0] x_cord;
reg  [ 8:0] y_cord;
reg  [ 7:0] x_cord2;
reg  [ 8:0] y_cord2;
reg  [ 7:0] x_cord3;
reg  [ 8:0] y_cord3;
reg [9:0]  addrs;
reg [9:0]  in_addrs;

// initialization block of the variables used in displaying the characters on the lcd

initial begin

char_data[0]=8'b00000000;
char_data[1]=8'b00000000;
char_data[2]=8'b00000000;
char_data[3]=8'b00000000;
char_data[4]=8'b00000000;
char_data[5]=8'b00000000;
char_data[6]=8'b00000000;
char_data[7]=8'b00000000;
s_globalReset=1'b1;
x_cord=8'd50;
y_cord=9'd150;
x_cord2=8'd60;
y_cord2=9'd90;
x_cord3=8'd90;
y_cord3=9'd50;

char_width=7'd8 ;
char_height=8'd8;

space=7'd8 ;

x_init=7'd0 ;
y_init=8'd0 ;
rom_clk=1'b1;

k=10'o0;
end

// this block is executed whenever a signal within it changes



always @ *  begin

   if(result <8'd10) begin         // extracting of the two digits of the result
       res1=result; 
       res2=8'd0;
   end
  else if(result >=8'd10  && result < 8'd20 ) begin
     res1=result -8'd10;
	  res2=8'd1;
	end
	else if(result >=8'd20  && result < 8'd30 ) begin
     res1=result -8'd20;
	  res2=8'd2;
	end
	else if(result >=8'd30  && result < 8'd40 ) begin
     res1=result -8'd30;
	  res2=8'd3;
	end
	else if(result >=8'd40  && result < 8'd50 ) begin
     res1=result -8'd40;
	  res2=8'd4;
	end
	else if(result >=8'd50  && result < 8'd60 ) begin
     res1=result -8'd50;
	  res2=8'd5;
	end
	else if(result >=8'd60  && result < 8'd70 ) begin
     res1=result -8'd60;
	  res2=8'd6;
	end
	else if(result >=8'd70  && result < 8'd80 ) begin
     res1=result -8'd70;
	  res2=8'd7;
	end
	else if(result >=8'd80  && result < 8'd90 ) begin
     res1=result -8'd80;
	  res2=8'd8;
	end
	else if(result >=8'd90  && result < 8'd100 ) begin
     res1=result -8'd90;
	  res2=8'd9;
	end
	
	
	if(operand_1 <8'd10) begin         // extracting of the two digits of operand1
       operand_11=operand_1; 
       operand_12=8'd0;
   end
  else if(operand_1 >=8'd10  && operand_1 < 8'd20 ) begin
     operand_11=operand_1 -8'd10;
	  operand_12=8'd1;
	end
	else if(operand_1 >=8'd20  && operand_1 < 8'd30 ) begin
     operand_11=operand_1 -8'd20;
	  operand_12=8'd2;
	end
	else if(operand_1 >=8'd30  && operand_1 < 8'd40 ) begin
     operand_11=operand_1 -8'd30;
	  operand_12=8'd3;
	end
	else if(operand_1 >=8'd40  && operand_1 < 8'd50 ) begin
     operand_11=operand_1 -8'd40;
	  operand_12=8'd4;
	end
	else if(operand_1 >=8'd50  && operand_1 < 8'd60 ) begin
     operand_11=operand_1 -8'd50;
	  operand_12=8'd5;
	end
	else if(operand_1 >=8'd60  && operand_1 < 8'd70 ) begin
     operand_11=operand_1 -8'd60;
	  operand_12=8'd6;
	end
	else if(operand_1 >=8'd70  && operand_1 < 8'd80 ) begin
     operand_11=operand_1 -8'd70;
	  operand_12=8'd7;
	end
	else if(operand_1 >=8'd80  && operand_1 < 8'd90 ) begin
     operand_11=operand_1 -8'd80;
	  operand_12=8'd8;
	end
	else if(operand_1 >=8'd90  && operand_1 < 8'd100 ) begin
     operand_11=operand_1 -8'd90;
	  operand_12=8'd9;
	end

   
	
	if(operand_2 <8'd10) begin         // extracting of the two digits of operand2
       operand_21=operand_2; 
       operand_22=8'd0;
   end
  else if(operand_2 >=8'd10  && operand_2 < 8'd20 ) begin
     operand_21=operand_2 -8'd10;
	  operand_22=8'd1;
	end
	else if(operand_2 >=8'd20  && operand_2 < 8'd30 ) begin
     operand_21=operand_2 -8'd20;
	  operand_22=8'd2;
	end
	else if(operand_2 >=8'd30  && operand_2 < 8'd40 ) begin
     operand_21=operand_2 -8'd30;
	  operand_22=8'd3;
	end
	else if(operand_2 >=8'd40  && operand_2 < 8'd50 ) begin
     operand_21=operand_2 -8'd40;
	  operand_22=8'd4;
	end
	else if(operand_2 >=8'd50  && operand_2 < 8'd60 ) begin
     operand_21=operand_2 -8'd50;
	  operand_22=8'd5;
	end
	else if(operand_2 >=8'd60  && operand_2 < 8'd70 ) begin
     operand_21=operand_2 -8'd60;
	  operand_22=8'd6;
	end
	else if(operand_2 >=8'd70  && operand_2 < 8'd80 ) begin
     operand_21=operand_2 -8'd70;
	  operand_22=8'd7;
	end
	else if(operand_2 >=8'd80  && operand_2 < 8'd90 ) begin
     operand_21=operand_2 -8'd80;
	  operand_22=8'd8;
	end
	else if(operand_2 >=8'd90  && operand_2 < 8'd100 ) begin
     operand_21=operand_2 -8'd90;
	  operand_22=8'd9;
	end

	  
    
  

if(reset_select_bt==1'b1) begin      // selecting either auto reset based on clk_count_sec
    g_Reset = clk_count_sec;         // or the global reset button
	 end 
	 else begin
	 g_Reset = globalReset;
	 end
end

always @ (posedge clock)  begin    // generating a slower clock for resetting the lcd
clk_count=clk_count+32'd1;

if (clk_count>= 32'd10000000) begin
  clk_count_sec=1'b1;
  clk_count=32'd0;
    end
	 else begin 
  clk_count_sec=1'b0;
  end
 end

 
 
 
 
 
// instantiating char_letter module to extract the 8 bytes for each letter from the character ROM  
 
char_letter C_char(	        // letter C
	  .char_address(10'o30), 
	  .clock(clock),
   
     .char_data0(C[0]),
	  .char_data1(C[1]),
	  .char_data2(C[2]),
	  .char_data3(C[3]),
	  .char_data4(C[4]),
	  .char_data5(C[5]),
	  .char_data6(C[6]),
	  .char_data7(C[7])
   
);

char_letter A_char(	 // letter A
     
	  .char_address(10'o0), 
	  .clock(clock),
   
     .char_data0(A[0]),
	  .char_data1(A[1]),
	  .char_data2(A[2]),
	  .char_data3(A[3]),
	  .char_data4(A[4]),
	  .char_data5(A[5]),
	  .char_data6(A[6]),
	  .char_data7(A[7])
   
);
char_letter L_char(	  // letter L
     
	  .char_address(10'o140), 
	  .clock(clock),
   
     .char_data0(L[0]),
	  .char_data1(L[1]),
	  .char_data2(L[2]),
	  .char_data3(L[3]),
	  .char_data4(L[4]),
	  .char_data5(L[5]),
	  .char_data6(L[6]),
	  .char_data7(L[7])
   
);
char_letter U_char(	  // letter U
     
	  .char_address(10'o250), 
	  .clock(clock),
   
     .char_data0(U[0]),
	  .char_data1(U[1]),
	  .char_data2(U[2]),
	  .char_data3(U[3]),
	  .char_data4(U[4]),
	  .char_data5(U[5]),
	  .char_data6(U[6]),
	  .char_data7(U[7])
   
);
char_letter T_char(	  // letter T
       
	  .char_address(10'o240), 
	  .clock(clock),
   
     .char_data0(T[0]),
	  .char_data1(T[1]),
	  .char_data2(T[2]),
	  .char_data3(T[3]),
	  .char_data4(T[4]),
	  .char_data5(T[5]),
	  .char_data6(T[6]),
	  .char_data7(T[7])
   
);
char_letter O_char(	 // letter O
      
	  .char_address(10'o170), 
	  .clock(clock),
   
     .char_data0(O[0]),
	  .char_data1(O[1]),
	  .char_data2(O[2]),
	  .char_data3(O[3]),
	  .char_data4(O[4]),
	  .char_data5(O[5]),
	  .char_data6(O[6]),
	  .char_data7(O[7])
   
);
char_letter R_char(	  // letter R
     
	  .char_address(10'o220), 
	  .clock(clock),
   
     .char_data0(R[0]),
	  .char_data1(R[1]),
	  .char_data2(R[2]),
	  .char_data3(R[3]),
	  .char_data4(R[4]),
	  .char_data5(R[5]),
	  .char_data6(R[6]),
	  .char_data7(R[7])
   
);


char_letter P_char(	  // letter P
    
	  .char_address(10'o200), 
	  .clock(clock),
   
     .char_data0(P[0]),
	  .char_data1(P[1]),
	  .char_data2(P[2]),
	  .char_data3(P[3]),
	  .char_data4(P[4]),
	  .char_data5(P[5]),
	  .char_data6(P[6]),
	  .char_data7(P[7])
   
);

// instantiating char_digit module to extract the 8 bytes for each number from the character ROM 
// for numbers from 0 to 9  for the operands 1 and 2 and the two digits of the result

    char_digit op11_char(	  
     .num(operand_11),
	  .clock(clock),
   
     .char_data0(op11_char_data[0]),
	  .char_data1(op11_char_data[1]),
	  .char_data2(op11_char_data[2]),
	  .char_data3(op11_char_data[3]),
	  .char_data4(op11_char_data[4]),
	  .char_data5(op11_char_data[5]),
	  .char_data6(op11_char_data[6]),
	  .char_data7(op11_char_data[7])
   
);

    char_digit op12_char(	  
     .num(operand_12),
	  .clock(clock),
   
     .char_data0(op12_char_data[0]),
	  .char_data1(op12_char_data[1]),
	  .char_data2(op12_char_data[2]),
	  .char_data3(op12_char_data[3]),
	  .char_data4(op12_char_data[4]),
	  .char_data5(op12_char_data[5]),
	  .char_data6(op12_char_data[6]),
	  .char_data7(op12_char_data[7])
   
);



char_digit op21_char(	  
     .num(operand_21),
	  .clock(clock),
   
     .char_data0(op21_char_data[0]),
	  .char_data1(op21_char_data[1]),
	  .char_data2(op21_char_data[2]),
	  .char_data3(op21_char_data[3]),
	  .char_data4(op21_char_data[4]),
	  .char_data5(op21_char_data[5]),
	  .char_data6(op21_char_data[6]),
	  .char_data7(op21_char_data[7])
   
);

char_digit op22_char(	  
     .num(operand_22),
	  .clock(clock),
   
     .char_data0(op22_char_data[0]),
	  .char_data1(op22_char_data[1]),
	  .char_data2(op22_char_data[2]),
	  .char_data3(op22_char_data[3]),
	  .char_data4(op22_char_data[4]),
	  .char_data5(op22_char_data[5]),
	  .char_data6(op22_char_data[6]),
	  .char_data7(op22_char_data[7])
   
);



char_digit res1_char(	  // result 1st digit
     .num(res1),
	  .clock(clock),
   
     .char_data0(res1_char_data[0]),
	  .char_data1(res1_char_data[1]),
	  .char_data2(res1_char_data[2]),
	  .char_data3(res1_char_data[3]),
	  .char_data4(res1_char_data[4]),
	  .char_data5(res1_char_data[5]),
	  .char_data6(res1_char_data[6]),
	  .char_data7(res1_char_data[7])
   
);

char_digit res2_char(	  // result 2nd digit
     .num(res2),
	  .clock(clock),
   
     .char_data0(res2_char_data[0]),
	  .char_data1(res2_char_data[1]),
	  .char_data2(res2_char_data[2]),
	  .char_data3(res2_char_data[3]),
	  .char_data4(res2_char_data[4]),
	  .char_data5(res2_char_data[5]),
	  .char_data6(res2_char_data[6]),
	  .char_data7(res2_char_data[7])
   
);


	 
// instantiating char_operator module to extract the 8 bytes for each operator from the character ROM 

    char_operator operator_char(	  // + , - , * etc
     
	  .char_operator(operator),
	  .clock(clock),
   
     .char_data0(operator_char_data[0]),
	  .char_data1(operator_char_data[1]),
	  .char_data2(operator_char_data[2]),
	  .char_data3(operator_char_data[3]),
	  .char_data4(operator_char_data[4]),
	  .char_data5(operator_char_data[5]),
	  .char_data6(operator_char_data[6]),
	  .char_data7(operator_char_data[7])
   
);


char_operator eq_char(	  // = sign
      
	  .char_operator(8'd26), 
	  .clock(clock),
   
     .char_data0(equal_char_data[0]),
	  .char_data1(equal_char_data[1]),
	  .char_data2(equal_char_data[2]),
	  .char_data3(equal_char_data[3]),
	  .char_data4(equal_char_data[4]),
	  .char_data5(equal_char_data[5]),
	  .char_data6(equal_char_data[6]),
	  .char_data7(equal_char_data[7])
   
);
	 
	 

// LCD Display
//

assign x_off=x_cord;    // assigning the offset coordinates of each line on the lcd
assign y_off=y_cord;
assign x_off2=x_cord2;
assign y_off2=y_cord2;
assign x_off3=x_cord3;
assign y_off3=y_cord3;

localparam LCD_WIDTH  = 240;
localparam LCD_HEIGHT = 320;

LT24Display #(
    .WIDTH       (LCD_WIDTH  ),
    .HEIGHT      (LCD_HEIGHT ),
    .CLOCK_FREQ  (50000000   )
) Display (
    .clock       (clock      ),
    .globalReset (g_Reset ),
    .resetApp    (resetApp   ),
    .xAddr       (xAddr      ),
    .yAddr       (yAddr      ),
    .pixelData   (pixelData  ),
    .pixelWrite  (pixelWrite ),
    .pixelReady  (pixelReady ),
    .pixelRawMode(1'b0       ),
    .cmdData     (8'b0       ),
    .cmdWrite    (1'b0       ),
    .cmdDone     (1'b0       ),
    .cmdReady    (           ),
    .LT24Wr_n    (LT24Wr_n   ),
    .LT24Rd_n    (LT24Rd_n   ),
    .LT24CS_n    (LT24CS_n   ),
    .LT24RS      (LT24RS     ),
    .LT24Reset_n (LT24Reset_n),
    .LT24Data    (LT24Data   ),
    .LT24LCDOn   (LT24LCDOn  )
);




//
// X Counter
//
UpCounterNch_bit2 #(
    .WIDTH    (          8),
    .MAX_VALUE(LCD_WIDTH-1)
) xCounter2 (
    .clock     (clock     ),
    .reset     (resetApp  ),
    .enable    (pixelReady),
	 .LoadValue(x_init),
    .countValue(xAddr     )
);

//
// Y Counter
//
wire yCntEnable = pixelReady && (xAddr == (LCD_WIDTH-1));
UpCounterNch_bit2 #(
    .WIDTH    (           9),
    .MAX_VALUE(LCD_HEIGHT-1)
) yCounter2 (
    .clock     (clock     ),
    .reset     (resetApp  ),
    .enable    (yCntEnable),
	 .LoadValue(y_init),
    .countValue(yAddr     )
);



//
// Pixel Write
//
always @ (posedge clock or posedge resetApp) begin
    if (resetApp) begin
        pixelWrite <= 1'b0;
    end else begin
      
        pixelWrite <= 1'b1;
        
    end
end




// this block is used to write the pixels of each character that is retrieved from the character ROM  
//and stored in 8 bytes * b bits array 



always @ (posedge clock or posedge resetApp) begin
    if (resetApp) begin
        pixelData           <= 16'b0;
    end else if (pixelReady) begin
	 
	                 // to check if the  x and y address of the pixel are in the specific place for the character
						  // this by setting a window of area of 8*8 pixels
							if ((xAddr>=x_off3) && (xAddr<x_off3+char_width) && (yAddr>=y_off3) && (yAddr<y_off3+char_height))begin
							
							      
							      xtemp=xAddr-x_off3;    // two variables to loop through the matrix of each character bits
									 ytemp=yAddr-y_off3;
									
									if (C[ytemp][xtemp]== 1'b1)begin     // if the bit is set (1) draw a pixel in this location           
												
												pixelData[15:0] <=  16'hF800; //red
									end
	   
									else begin   // else if the bit is cleared (0)  keep the pixel cleared
											pixelData[15:0] <=  16'h0000; 
									end 
							end
							else if ((xAddr>=x_off3+char_width) && (xAddr<x_off3+(2*char_width)) && (yAddr>=y_off3) && (yAddr<y_off3+char_height))begin
							
							      
							      xtemp=xAddr-(x_off3+char_width);
									 ytemp=yAddr-y_off3;
									
									if (P[ytemp][xtemp]== 1'b1)begin
												//pixelData[15:0] <=  16'hFFE0;  //yellow
												pixelData[15:0] <=   16'hF800; //red
									end
	   
									else begin
											pixelData[15:0] <=  16'h0000; 
									end 
							end
							else if ((xAddr>=x_off3+(2*char_width)) && (xAddr<x_off3+(3*char_width)) && (yAddr>=y_off3) && (yAddr<y_off3+char_height))begin
							
							      
							      xtemp=xAddr-(x_off3+(2*char_width));
									 ytemp=yAddr-y_off3;
									
									if (U[ytemp][xtemp]== 1'b1)begin
												//pixelData[15:0] <=  16'hFFE0;  //yellow
												pixelData[15:0] <=   16'hF800; //red
									end
	   
									else begin
											pixelData[15:0] <=  16'h0000; 
									end 
							end
							else if ((xAddr>=x_off2) && (xAddr<x_off2+char_width) && (yAddr>=y_off2) && (yAddr<y_off2+char_height))begin
							
							      
							      xtemp=xAddr-x_off2;
									 ytemp=yAddr-y_off2;
									
									if (C[ytemp][xtemp]== 1'b1)begin
												pixelData[15:0] <=  16'hFFE0;  //yellow
												//pixelData[15:0] <=  16'h001F;  //blue
									end
	   
									else begin
											pixelData[15:0] <=  16'h0000; 
									end 
						  			    
							end 
							else if ((xAddr>=x_off2+char_width) && (xAddr<x_off2+(2*char_width)) && (yAddr>=y_off2) && (yAddr<y_off2+char_height))begin
							
							      
							      xtemp=xAddr-(x_off2+char_width);
									 ytemp=yAddr-y_off2;
									
									if (A[ytemp][xtemp]== 1'b1)begin
												pixelData[15:0] <=  16'hFFE0;  //yellow
												//pixelData[15:0] <=  16'h001F;  //blue
									end
	   
									else begin
											pixelData[15:0] <=  16'h0000; 
									end 
						  			    
							end 
							else if ((xAddr>=x_off2+(2*char_width)) && (xAddr<x_off2+(3*char_width)) && (yAddr>=y_off2) && (yAddr<y_off2+char_height))begin
							
							      
							      xtemp=xAddr-(x_off2+(2*char_width));
									 ytemp=yAddr-y_off2;
									
									if (L[ytemp][xtemp]== 1'b1)begin
												pixelData[15:0] <=  16'hFFE0;  //yellow
												//pixelData[15:0] <=  16'h001F;  //blue
									end
	   
									else begin
											pixelData[15:0] <=  16'h0000; 
									end 
						  			    
							end 
							else if ((xAddr>=x_off2+(3*char_width)) && (xAddr<x_off2+(4*char_width)) && (yAddr>=y_off2) && (yAddr<y_off2+char_height))begin
							
							      
							      xtemp=xAddr-(x_off2+(3*char_width));
									 ytemp=yAddr-y_off2;
									
									if (C[ytemp][xtemp]== 1'b1)begin
												pixelData[15:0] <=  16'hFFE0;  //yellow
												//pixelData[15:0] <=  16'h001F;  //blue
									end
	   
									else begin
											pixelData[15:0] <=  16'h0000; 
									end 
						  			    
							end 
							else if ((xAddr>=x_off2+(4*char_width)) && (xAddr<x_off2+(5*char_width)) && (yAddr>=y_off2) && (yAddr<y_off2+char_height))begin
							
							      
							      xtemp=xAddr-(x_off2+(4*char_width));
									 ytemp=yAddr-y_off2;
									
									if (U[ytemp][xtemp]== 1'b1)begin
												pixelData[15:0] <=  16'hFFE0;  //yellow
												//pixelData[15:0] <=  16'h001F;  //blue
									end
	   
									else begin
											pixelData[15:0] <=  16'h0000; 
									end 
						  			    
							end 
							else if ((xAddr>=x_off2+(5*char_width)) && (xAddr<x_off2+(6*char_width)) && (yAddr>=y_off2) && (yAddr<y_off2+char_height))begin
							
							      
							      xtemp=xAddr-(x_off2+(5*char_width));
									 ytemp=yAddr-y_off2;
									
									if (L[ytemp][xtemp]== 1'b1)begin
												pixelData[15:0] <=  16'hFFE0;  //yellow
												//pixelData[15:0] <=  16'h001F;  //blue
									end
	   
									else begin
											pixelData[15:0] <=  16'h0000; 
									end 
						  			    
							end 
							else if ((xAddr>=x_off2+(6*char_width)) && (xAddr<x_off2+(7*char_width)) && (yAddr>=y_off2) && (yAddr<y_off2+char_height))begin
							
							      
							      xtemp=xAddr-(x_off2+(6*char_width));
									 ytemp=yAddr-y_off2;
									
									if (A[ytemp][xtemp]== 1'b1)begin
												pixelData[15:0] <=  16'hFFE0;  //yellow
												//pixelData[15:0] <=  16'h001F;  //blue
									end
	   
									else begin
											pixelData[15:0] <=  16'h0000; 
									end 
						  			    
							end 
							else if ((xAddr>=x_off2+(7*char_width)) && (xAddr<x_off2+(8*char_width)) && (yAddr>=y_off2) && (yAddr<y_off2+char_height))begin
							
							      
							      xtemp=xAddr-(x_off2+(7*char_width));
									 ytemp=yAddr-y_off2;
									
									if (T[ytemp][xtemp]== 1'b1)begin
												pixelData[15:0] <=  16'hFFE0;  //yellow
												//pixelData[15:0] <=  16'h001F;  //blue
									end
	   
									else begin
											pixelData[15:0] <=  16'h0000; 
									end 
						  			    
							end 
							else if ((xAddr>=x_off2+(8*char_width)) && (xAddr<x_off2+(9*char_width)) && (yAddr>=y_off2) && (yAddr<y_off2+char_height))begin
							
							      
							      xtemp=xAddr-(x_off2+(8*char_width));
									 ytemp=yAddr-y_off2;
									
									if (O[ytemp][xtemp]== 1'b1)begin
												pixelData[15:0] <=  16'hFFE0;  //yellow
												//pixelData[15:0] <=  16'h001F;  //blue
									end
	   
									else begin
											pixelData[15:0] <=  16'h0000; 
									end 
						  			    
							end 
							else if ((xAddr>=x_off2+(9*char_width)) && (xAddr<x_off2+(10*char_width)) && (yAddr>=y_off2) && (yAddr<y_off2+char_height))begin
							
							      
							      xtemp=xAddr-(x_off2+(9*char_width));
									 ytemp=yAddr-y_off2;
									
									if (R[ytemp][xtemp]== 1'b1)begin
												pixelData[15:0] <=  16'hFFE0;  //yellow
												//pixelData[15:0] <=  16'h001F;  //blue
									end
	   
									else begin
											pixelData[15:0] <=  16'h0000; 
									end 
						  			    
							end 
           
					 else if ((xAddr>=x_off) && (xAddr<x_off+char_width) && (yAddr>=y_off) && (yAddr<y_off+char_height))begin
							
							      
							      xtemp=xAddr-x_off;
									 ytemp=yAddr-y_off;
									
									if (op12_char_data [ytemp][xtemp]== 1'b1)begin
												//pixelData[15:0] <=  16'hFFE0;  //yellow
												pixelData[15:0] <=  16'h001F;  //blue
									end
	   
									else begin
											pixelData[15:0] <=  16'h0000; 
									end 
						  			    
							end 
						else if ((xAddr>=x_off+char_width) && (xAddr<x_off+(2*char_width)) && (yAddr>=y_off) && (yAddr<y_off+8)) begin
														     
								
									 xtemp=xAddr-(x_off+char_width);
									 ytemp=yAddr-y_off;
									 
									if ((op11_char_data[ytemp][xtemp]== 1'b1))begin
									
												pixelData[15:0] <=  16'h001F;  //blue
									end
						         else begin
											pixelData[15:0] <=  16'h0000; 
									end 
							end
		  
							
							else if ((xAddr>=x_off+char_width+(2*space)) && (xAddr<x_off+(3*char_width)+space) && (yAddr>=y_off) && (yAddr<y_off+8)) begin
							
							      
							     
								
									 xtemp=xAddr-(x_off+char_width+(2*space));
									 ytemp=yAddr-y_off;
									 
									if ((operator_char_data[ytemp][xtemp]== 1'b1))begin
								
												pixelData[15:0] <=  16'hF800;  //red
									end
	 
	  
						  		else begin
											pixelData[15:0] <=  16'h0000; 
									end 
									end
						else if ((xAddr>=x_off+char_width+(4*space)) && (xAddr<x_off+(5*char_width)+space) && (yAddr>=y_off) && (yAddr<y_off+8)) begin
							
							      
							     
								
									 xtemp=xAddr-(x_off+char_width+(4*space));
									 ytemp=yAddr-y_off;
									 
									if ((op22_char_data[ytemp][xtemp]== 1'b1))begin
									
												pixelData[15:0] <=  16'h001F;  //blue
									end
						         else begin
											pixelData[15:0] <=  16'h0000; 
									end 
							end
							
							else if ((xAddr>=x_off+char_width+(5*space)) && (xAddr<x_off+(6*char_width)+space) && (yAddr>=y_off) && (yAddr<y_off+8)) begin
							
							      
							     
								
									 xtemp=xAddr-(x_off+char_width+(5*space));
									 ytemp=yAddr-y_off;
									 
									if ((op21_char_data[ytemp][xtemp]== 1'b1))begin
									
												pixelData[15:0] <=  16'h001F;  //blue
									end
						         else begin
											pixelData[15:0] <=  16'h0000; 
									end 
							end
	 
	                       else if ((xAddr>=x_off+char_width+(7*space)) && (xAddr<x_off+(8*char_width)+(1*space)) && (yAddr>=y_off) && (yAddr<y_off+8)) begin
							
									 xtemp=xAddr-(x_off+char_width+7*space);
									 ytemp=yAddr-y_off;
									 
									if ((equal_char_data[ytemp][xtemp]== 1'b1))begin
									
												pixelData[15:0] <=  16'hF800;  //red
									end
									else begin
											pixelData[15:0] <=  16'h0000; 
									end 
							end
									 else if ((xAddr>=x_off+char_width+(9*space)) && (xAddr<x_off+(10*char_width)+space) && (yAddr>=y_off) && (yAddr<y_off+8)) begin
							
									 xtemp=xAddr-(x_off+char_width+(9*space));
									 ytemp=yAddr-y_off;
									 
									if ((res2_char_data[ytemp][xtemp]== 1'b1))begin
									
												pixelData[15:0] <=  16'h07E0;  //green
									end
									else begin
											pixelData[15:0] <=  16'h0000; 
									end  
							end
						  else if ((xAddr>=x_off+char_width+(10*space)) && (xAddr<x_off+(11*char_width)+space) && (yAddr>=y_off) && (yAddr<y_off+8)) begin
							
									 xtemp=xAddr-(x_off+char_width+(10*space));
									 ytemp=yAddr-y_off;
									 
									if ((res1_char_data[ytemp][xtemp]== 1'b1))begin
									
												pixelData[15:0] <=  16'h3562;  //green
									end
									else begin
											pixelData[15:0] <=  16'h0000; 
									end //
			    
							end else begin
							pixelData[15:0] <=  16'h0000; 
		  
							end
					
		end
			  
end




endmodule

/*
 * N-ch_bit Up Counter
 * ----------------
 * By: Thomas Carpenter
 * Date: 13/03/2017 
 *
 * Short Description
 * -----------------
 * This module is a simple up-counter with a count enable.
 * The counter has parameter controlled width, increment,
 * and maximum value.
 *
 */

module UpCounterNch_bit2 #(
    parameter WIDTH = 10,               //10ch_bit wide
    parameter INCREMENT = 1,            //Value to increment counter by each cycle
    parameter MAX_VALUE = (2**WIDTH)-1  //Maximum value default is 2^WIDTH - 1
)(   
    input                    clock,
    input                    reset,
    input                    enable,    //Increments when enable is high
	 input  							[(WIDTH-1):0] LoadValue ,
    output reg [(WIDTH-1):0] countValue //Output is declared as "WIDTH" ch_bits wide
);

always @ (posedge clock) begin
    if (reset) begin
        //When reset is high, set back to 0
        countValue <= {(WIDTH){1'b0}};
    end else if (enable) begin
        //Otherwise counter is not in reset
        if (countValue >= MAX_VALUE[WIDTH-1:0]) begin
            //If the counter value is equal or exceeds the maximum value
          //  countValue <= {(WIDTH){1'b0}};   //Reset back to 0
			 countValue <= LoadValue; 
        end else begin
            //Otherwise increment
            countValue <= countValue + INCREMENT[WIDTH-1:0];
        end
    end
end

endmodule



