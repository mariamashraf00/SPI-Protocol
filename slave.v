module spi_slave
 ( input clk , 
   input rst ,
   input load,
   input mode,
   input CS   , 
   input sendValid ,
   input recievedValid , 
   input  MOSI,
   output reg MISO ,  
   output reg [7:0] All_port , 
   output reg stop,
   input  [7:0] initial_val 
) ; 
wire CPOL;     
wire CPHA;
assign CPOL  = (mode == 2) | (mode == 3);
assign CPHA  = (mode == 1) | (mode == 3);
reg [7:0] int_data ; 
reg [2:0] recieved_bit_count = 3'b000  ; 
reg [2:0] send_bit_count = 3'b000 ;  
 always @(posedge clk )
 begin 
			if (rst) 
				begin 
				recieved_bit_count <= 0 ; 
 				send_bit_count	<= 0 ; 
				int_data	<= 0 ; 
				All_port 	<= 0 ; 
				 stop           <= 0  ; 
					end
					else if (load)
					begin
					  All_port <= initial_val;
					  int_data<=initial_val;
					end 
			 if ( !CS  ) 
						case ( {CPOL , CPHA }) 
						2'b00 : if ( recievedValid ) 
								begin 
									int_data[recieved_bit_count] <= MOSI ;
										All_port = int_data ;  
									recieved_bit_count  = recieved_bit_count+1 ; 
 									if ( recieved_bit_count == 3'b111)
										stop <= 1 ;
	    							end 
						2'b01 : if ( sendValid)
								begin
									MISO <= All_port[send_bit_count] ;
									send_bit_count = send_bit_count +1 ;
    					    			  end		

						2'b10 :if ( recievedValid ) 
								begin 
									int_data[recieved_bit_count] <= MOSI ; 
									All_port = int_data ;  
									recieved_bit_count  = recieved_bit_count+1 ; 
 									if ( recieved_bit_count == 3'b111)
										stop <= 1 ; 
	    							end 
						2'b11 : if ( sendValid)
								begin
									MISO =  All_port [send_bit_count] ;
									send_bit_count = send_bit_count +1 ; 
    					    			  end		
						endcase 

				end

always@(negedge clk ) 
begin
		if ( !CS ) 
			begin 
			case ({CPOL , CPHA })

			2'b00 :if ( sendValid)
					begin
							MISO <= All_port[send_bit_count] ;
							send_bit_count = send_bit_count +1 ; 
    					  end	
			2'b01 :  if ( recievedValid ) 
								begin 
									int_data[recieved_bit_count] <= MOSI ;
										All_port = int_data ;  
									recieved_bit_count  = recieved_bit_count+1 ; 
 									if ( recieved_bit_count == 3'b111)
										stop <= 1 ; 

								end 

			2'b10 :if ( sendValid)
					                      begin

							       MISO <= All_port[send_bit_count] ;
							       send_bit_count = send_bit_count +1 ; 
    					                        
                    						 end		
			2'b11 : if ( recievedValid ) 
								begin 
									int_data[recieved_bit_count] <= MOSI ;
										All_port = int_data ;  
									recieved_bit_count  = recieved_bit_count+1 ; 
 									if ( recieved_bit_count == 3'b111)
										stop <= 1 ;
								end 

			endcase  
	end 
 end 
endmodule 