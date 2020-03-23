`timescale 1ns / 1ps
module booth_wallance_multipier_tb();

reg clk;
reg [15:0] a_in,b_in;
wire [30:0] result;

initial clk = 1'b1;
always  #10 clk = ~clk;

booth_wallance_multipier test (a_in,b_in,result);

initial begin
        #50;
        a_in = 16'h0001;
  		b_in = 16'hFFFF;
  		#50;
        a_in = 16'h0001;
  		b_in = 16'h0001;
        #50;
        a_in = 16'h8005;
  		b_in = 16'h8003;
  		#50;
  		a_in = 16'h8005;
        b_in = 16'h0003;
        #50;
        a_in = 16'h0005;
        b_in = 16'h8003;
        #50;
        a_in = 16'h0005;
        b_in = 16'h0003;
        #50;
        $finish;
end 
endmodule
