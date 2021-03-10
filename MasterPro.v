module spi_master
  (
   input clk,
   input rst,
   input load,
   input mode, 
   input recieve ,
   input send , 
   input MISO ,
   output reg stop , 
   input [1:0] Select ,
   output reg MOSI , 
   output reg CS1, 
   output reg CS2, 
   output reg CS3 , 
   output reg [7:0] All_Port,
   input  [7:0] initial_val 
   );
   
wire CPOL;     
wire CPHA;
assign CPOL  = (mode == 2) | (mode == 3);
assign CPHA  = (mode == 1) | (mode == 3);
reg [2:0] recieved_bit_counter = 3'b000  ; 
reg [2:0] sent_bit_counter  = 3'b000   ; 
reg [7:0 ] int_data ;  
always @(posedge clk ) 
begin
	if(rst )
		begin 
			recieved_bit_counter <= 0 ; 
 			sent_bit_counter	<= 0 ; 
			int_data	<= 0 ; 
			All_Port	<= 0 ; 
			stop <= 0  ; 
		end  
		else if (load)
					begin
					  All_Port <= initial_val;
					  int_data<=initial_val;
					end 
			case ( Select )
			2'b01:
				 begin 
			 	 CS1 <= 0 ; 
		      	 CS2 <= 1 ; 
		      	 CS3 <= 1 ; 
				end  	
			2'b10: 	
				 begin 
		      	 CS1 <= 1 ; 
		     	  CS2 <= 0 ; 
		     	 CS3 <= 1 ; 
				   end 
			2'b11: 
				begin 
		     			CS1 <= 1 ; 
		      		CS2 <= 1 ; 
		    		  CS3 <= 0 ; 
				end 
			endcase 
			case ( {CPOL , CPHA })
				2'b00 : if ( recieve)
					begin 
						int_data[recieved_bit_counter] <= MISO  ; 
						recieved_bit_counter = recieved_bit_counter +1 ;
							All_Port =  int_data ; 
						if ( recieved_bit_counter == 3'b111)
										stop <= 1 ; 
					end 
 				
				2'b01 : if ( send )
					begin 
							MOSI <=  All_Port[sent_bit_counter] ; 
							sent_bit_counter = sent_bit_counter+1 ; 
					end 
            			   2'b10 : if ( recieve )
					begin 
						int_data[recieved_bit_counter] <= MISO  ; 
						recieved_bit_counter = recieved_bit_counter +1 ;
							All_Port =  int_data ; 
						if ( recieved_bit_counter == 3'b111)
										stop <= 1 ;  
					end  	

				2'b11 : if ( send )
					begin 
						MOSI =  All_Port[sent_bit_counter] ; 
						sent_bit_counter = sent_bit_counter+1 ; 
					end 		
			endcase 
end 
always @(negedge clk )
begin
				case  ( {CPOL , CPHA })
 					    2'b00  :	if ( send )
								begin 
									MOSI = All_Port[sent_bit_counter] ; 
									sent_bit_counter = sent_bit_counter + 1 ; 
								end 
		
					     2'b01 :	 if ( recieve)
									begin 
									int_data[recieved_bit_counter] <= MISO  ; 
									recieved_bit_counter = recieved_bit_counter +1 ;
										All_Port =  int_data ; 									
 									if ( recieved_bit_counter == 3'b111)
										stop <= 1 ;  
							end  
					    2'b10:if ( send)
								begin 
									MOSI =  All_Port[sent_bit_counter] ; 
									sent_bit_counter = sent_bit_counter+1 ;
								end 
					   2'b11:if ( recieve )
								begin 
									int_data[recieved_bit_counter] = MISO  ; 
									recieved_bit_counter = recieved_bit_counter +1 ;
									All_Port =  int_data ; 
									if ( recieved_bit_counter == 3'b111)
									stop <= 1 ; 
							end  
				 endcase 
    			end 
endmodule 