//design

module pulse_generator #(parameter DURATION = 2, PERIOD = 3) (
  
  input clk,
  input rst,
  output reg pulse
);
  
  reg [$clog2(PERIOD) - 1 : 0] count;
  
  initial begin
    
    if ( DURATION >= PERIOD) begin
      
      $display("Error: PULSE_DURATION should be less than PULSE_PERIOD.");
      $finish;
      
    end
    
  end
  
  always @(posedge clk or posedge rst) begin
    
    if(rst) begin
      
      count <= 0;
      pulse <= 0;
      
    end
    
    else begin
      
      if ( count < PERIOD - 1 )  // PERIOD-1  because there is Non blocking assignment (check waveform for more clear understanding) 
        
        //(for period = 5)when count becomes 4 its value get updated to 0 but  the value is only updated after that particular time period and hence in next if condition it is treated as 4 itself.
        
        
        
        count <= count +  1;
      
      else
        count <= 0;
      
      if ( count < DURATION )
        pulse <= 1;
      
      else
        pulse <= 0;
        
    end
    
  end
  
endmodule



//tb

module tb_pulse_generator #(parameter DURATION = 2, PERIOD = 3) ();
  
  reg clk;
  reg rst;
  wire pulse;
  
  pulse_generator#(.DURATION(DURATION), .PERIOD(PERIOD)) DUT(
    .clk(clk),
    .rst(rst),
    .pulse(pulse)
  );
  
  int clk_count;
  int high_count;
  int pass;
  
  
  initial begin
    
   	clk_count = 0;
    high_count = 0;
    pass = 1;
    
  end
  
  always @(posedge clk) begin
    
    if(rst) begin
      
      clk_count = 0;
      high_count = 0;
      
    end
    
    else begin
      
      if (pulse) 
        high_count = high_count + 1;
      
      clk_count = clk_count + 1;
      
      if( clk_count == PERIOD) begin
        
        if( high_count != DURATION) begin
          pass = 0;
          $display("Pulse duration is %d , expected was %d",high_count,DURATION);
        end
        
        else begin
          clk_count = 0;
          high_count = 0;
          
        end
        
        
      end
      
    end
    
  end
  
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars();
    
    rst = 1;
    
    #10 rst = 0;
    
    #100;
    
    if(pass) begin
      
      $display("Passed");
      
    end
    
    else begin
      
      $display("failed");
      
    end
    
    $finish;
    
  end
  
endmodule;
