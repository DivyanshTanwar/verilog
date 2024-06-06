//design
module FullAdder ( A, B, C_in , sum, C_out);
  output reg sum, C_out;
  input A,B,C_in;
  
  assign sum = A^B^C_in;
  assign C_out = A&B | B&C_in | C_in&A;
  
endmodule

//tb

module tb_FA;
  reg A,B,C_in;
  wire sum, C_out;
  integer i;
  
  FullAdder F1 ( .A(A), .B(B), .C_in(C_in), .sum(sum), .C_out(C_out));
  
  initial begin
    $dumpfile("FAdump.vcd");
    $dumpvars;
    
    for( i = 0; i<8 ; i= i+1)begin
      {A,B,C_in} <= i; #5;
      $display("[%0t] A = %0b B = %0b C = %0b sum = %0b C_out = %0b",$time,A,B,C_in,sum,C_out);
    end
    
    #5 $finish;
    
  end
endmodule
