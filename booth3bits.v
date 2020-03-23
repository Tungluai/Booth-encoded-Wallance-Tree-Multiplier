module booth3bits(a,b,rout);
input [15:0] a;
input [2:0] b;
output reg [16:0] rout;
wire [15:0] atmp;
/*
Assuming that x[n-1:0] * y[n-1:0] 
b = y补 = - y[n-1]2^(n-1) + y[n-2]2^(n-2) + y[n-3]2^(n-3) + …… + y[2]2^2 + y[1]2^1 + y[0]2^0
equal to：
b = y补 = （- y[n-1]+y[n-2]）2^(n-1) + （-y[n-2]+y[n-3]）2^(n-2) + …… + （-y[1]+ y[0]）2^2 + （-y[0]+1'0) 2^1
2bits booth算法(补码运算)：      y[n]  y[n-1]   operations
                                  0      0          +0，部分和右移一位，n++
                                  0      1         + x补，部分和右移一位，n++
                                  1      0         +(-x)补，部分和右移一位，n++ 
                                  1      1          +0，部分和右移一位，n++
equal to： 
b = y补 = （- 2y[n-1] + y[n-2] + y[n-3]）2^(n-2) + （- 2y[n-3] + y[n-4] + y[n-5]）2^(n-4)  + …… + （-2y[1] + y[0]+ 1'b0) 2^0 
3bits booth算法(补码运算)：      y[n+1]   y[n]  y[n-1]     operations
                                  0       0       0    +0，部分和右移2位，n+=2
                                  0       0       1    + x补，部分和右移2位，n+=2
                                  0       1       0    + x补，部分和右移2位，n+=2 
                                  0       1       1    +（2x）补，部分和右移2位，n+=2    
                                  1       0       0    +(-2x)补，部分和右移2位，n+=2
                                  1       0       1    +(-x)补，部分和右移2位，n+=2
                                  1       1       0    +(-x)补，部分和右移2位，n+=2
                                  1       1       1    +0，部分和右移2位，n+=2                                    
///////////////////
Some factors about this module:
a = x补  
b = y补  
(-x)补 + x补 = （x - x）补 = (n-1)'b0 ----->> (-x)补 = (n-1)'b0 - x补 = (n-1)'b0 - a
(2x)补 = (x + x)补 = 2*x补 = a<<<1
(-2x)补 = （（-x）+ （-x））补 = 2*（-x）补 = （-x）补 <<< 1 = ((n-1)'b0 - a)<<<1
*/
assign atmp = ~a;
always@(a or b) begin
       case(b) 
           3'b000: rout = 17'h0;//0
           3'b001: rout = {a[15],a};//1
           3'b010: rout = {a[15],a};//1
           3'b011: rout = {a, 1'b0};//2
           3'b100: rout = {atmp, 1'b0} + 2'b10;//-2
           3'b101: rout = {atmp[15], atmp}+1'b1;//-1 
           3'b110: rout = {atmp[15], atmp}+1'b1;//-1
           3'b111: rout =  17'h0;//0
       endcase
    end
endmodule
