module char_operator(	  // I/O Declaration
    input  [7:0] char_operator,
	  input              clock,
   
    output reg [7:0] char_data0,
	 output reg [7:0] char_data1,
	 output reg [7:0] char_data2,
	 output reg [7:0] char_data3,
	 output reg [7:0] char_data4,
	 output reg [7:0] char_data5,
	 output reg [7:0] char_data6,
	 output reg [7:0] char_data7
   
);




reg [9:0]  in_addrs;
wire [7:0] total_char_data[0:7];
reg [7:0] char_data[0:7];
reg  [ 7:0] i;


 
 // extracting the addrress of each operator character in ROM from the entered operator code
always @ * begin
	 case (char_operator) 
8'd20: in_addrs = 10'o530; //    +
8'd21: in_addrs = 10'o550; //    -
8'd22: in_addrs = 10'o520; //    *
8'd23: in_addrs = 10'o570; //    /
8'd24: in_addrs = 10'o460; //    &
8'd25: in_addrs = 10'o410;  //   |
8'd26: in_addrs = 10'o720;   //   =
8'd27: in_addrs = 10'o670;
8'd28: in_addrs = 10'o700;
8'd29: in_addrs = 10'o710;


default: in_addrs=10'o400; // space
endcase
end
	
	
	
	// instantiating the character ROM memory module 8 times to retrieve  the 8 bytes of each char
// the character rom module is initialised by a memory initialization file that contain the binary values of the operators
	 char_rom  rom0(
	.address(in_addrs),
	.clock(clock),
	.q(total_char_data[0])
	 );

char_rom  rom2(
	.address(in_addrs+1),
	.clock(clock),
	.q(total_char_data[1])
	 );

	 char_rom  rom3(
	.address(in_addrs+2),
	.clock(clock),
	.q(total_char_data[2])
	 );
	 
	 char_rom  rom4(
	.address(in_addrs+3),
	.clock(clock),
	.q(total_char_data[3])
	 );
char_rom  rom5(
	.address(in_addrs+4),
	.clock(clock),
	.q(total_char_data[4])
	 );
	 
	 char_rom  rom6(
	.address(in_addrs+5),
	.clock(clock),
	.q(total_char_data[5])

	 );
	 char_rom  rom7(
	.address(in_addrs+6),
	.clock(clock),
	.q(total_char_data[6])
	
	 );
	 
	 char_rom  rom1(
	.address(in_addrs+7),
	.clock(clock),
	.q(total_char_data[7])
	 );
 

 
always @ * begin	 
char_data[0]=total_char_data[0];	 
char_data[1]=total_char_data[1];
char_data[2]=total_char_data[2];
char_data[3]=total_char_data[3];
char_data[4]=total_char_data[4];
char_data[5]=total_char_data[5];
char_data[6]=total_char_data[6];
char_data[7]=total_char_data[7];	 

// this for loop to reverse the bits order in the byte , because the data coming from the ROM is MSB first 
   for (i = 0; i <=7; i = i + 1) begin 
     char_data[0][i]<=total_char_data[0][7-i];
	  char_data[1][i]<=total_char_data[1][7-i];
	  char_data[2][i]<=total_char_data[2][7-i];
	  char_data[3][i]<=total_char_data[3][7-i];
	  char_data[4][i]<=total_char_data[4][7-i];
	  char_data[5][i]<=total_char_data[5][7-i];
	  char_data[6][i]<=total_char_data[6][7-i];
	  char_data[7][i]<=total_char_data[7][7-i];
 
 
   end
char_data0=	char_data[0];
char_data1=	char_data[1];
char_data2=	char_data[2];
char_data3=	char_data[3];
char_data4=	char_data[4];
char_data5=	char_data[5];
char_data6=	char_data[6];
char_data7=	char_data[7];
 end
 
 
 endmodule