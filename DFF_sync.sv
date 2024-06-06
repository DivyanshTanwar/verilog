//design
module DFF ( q, d, reset, clk); //synchronous DFF
  output reg q;
  input d, reset, clk;
  
  always @(posedge clk) begin
    if(reset) //active high reset
      q <= 1'b0;
    else
      q <= d;
  end
endmodule


//tb
module tb_DFF;
  reg d, reset,clk;
  wire q;
  
  DFF d1 (.q(q), .d(d), .reset(reset), .clk(clk));
  
  initial begin
    clk <= 1'b0;
    d <= 1'b0;
    reset <= 1'b0;
  end
  
  always #5 clk = ~ clk;
  
  initial begin
    $monitor("[%0t] clk = %b reset = %b d = %b q = %b",$time,clk,reset,d,q);
    $dumpfile("DFF_tb.vcd");
    $dumpvars;
    #200 $finish;
  end
  
  always #5 d = ~d;
  always #8 reset = ~ reset;
endmodule
  

