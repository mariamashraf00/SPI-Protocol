module M_S_Integration  (
	input  clk,
input rst , 
input [1:0] slave_selection,  //01 or 10 or 11 
input mode , 
output stop , 
input recieveM,
input sendM,
input loadM,
input loadS, 
output wire [7:0] M_recieved_Data , 
output wire [7:0] S_recieved_Data,
input [7:0] Master_Data,
input [7:0] Slave1_Data,
input [7:0] Slave2_Data,
input [7:0] Slave3_Data ) ; 
 
//wire clk ; 
wire [3:1] CS  ; 
wire MOSI ; 
wire MISO ; // common MISO which have to select on them based on slave selection 
wire Slave1_MISO ; 
wire Slave2_MISO ; 
wire Slave3_MISO ; 


wire [7:0] S1_recieved_Data ;
wire [7:0] S2_recieved_Data ; 
wire [7:0] S3_recieved_Data ; 


spi_master BigMaster (clk ,
rst,
loadM,
mode,
recieveM,
sendM,
MISO,
stop,
slave_selection,
MOSI,
CS[1] , 
CS[2] ,
CS[3],
M_recieved_Data,
Master_Data
) ;


	assign MISO=( slave_selection == 2'b01 )? Slave1_MISO :
				( slave_selection == 2'b10 )? Slave2_MISO  :
				( slave_selection == 2'b11 )? Slave3_MISO :1'bx ;
	
	assign S_recieved_Data= ( slave_selection == 2'b01 )?S1_recieved_Data : 
							( slave_selection == 2'b10 )? S2_recieved_Data :
							( slave_selection == 2'b11 )? S3_recieved_Data: 7'bx ;

	spi_slave slave1 (
	clk,
	rst, 
	loadS,
	mode,
	CS[1] , 
	recieveM,
	sendM,
	MOSI,
	Slave1_MISO,
	S1_recieved_Data,
	stop,
	Slave1_Data) ; 
		

spi_slave slave2 (clk,
		rst,
		loadS, 
	mode,
	CS[2] , 
	recieveM,
	sendM,
	MOSI,
	Slave2_MISO,
	S2_recieved_Data,
	stop,
	Slave2_Data) ;
			

spi_slave slave3 (clk,
	rst, 
	loadS,
	mode,
	CS[3] , 
	recieveM,
	sendM,
	MOSI,
	Slave3_MISO,
	S3_recieved_Data,
	stop,
	Slave3_Data ) ; 
			
endmodule 