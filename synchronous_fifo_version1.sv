//design

module sync_fifo (
  
  input 			clk,
  input 			rst_n,
  
  input 			wr_en,			//write side signals
  input [7:0] 		data_input,
  output reg 		full,
 	 
  input 			rd_en,			//read side signals
  output reg		empty,			
  output reg [7:0]	data_out
);
  
  parameter DEPTH = 8;
  
  reg [7:0] memory [0 : DEPTH - 1];	//memory defined
  
  reg [2:0] wr_ptr;
  reg [2:0] rd_ptr;
  reg [3:0] count;
  
  assign full = (count == DEPTH); //assigning full and empty conditions
  assign empty = (count == 0);
  
  //writing process
  
  always @(posedge clk, negedge rst_n) begin
    
    if (!rst_n) 
      
      wr_ptr <= 0;
    
    else begin
      
      if (wr_en & !full) begin
        
        memory [wr_ptr] <= data_input;
        wr_ptr <= wr_ptr + 1;
        
      end
      
    end
      
  end
  
  //reading process
  
  always @(posedge clk, negedge rst_n) begin
    
    if (!rst_n) 
      
      rd_ptr <= 0;
    
    else begin
      
      if(rd_en & !empty) begin
        
        data_out <= memory[rd_ptr];
        rd_ptr <= rd_ptr + 1;
        
      end
      
    end
    
  end
  
  //handling count
  
  always @(posedge clk, negedge rst_n) begin
    
    if (!rst_n)
      
      count <= 4'b0000;
    
    else begin
      
      case ({rd_en,wr_en})
        
        2'b01 : count <= count + 1;
        2'b10 : count <= count - 1;
        2'b00 : count <= count;
        2'b11 : count <= count;
        default : count <= count;
        
      endcase
      
    end
    
  end
  
endmodule
  
  
//tb

`timescale 1ns/1ps
`define clk_period 10

module tb_sync_fifo();
  reg clk;
  reg rst_n;
  
  reg wr_en;
  reg [7:0] data_input;
  wire full;
  
  reg rd_en;
  wire empty;
  wire [7:0] data_out;
  
  integer i;
  
  sync_fifo fifo1(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(wr_en),
    .data_input(data_input),
    .full(full),
    .rd_en(rd_en),
    .empty(empty),
    .data_out(data_out)
  );
  
  initial 
    clk = 0;
  
  always #(`clk_period/2) clk = ~clk;
  
  initial begin
    
    rst_n = 1'b1;
    
    rd_en = 1'b0;
    wr_en = 1'b0;
    
    data_input = 8'b0;
    
    #(`clk_period);
    
    rst_n = 1'b0; //reset system
    
    #(`clk_period);
    
    rst_n = 1'b1; //finish reset
    
    #(`clk_period);
    
    rd_en = 1'b0; // writing data
    wr_en = 1'b1;
    
    for (i = 0; i < 8 ; i = i + 1) begin
      
      data_input = i;
      #(`clk_period);
      
      
    end
    
    rd_en = 1'b1; // reading data
    wr_en = 1'b0;
    
    for (i = 0; i < 8 ; i = i + 1) begin
      
      #(`clk_period);
      
      
    end
    
    rd_en = 1'b0; // writing data
    wr_en = 1'b1;
    
    for (i = 0; i < 8 ; i = i + 1) begin
      
      data_input = i;
      #(`clk_period);
      
      
    end
    
    #(`clk_period);
    #(`clk_period);
    #(`clk_period);
    $finish;
    
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
endmodule
  
  
