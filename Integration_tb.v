//`timescale  1ns / 1ps        

module tb_M_S_Integration;   

// M_S_Integration Parameters
parameter PERIOD  = 10;
/*>>>>>>>>>>>>>>>>>>>>>>            Mohamed Notes          <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
//Comments are wrong things 

// M_S_Integration Inputs
reg   clk                                    =0;
reg   rst                                  = 0 ;
reg   [1:0]  slave_selection               = 2'b01 ;
reg   mode                                 = 0 ;
wire  stop ;                                //= 0 ;
reg   recieveM                             = 0 ;
reg   sendM                                = 0 ;
reg   loadM                                = 1 ;
reg   loadS                                = 1 ;
reg   [7:0]  Master_Data                   = 8'b11110000 ;
reg   [7:0]  Slave1_Data                   = 8'b10101010 ;
reg   [7:0]  Slave2_Data                   = 8'b10101010 ;
reg   [7:0]  Slave3_Data                   = 8'b10101010 ;

// M_S_Integration Outputs
wire  [7:0]  M_recieved_Data               ;
wire  [7:0]  S_recieved_Data               ;
integer i=0;

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end



M_S_Integration  u_M_S_Integration (
    .clk                     ( clk                    ),
    .rst                     ( rst                    ),
    .slave_selection         ( slave_selection  [1:0] ),
    .mode                    ( mode                   ),
    .stop                    ( stop                   ),
    .recieveM                ( recieveM               ),
    .sendM                   ( sendM                  ),
    .loadM                   ( loadM                  ),
    .loadS                   ( loadS                  ),
    .Master_Data             ( Master_Data      [7:0] ),
    .Slave1_Data             ( Slave1_Data      [7:0] ),
    .Slave2_Data             ( Slave2_Data      [7:0] ),
    .Slave3_Data             ( Slave3_Data      [7:0] ),

    .M_recieved_Data         ( M_recieved_Data  [7:0] ),
    .S_recieved_Data         ( S_recieved_Data  [7:0] )
);

initial
begin
    //////////////////////////TEST 1
    $display("initialising master with 11110000 and slave1 with 10101010\n");
    #PERIOD
    #PERIOD
    loadM=0;
    loadS=0;
    #PERIOD
    $display("Data exchange initiated\n");
    recieveM                             = 1 ;
    sendM                                = 1;
   // #(PERIOD*8)
   for (i =0 ;i<8 ;i=1+i ) begin
       #PERIOD
       $display("MasterData=%b        Slave1=%b\n",M_recieved_Data,S_recieved_Data);
   end
   // $display("MasterData=%b        Slave1=%b\n",M_recieved_Data,S_recieved_Data);
    if(M_recieved_Data==8'b10101010 && S_recieved_Data==8'b11110000 )begin
        $display("Data Exchange Successfull\n\n");
    end else begin
        $display("Data Exchange Fail\n\n");
    end
    #PERIOD
    ///////////////////////////////////////////////////////////////////////////////////////////TEST2
    rst=1;
    #PERIOD
    
    rst=0;
    slave_selection=2'b10;
    loadM=0;
    loadS=0;
    sendM=0;
    recieveM=0;
    #PERIOD/////////
  //  rst=0;
    //slave_selection=2'b10;
    loadM=1;
    loadS=1;
    sendM=0;
    recieveM=0;
    Master_Data= 8'b10000001 ;
    Slave2_Data= 8'b10000011 ;
    $display("initialising master with b10000001 and slave2 with b10000011\n");
    #PERIOD
    $display("Data exchange initiated\n");
    rst=0;
    loadM=0;
    loadS=0;
    sendM=1;
    recieveM=1;
    //#(PERIOD*8)
    for (i =0 ;i<8 ;i=1+i ) begin
       #PERIOD
       $display("MasterData=%b        Slave2=%b\n",M_recieved_Data,S_recieved_Data);
    end
    //$display("MasterData=%b        Slave2=%b\n",M_recieved_Data,S_recieved_Data); 
    if(M_recieved_Data==8'b10000011 && S_recieved_Data==8'b10000001 )begin
        $display("Data Exchange Successfull\n\n");
    end else begin
        $display("Data Exchange Fail\n\n");
    end
    #PERIOD
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Slave3 TEST
rst=1;
    #PERIOD
    
    rst=0;
    slave_selection=2'b11;
    loadM=0;
    loadS=0;
    sendM=0;
    recieveM=0;
    #PERIOD/////////
  //  rst=0;
    //slave_selection=2'b10;
    loadM=1;
    loadS=1;
    sendM=0;
    recieveM=0;
    Master_Data= 8'b11111111 ;
    Slave3_Data= 8'b11001100 ;
    $display("initialising master with b11111111 and slave3 with b11001100\n");
    #PERIOD
    $display("Data exchange initiated\n");
    rst=0;
    loadM=0;
    loadS=0;
    sendM=1;
    recieveM=1;
    //#(PERIOD*8)
    for (i =0 ;i<8 ;i=1+i ) begin
       #PERIOD
       $display("MasterData=%b        Slave3=%b\n",M_recieved_Data,S_recieved_Data);
     end
    //$display("MasterData=%b        Slave3=%b\n",M_recieved_Data,S_recieved_Data); 
    if(M_recieved_Data==8'b11001100 && S_recieved_Data==8'b11111111 )begin
        $display("Data Exchange Successfull\n\n");
    end else begin
        $display("Data Exchange Fail\n\n");
    end
    #PERIOD
    $finish;
end

endmodule