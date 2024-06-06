//design

module sq_110110 ( in, clk, reset, out);
  
  input 	in, clk, reset;
  output 	out;
  parameter	s0 = 0, s1 = 1, s2 = 2, s3 = 3, s4 = 4, s5 = 5, s6 = 6;
  reg[2:0] 	ps, ns;
  
  always @(posedge clk, posedge reset) begin
    
    if(reset)
      ps <= s0;
    
    else
      ps <= ns;
    
  end
  
  always @(ps,in) begin
    
    case(ps)
      
      s0 : ns <= in ? s1 : s0;
      s1 : ns <= in ? s2 : s0;
      s2 : ns <= in ? s2 : s3;
      s3 : ns <= in ? s4 : s0;
      s4 : ns <= in ? s5 : s0;
      s5 : ns <= in ? s2 : s6;
      s6 : ns <= in ? s1 : s0;
      default : ns <= s0;
      
    endcase
  end
  
  assign out = (ps == s6) ? 1 : 0;
  
endmodule
  


//tb

module TB;
  
  reg 	in, clk, reset;
  wire 	out;
  
  sq_110110 sq1 (in, clk, reset, out);
  
  initial begin
    
    clk = 0;
    reset = 1;
    
  end
  
  always #2 clk = ~clk;
  
  initial begin
    in = 0;
    #2 reset = 0;
    #3 in = 0;
    #4 in = 1;
	#4 in = 1;
    #4 in = 0;
    #4 in = 1;
    #4 in = 1;
    #4 in = 0;
    #4 in = 0;
    #4 in = 0;
    #4 in = 1;
    #4 in = 1;
    #4 in = 0;
    #4 in = 1;
    #4 in = 1;
    #4 in = 0;
    #4 in = 1;
    #4 in = 1;
    #4 in = 0;
    #4 in = 1;
    #4 in = 1;
    #4 in = 1;
    
    #10;
    
    $finish;
    
  end
  
  initial begin
    
    $dumpfile ("dump.vcd");
    $dumpvars;

  end
  
endmodule
    
  
  
