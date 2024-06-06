//design
module sync_fifo #(parameter DEPTH = 8, WIDTH = 16)(
  
  input 					clk,
  input 					rst_n,
  
  input 					wr_en,
  input [WIDTH-1 : 0] 		data_in,
  output reg 				full,
  
  input 					rd_en,
  output reg 				empty,
  output reg [WIDTH-1 : 0] 	data_out
  
);
  
  reg [WIDTH-1 : 0] memory [0 : DEPTH-1]; 		//declaring memory
  reg [$clog2(DEPTH)-1 : 0] wr_ptr, rd_ptr; 	//read and write pointers
  
  assign full = ((wr_ptr + 1) == rd_ptr); 		//empty and full condn of fifo
  assign empty = (wr_ptr == rd_ptr);
  
  //writing in fifo
  
  always @(posedge clk, negedge rst_n) begin
    
    if (!rst_n)
      wr_ptr <= 0;
    
    else begin
      
      if (wr_en & !full) begin			//checking if the fifo is full and write enable is high
        
        memory [wr_ptr] <= data_in;
        wr_ptr <= wr_ptr + 1;
        
      end
      
    end
    
  end
  
  //reading from fifo
  
  always @(posedge clk, negedge rst_n) begin
    
    if (!rst_n)
      rd_ptr <= 0;
    
    else begin
      
      if (rd_en & !empty) begin 		//checking if the fifo is empty and read enable is high
        
        data_out <= memory [rd_ptr];
        rd_ptr <= rd_ptr + 1;
        
      end
      
    end
    
  end
  
  
endmodule
  
  
  

//tb

module tb_sync_fifo();

  parameter WIDTH = 16, DEPTH = 8;

  reg 					clk;
  reg 					rst_n;

  reg 					wr_en;
  reg [WIDTH-1 : 0] 	data_in;
  wire 					full;

  reg 					rd_en;
  wire				 	empty;
  wire [WIDTH-1 : 0] 	data_out;
  integer 				i;

  sync_fifo f0(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(wr_en),
    .data_in(data_in),
    .full(full),
    .rd_en(rd_en),
    .empty(empty),
    .data_out(data_out)
  );

  initial clk =0;
  always #2 clk = ~clk;

  initial begin

    wr_en = 0;
    rd_en = 0;
    rst_n = 0;

    #3 rst_n = 1;
    drive(20);
    drive(40);
    $finish;

  end

  task push(); // task to push data into fifo

    if(!full) begin

      wr_en = 1;
      data_in = $urandom;
      #1 $display("[%0t] wr_en = %0b rd_en = %0b data_in = %0h",$time,wr_en,rd_en,data_in);

    end

    else
        $display("Fifo full, cant push data_in = %0h",data_in);

  endtask

  task pop(); // task to remove data from fifo

    if(!empty) begin

      rd_en = 1;
      #1 $display("[%0t] wr_en = %0b rd_en = %0b data_out = %0h",$time,wr_en,rd_en,data_out);

    end

    else
      $display("Fifo empty!!");

  endtask

  task drive (int delay); // task to push and pop data at a delay

    wr_en = 0;
    rd_en = 0;

    fork
      begin

        repeat(10) begin	//pushing data 10 times
          
          @(posedge clk)
          push();
          
        end
        
        wr_en = 0;
        
      end

      begin

        #delay;
        repeat(10) begin		//poping data 10 times
          
          @(posedge clk)
          pop();
          
        end
        
        rd_en = 0;
        
      end

    join

  endtask


  initial begin

    $dumpfile("dump.vcd");
    $dumpvars;

  end

endmodule


  
  
