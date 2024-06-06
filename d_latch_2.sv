
//Design
module DLatch ( output reg Q , input d, input clk, input reset );
  always @(clk or d or reset) begin // asynchronous reset
    if (reset) //active high reset
      Q <= 0;
    else begin
      if(clk)
        Q <= d;
    end
    
  end
  
endmodule


//tb

module tb_dlatch2;
  reg d, clk, reset;
  wire Q;
  
  DLatch d1 (.Q(Q), .d(d), .clk(clk), .reset(reset));
  
  initial begin
    $monitor("[%0t] clk = %0b reset = %0b d = %0b Q = %0b",$time,clk,reset,d,Q);
    d <= 0;
    reset <= 1;
    clk <= 0;
    
    $dumpfile("dump2.vcd");
    $dumpvars;
    #200 $finish;
  end
  
  always #3 d = ~d;
  always #5 clk = ~clk;
  always #8 reset = ~reset;
  
endmodule
