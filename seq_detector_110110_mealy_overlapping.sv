//design

module seq_detector_110110 (in, clk, reset, out);
  
  input 		in, clk, reset;
  output reg 	out;
  parameter 	s0 = 0, s1 = 1, s2 = 2, s3 = 3, s4 = 4, s5 = 5;
  reg[2:0] 			ps, ns;
  
  always @(posedge clk, posedge reset) begin
    
    if(reset)
      ps <= s0;
    else
      ps <= ns;
  end
  
  always @(ps,in) begin
    
    case (ps) 
      
      s0 : begin
        ns = in ? s1 : s0;
        out = 0;
      end
      
      s1 : begin
        ns = in ? s2 : s0;
        out = 0;
      end
      s2 : begin 
        ns = in ? s2 : s3;
        out = 0;
      end
      s3 : begin 
        ns = in ? s4 : s0;
        out = 0;
      end
      s4 : begin 
        ns = in ? s5 : s0;
        out = 0;
      end
      s5 : begin 
        ns = in ? s2 : s3;
        out = in ? 0 : 1;
      end
      default : begin 
        ns = s0;
      end
      
    endcase
  end
  
//   assign out = (ps == s5) && (in == 0) ? 1 : 0;
  
endmodule
  
        
      
  
//tb

module TB;
  
  reg 	in, clk, reset;
  wire 	out;
  
  seq_detector_110110 sd1 ( in, clk, reset, out);
  
  initial begin
    clk = 0;
    reset = 1;
    #15 reset = 0;
  end
  
  always #5 clk = ~clk;
  
  initial begin
    #12 in = 0;#10 in = 0 ; #10 in = 1 ; #10 in = 0 ; #10 in = 1 ; #10 in = 0 ;
    #10 in = 1;#10 in = 1 ; #10 in = 0 ; #10 in = 1 ; #10 in = 1 ; #10 in = 0 ;
    #10 in = 1;#10 in = 0 ; #10 in = 0 ; #10 in = 1 ; #10 in = 1 ; #10 in = 0 ;
    #10 in = 1;#10 in = 1 ; #10 in = 0 ; #10 in = 1 ; #10 in = 1 ; #10 in = 0 ;
    #10 in = 1;#10 in = 1 ; #10 in = 0 ; #10 in = 0 ; #10 in = 1 ; #10 in = 0 ;
    #10 $finish;
    
  end
  
  initial begin
    
    $dumpfile ("dump.vcd");
    $dumpvars;

  end
  
endmodule
    
    
    
  
