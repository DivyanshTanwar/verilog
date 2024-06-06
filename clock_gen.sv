`timescale 1ns/10ps
module tb_clockgen;
  reg clk;
  real freq = 5; // in MHz
  real tp = 1/(freq*1e6) *1e9;
  initial begin
    clk = 1'b0;
    $dumpfile("dump.vcd");
    $dumpvars(1,tb_clockgen);
    #(5*tp) $finish;
  end
  
  initial // always use loops inside an procedural block
    forever #(tp/2) clk = ~clk;
  
  //always #(tp/2) clk = ~clk; // always block with no sensitivity list repeats continuosly throughout simulation.
endmodule
