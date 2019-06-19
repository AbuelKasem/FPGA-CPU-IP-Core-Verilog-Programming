module char_letter (	  // I/O Declaration
    input  [9:0] char_address,   //address of the character in the character ROM
	  input              clock,
   
    output reg [7:0] char_data0,   // 8 BYTES of each character
	 output reg [7:0] char_data1,
	 output reg [7:0] char_data2,
	 output reg [7:0] char_data3,
	 output reg [7:0] char_data4,
	 output reg [7:0] char_data5,
	 output reg [7:0] char_data6,
	 output reg [7:0] char_data7
   
);





wire [7:0] total_char_data[0:7];
reg [7:0] char_data[0:7];
reg  [ 7:0] i;

// instantiating the character ROM memory module 8 times to retrieve  the 8 bytes of each char
// the character rom module is initialised by a memory initialization file that contain the binary values of the lettrers
// numbers and  operators

	 char_rom  rom0(     
	.address(char_address),
	.clock(clock),
	.q(total_char_data[0])
	 );

char_rom  rom2(
	.address(char_address+1),
	.clock(clock),
	.q(total_char_data[1])
	 );

	 char_rom  rom3(
	.address(char_address+2),
	.clock(clock),
	.q(total_char_data[2])
	 );
	 
	 char_rom  rom4(
	.address(char_address+3),
	.clock(clock),
	.q(total_char_data[3])
	 );
char_rom  rom5(
	.address(char_address+4),
	.clock(clock),
	.q(total_char_data[4])
	 );
	 
	 char_rom  rom6(
	.address(char_address+5),
	.clock(clock),
	.q(total_char_data[5])

	 );
	 char_rom  rom7(
	.address(char_address+6),
	.clock(clock),
	.q(total_char_data[6])
	
	 );
	 
	 char_rom  rom1(
	.address(char_address+7),
	.clock(clock),
	.q(total_char_data[7])
	 );
 

 // assigning the data out of the ROM to another array
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