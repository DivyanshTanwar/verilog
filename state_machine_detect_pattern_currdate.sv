//design

module top_module(
  
  input clk,
  input rst,
  input [4:0] date,
  input [3:0] month,
  output detected,
  output reg [8:0] detected_pattern
  
);
  
  wire [8:0] pattern;
  wire [9:0] data;
  wire serial_data;
  
  pattern_generator pg(
    .date(date),
    .month(month),
    .pattern(pattern)
  );
  
  data_generator dg (
    .clk(clk),
    .rst(rst),
    .data(data)
  );
  
  piso p (
    .clk(clk),
    .rst(rst),
    .parallel_data(data),
    .serial_out(serial_data)
  
  );
  
  detector dt (
    .clk(clk),
    .rst(rst),
    .serial_in(serial_data),
    .pattern(pattern),
    .detected(detected),
    .detected_pattern(detected_pattern)
  );
  
    
  
  
endmodule
  
module pattern_generator(
  
  input [4:0] date,
  input [3:0] month,
  output reg [8:0] pattern
  
);
  
  always @(*) begin
    
    pattern <= {month,date};
    
  end
  
  
endmodule

module data_generator (
  
  input clk,
  input rst,
  output reg[9:0] data
  
);
  
  reg [3:0] count;
  
  always @(posedge clk or posedge rst) begin
    
    if(rst) begin
      
      count <=0;
      data <=0;
      
    end
    
    else begin
      
      if(count == 9) begin
        
        data <= data + 1;
        count <=0;
        
      end
      
      else 
        count <= count + 1;
      
    end
    
    
  end
  
endmodule

module piso (
  
  input clk,
  input rst,
  input [9:0] parallel_data,
  output reg serial_out
  
);
  
  reg [3:0] count;
  
  
  always @(posedge clk or posedge rst) begin
    
    if(rst) begin
      count <= 0;
      serial_out <= 0;
    end
    
    else begin
      
      serial_out <= parallel_data[count];
      
      if(count == 9) begin
        
        count <= 0; 
        
      end
      
      else 
        
        count <= count + 1;
      
    end
    
    
  end
  
  
endmodule
      
      
module detector(
  
  input clk,
  input rst,
  input[8:0] pattern,
  input serial_in,
  
  output reg [8:0] detected_pattern,
  output reg detected
 
);
  
    reg[8:0] data;

  
  always @(posedge clk, posedge rst) begin
    
    if(rst) begin
      
      detected <= 0;
      
    end
    
    else begin
      
      data <= {data[7:0],serial_in};
      
      if(data == pattern) begin
        detected <= 1;
        detected_pattern <= data;
      end
      
      else
        detected <= 0;
      
    end
    
  end
  
endmodule

  
//tb

module tb_top_module();
  
  reg clk,rst;
  reg [4:0] date;
  reg [3:0] month;
  wire detected;
  wire [8:0] detected_pattern;
  
  top_module dut (
    .clk(clk),
    .rst(rst),
    .date(date),
    .month(month),
    .detected(detected),
    .detected_pattern(detected_pattern)
  );
   
  initial begin
    
    clk = 0;
    forever #2 clk = ~clk;
    
  end
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars();
    
    rst = 1;
    
    date = 5'd11;
    month = 4'd6;
    
    #3 rst = 0;
    
    
    #10000 $finish;
     
  end
  
  always @(posedge clk) begin
    if (detected && detected_pattern == {month,date}) begin
      $display("Detected pattern: %0d", detected_pattern);
    end
  end
  
endmodule
