module Master_tb();
   reg clk;
   reg rst;
   reg mode;
   reg recieve;
   reg send;
   reg MISO ;
   wire stop;
  reg [1:0] Select ;
  wire MOSI ;	
  wire CS1;
  wire CS2; 
  wire CS3 ; 
  wire [7:0] Data_out; 
  reg [7:0] Data_in;
  reg [7:0] Data_recieved;
  reg load;
  reg [7:0] initial_val = 8'b00110011;
  integer i = 0;
  always #5 clk = ~ clk;
   initial begin
     $display("Testing sending and receiving the same data from the master at mode 0");
     clk=0;
     rst=0;
     mode=0;
     load = 1;
     #10 load = 0;
     $display("Test 1: Sending data to the master ");
     Select = 1;
     Data_in = 8'b10101010;
     send=0;
     recieve=1;
     for (i=0;i<8;i=i+1)
     begin
      MISO = Data_in[i];
      #10;
     end
     #10
        if (Data_out == Data_in)
          begin
            $display("Data sent to the master successfully");
            $display("Input = %b",Data_in);
            $display("Expected Output = %b",Data_in);
            $display("Actual Output = %b",Data_out);
          end
      $display("Test 2 : Receiving data from the master");
      $display("Last data inside the master is:%b",Data_out);
     send=1;
     recieve=0;
     i=0;
     for (i=0;i<8;i=i+1)
     begin
       #10;
       Data_recieved[i]=MOSI;
       $display("Data_recieved= %b",Data_recieved);
     end
     #10;
    send=0;
     recieve=0;
        if (Data_recieved == Data_out)
          begin
            $display("Data recieved from the master successfully");
            $display("Data stored in master = %b",Data_out);
            $display("Data recieved from master = %b",Data_in);
          end
          $display("Test 3 : Sending & Receiving data from the master");
      Data_in = 8'b00001111;
       MISO= Data_in[0];
      $display("New Data_in is:%b",Data_in);
     send=1;
     recieve=1;
     i=0;
     for (i=1;i<=8;i=i+1)
     begin
        MISO= Data_in[i];
       Data_recieved[i-1]=MOSI;
        $display("Data_recieved= %b   Data_sent = %b",Data_recieved,Data_out);
       #10;
     end
     $display("Data_recieved= %b   Data_sent = %b",Data_recieved,Data_out);
     $finish;
      end
spi_master Master
 (clk , 
  rst ,
  load,
  mode,
  recieve,
  send,
  MISO,
  stop,
  Select,
  MOSI,
  CS1,
  CS2,
  CS3,  
  Data_out,
  initial_val  
); 
endmodule
