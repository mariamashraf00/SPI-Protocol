module Slave_tb();
  reg clk;
  reg rst;
  reg [7:0] Data_in;
  wire [7:0] Data_out;
  reg [7:0] Data_recieved;
  reg mode;
  reg CS   ; 
  reg send ;
  reg recieve;
  reg  MOSI;
  wire MISO; 
  wire stop; 
  reg load;
  reg [7:0] initial_val = 8'b00110011;
  integer i = 0;
   always #5 clk = ~ clk;
   initial begin
     $display("Testing sending and receiving the same data from the slave at mode 0");
     clk=0;
     rst=0;
     CS=0;
     mode=0;
     load = 1;
     #10 load = 0;
    $display("Test 1: Sending data to the slave ");
     Data_in=8'b00001111;
     send=0;
     recieve=1;
     for (i=0;i<8;i=i+1)
     begin
      MOSI = Data_in[i];
      #10;
     end
     #10
        if (Data_out == Data_in)
          begin
            $display("Data sent to the slave successfully");
            $display("Input = %b",Data_in);
            $display("Expected Output = %b",Data_in);
            $display("Actual Output = %b",Data_out);
      end
      $display("Test 2 : Receiving data from the slave ");
      $display("Last data inside the slave is:%b",Data_out);
     send=1;
     recieve=0;
     i=0;
     for (i=0;i<8;i=i+1)
     begin
       #10;
       Data_recieved[i]=MISO;
       $display("Data_recieved= %b",Data_recieved);
     end
     #10;
     send=0;
     recieve=0;
        if (Data_recieved == Data_out)
          begin
            $display("Data recieved from the slave successfully");
            $display("Data stored in slave = %b",Data_out);
            $display("Data recieved from slave = %b",Data_in);
      end
      $display("Test 3 : Sending & Receiving data from the slave at the same time");
      Data_in = 8'b00111000;
      MOSI = Data_in[0];
      $display("New Data_in is:%b",Data_in);
     send=1;
     recieve=1;
     i=0;
     for (i=1;i<=8;i=i+1)
     begin
       Data_recieved[i-1]=MISO;
       MOSI = Data_in[i];
       $display("Data_recieved= %b   Data_sent = %b",Data_recieved,Data_out);
       #10;
     end
     $finish;
   end
   
   spi_slave Slave
 (clk , 
  rst ,
  load,
  mode,
  CS   , 
  send ,
  recieve, 
  MOSI,
  MISO ,  
  Data_out ,
  stop, 
  initial_val
); 
endmodule

