//design

module pipelining_operation (
  
  input clk,
  input rst,
  output result
  
);
  
  reg [31:0] count;
  wire [7:0] A,B,C,D,E,F;
  
  reg [7:0] E1,E2,F1,F2,F3;
  
  assign A = count[7:0];
  assign B = count[15:8];
  assign C = count[23:16];
  assign D = count[31:24];
  
  assign F = F3;
  assign E = E2;
  
  //pipelining for E (Every Second clock cycle)
  
  always @(posedge clk, posedge rst) begin
    
    if(rst) begin
      
      E1 <= 0;
      E2 <= 0;
      
    end
    
    else begin
      
      E1 <= (B & C);
      E2 <= A | E1;
      
    end
    
  end
  
  //pipelining for F (every 3rd clock cycle)
  
  always @(posedge clk, posedge rst) begin
    
    if(rst) begin
      
      F1 <= 0;
      F2 <= 0;
      F3 <= 0;
      
    end
    
    else begin
      
      F1 <= (B & C);
      F2 <= (A | D);
      F3 <= F1 ^ F2;
      
    end
    
  end
  
  always @(posedge clk, posedge rst) begin
    
    if(rst) begin
      
      count <= 0;
      
    end
    
    else 
      
      count <= count + 1;
    
  end

endmodule


//tb

module tb_pipelining_operation();
  
  reg clk, rst;
  wire result;
  
  pipelining_operation DUT (
    
    .clk(clk),
    .rst(rst),
    .result(result)
  
  );
  
  initial begin
    
    clk = 0;
    forever #5 clk = ~clk;
    
  end
  
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars();
    
    rst = 1;
    #10 rst = 0;
    
    #10000 $finish;
    
  end
  
endmodule
