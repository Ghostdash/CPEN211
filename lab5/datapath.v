module datapath(clk,readnum,vsel,loada,loadb,shift,asel,bsel,ALUop,loadc,loads,writenum,write,datapath_in,Z_out,datapath_out);
  input clk,vsel,loada,loadb,asel,bsel,loadc,loads,write;
  input [2:0] readnum,writenum;
  input [1:0] ALUop,shift;
  input [15:0] datapath_in;
  output [15:0] datapath_out;
  output Z_out;

  wire Z;
  wire [15:0] stored_num;
  wire [15:0] A,B,B_shift;
  wire [15:0] data_in;
  wire [15:0] Ain,Bin,ALU_out;

  vDFFE #16 LoadA(clk,loada,stored_num,A);
  vDFFE #16 LoadB(clk,loadb,stored_num,B);
  vDFFE #16 LoadC(clk,loadc,ALU_out,datapath_out);
  vDFFE #1  LoadS(clk,loads,Z,Z_out);

  regfile REGFILE(data_in,writenum,write,readnum,clk,stored_num);
  ALU alu(Ain,Bin,ALUop,ALU_out,Z);
  shifter Shift(B,shift,B_shift);

  assign Ain = asel? {16{1'b0}} : A ;
  assign Bin = bsel? {11'b00000000000,datapath_in[4:0]} : B_shift ;
  assign data_in = vsel? datapath_in : datapath_out;
  
endmodule


module vDFFE(clk, en, in, out) ;
  parameter n = 1;  // width
  input clk, en ;
  input  [n-1:0] in ;
  output [n-1:0] out ;
  reg    [n-1:0] out ;
  wire   [n-1:0] next_out ;

  assign next_out = en ? in : out;

  always @(posedge clk)
    out = next_out;  
endmodule

  
  

  
