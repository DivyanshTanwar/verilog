//design

module d_ram #(parameter DEPTH = 8, WIDTH = 8) ( data_out, clk, rst_n, rd, wr, add, data_in);
  
  output reg [WIDTH - 1 : 0]	data_out;
  input 						clk, rst_n, rd, wr;
  input [WIDTH - 1 : 0] 		data_in;
  input [$clog2(DEPTH)-1 : 0] 	add;
  
  reg [WIDTH - 1 : 0] memory [0 : DEPTH - 1];
  
  always @(posedge clk, negedge rst_n) begin
    
    if(!rst_n)
      data_out <= 0;
    
    else begin
      
      if (wr) begin
        
        memory [add] <= data_in;
        
      end
      
    end
  end
    
    always @(posedge clk, negedge rst_n) begin
      
      if(!rst_n)
        data_out <= 0;
      
      else
        data_out <= rd ? memory[add] : 1'bz;
    end
    
endmodule
      
        
        
    
        
//tb

module tb_d_ram();
  
  parameter WIDTH = 8, DEPTH = 8;
  
  wire [WIDTH - 1 : 0]			data_out;
  reg 							clk, rst_n, rd, wr;
  reg [WIDTH - 1 : 0] 			data_in;
  reg [$clog2(DEPTH)-1 : 0] 	add;
  
  d_ram DUT (
    data_out,
    clk,
    rst_n,
    rd,
    wr,
    add,
    data_in
    
  );
  
  initial clk = 0;
  always #2 clk = ~clk;
  
  initial begin
    
    rst_n = 0;
    rd = 0;
    wr = 0;
    data_in = 0;
    
    #10 rst_n = 1;
    
  end
  
  initial begin
    
    #4 add = 8'b00000001;
    #4 data_in = 12;
    #4 wr = 1;
    #4 wr = 0;
    #4 rd = 1;
    #4 rd = 0;
    
    #50
    $finish;
    
  end
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars;
    
  end
  
endmodule
  
  
