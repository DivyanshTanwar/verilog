//design

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

module tb_dlatch;
  reg d, enable, reset;
  wire Q;
  integer i;
  reg [2:0] delay; //to provide random delay to enable and input signals
  reg [2:0] delay2;
  
  DLatch d1 (.Q(Q), .d(d), .clk(enable), .reset(reset)); //instantiation on dlatch
  
  initial begin
    $monitor("[%0t] enable = %0b d = %0b Q = %0b",$time,enable,d,Q);
    enable <= 0; // initializing all variables
    d <= 0;
    reset <=1;
    
    #20 reset <= 0;
    
    $dumpfile("dump.vcd");
    $dumpvars;
//     #200 $finish;
    
    for( i = 0; i<5; i = i+1) begin
      delay = $random;
      delay2 = $random;
      #(delay) enable <= ~enable;
      #(delay2) d <= i;
    end
  end
  
  
endmodule
  
