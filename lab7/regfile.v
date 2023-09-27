module regfile(data_in,writenum,write,readnum,clk,data_out);
  input [15:0] data_in;
  input [2:0] writenum, readnum;
  input write, clk;
  output[15:0] data_out;

  wire [7:0] register_w,register_r; 
  wire [15:0] R0,R1,R2,R3,R4,R5,R6,R7;
  reg ld0,ld1,ld2,ld3,ld4,ld5,ld6,ld7;
  reg[15:0] data_out;

  flip #16 r0(clk,ld0,data_in,R0);
  flip #16 r1(clk,ld1,data_in,R1); 
  flip #16 r2(clk,ld2,data_in,R2);
  flip #16 r3(clk,ld3,data_in,R3);
  flip #16 r4(clk,ld4,data_in,R4);
  flip #16 r5(clk,ld5,data_in,R5);
  flip #16 r6(clk,ld6,data_in,R6);
  flip #16 r7(clk,ld7,data_in,R7);

  Dec #(3,8) Write(writenum,register_w);
  Dec #(3,8) Read(readnum,register_r);
  
  always @(*) begin
    case(register_r)
	8'b00000001:data_out = R0;
	8'b00000010:data_out = R1;
	8'b00000100:data_out = R2;
	8'b00001000:data_out = R3;
	8'b00010000:data_out = R4;
	8'b00100000:data_out = R5;
	8'b01000000:data_out = R6;
	8'b10000000:data_out = R7;
    default:data_out = {16{1'b0}};
    endcase
    case({register_w,write})
	{8'b00000001,1'b1}:{ld0,ld1,ld2,ld3,ld4,ld5,ld6,ld7}=8'b10000000;
	{8'b00000010,1'b1}:{ld0,ld1,ld2,ld3,ld4,ld5,ld6,ld7}=8'b01000000;
	{8'b00000100,1'b1}:{ld0,ld1,ld2,ld3,ld4,ld5,ld6,ld7}=8'b00100000;
	{8'b00001000,1'b1}:{ld0,ld1,ld2,ld3,ld4,ld5,ld6,ld7}=8'b00010000;
	{8'b00010000,1'b1}:{ld0,ld1,ld2,ld3,ld4,ld5,ld6,ld7}=8'b00001000;
	{8'b00100000,1'b1}:{ld0,ld1,ld2,ld3,ld4,ld5,ld6,ld7}=8'b00000100;
	{8'b01000000,1'b1}:{ld0,ld1,ld2,ld3,ld4,ld5,ld6,ld7}=8'b00000010;
	{8'b10000000,1'b1}:{ld0,ld1,ld2,ld3,ld4,ld5,ld6,ld7}=8'b00000001;
	default:{ld0,ld1,ld2,ld3,ld4,ld5,ld6,ld7}=8'b00000000;
	endcase  
   end
endmodule


module Dec(a, b) ;
  parameter n=2 ;
  parameter m=4 ;

  input  [n-1:0] a ;
  output [m-1:0] b ;

  wire [m-1:0] b = 1 << a ;
endmodule


module flip(clk, load, in, out) ;
  parameter n = 1;  // width
  input clk,load;
  input [n-1:0] in ;
  output [n-1:0] out ;
  reg [n-1:0] out ;

  always @(posedge clk)
    if (load==1'b1)
      out = in;
    else
      out = out;
endmodule 

