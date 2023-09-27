module datapath_tb();
  reg clk,vsel,loada,loadb,asel,bsel,loadc,loads,write;
  reg [2:0] readnum,writenum;
  reg [1:0] ALUop,shift;
  reg [15:0]datapath_in;

  wire [15:0] datapath_out;
  wire Z_out;

  reg err;

datapath DUT (clk,readnum,vsel,loada,loadb,shift,asel,bsel,ALUop,loadc,loads,writenum,write,datapath_in,Z_out,datapath_out);

initial begin                  //test1
  vsel = 1'b1;
  {loada,loadb,loadc } = 3'b000;
  {asel,bsel} = 2'b11;
  clk = 1'b0;
  datapath_in = 16'b0000000000001111;
  write= 1'b1;
  writenum = 3'b001;
  shift = 2'b00;
  ALUop = 2'b00;

  err = 1'b0;

 #5;
  clk = 1'b1;
  asel = 1'b0;

 #5;
  clk = 1'b0;
  readnum = 3'b001;
  loada = 1'b1;
  write = 1'b0;
 #5;
  clk = 1'b1;

 #5;
  loada = 1'b0;
  clk = 1'b0;
  datapath_in = 16'b0000000000010000;
  write = 1'b1;
  writenum = 3'b010;
 #5;
  clk = 1'b1;
  bsel = 1'b0;

 #5;
  clk = 1'b0;
  readnum = 3'b010;
  loadb = 1'b1;

 #5;
  clk = 1'b1;
 #5;
  loadb = 1'b0;
  clk = 1'b0;
  loadc = 1'b1;
 #5;
  clk = 1'b1;
 #5;
  loadc = 1'b0;
if (datapath_out!=31)
	err = 1'b1;
$display("Output is %d, expecting %d",datapath_out,31);


 #5;                                //test2
  readnum = 3'bxxx;
  vsel = 1'b1;
  {loada,loadb,loadc } = 3'b000;
  {asel,bsel} = 2'b11;
  clk = 1'b0;
  datapath_in = 16'b0000000000111000; //56
  write= 1'b1;
  writenum = 3'b011;
  shift = 2'b01;
  ALUop = 2'b01;

 #5;
  clk = 1'b1;
  {asel,bsel} = 1'b0;

 #5;
  clk = 1'b0;
  readnum = 3'b011;
  loada = 1'b1;
  write = 1'b0;
 #5;
  clk = 1'b1;

 #5;
  loada = 1'b0;
  clk = 1'b0;
  datapath_in = 16'b0000000000010100;    //20
  write = 1'b1;
  writenum = 3'b100;
 #5;
  clk = 1'b1;
  bsel = 1'b0;

 #5;
  clk = 1'b0;
  readnum = 3'b100;
  loadb = 1'b1;

 #5;
  clk = 1'b1;
 #5;
  loadb = 1'b0;
  clk = 1'b0;
  loadc = 1'b1;
 #5;
  clk = 1'b1;
 #5;
  loadc = 1'b0;
if (datapath_out!=16)
	err = 1'b1;
$display("Output is %d, expecting %d",datapath_out,16);


 #5;                             //test 3
  readnum = 3'bxxx;
  vsel = 1'b1;
  {loada,loadb,loadc } = 3'b000;
  {asel,bsel} = 2'b11;
  clk = 1'b0;
  datapath_in = 16'b0000000000111000; //56
  write= 1'b1;
  writenum = 3'b101;
  shift = 2'b10;
  ALUop = 2'b01;

 #5;
  clk = 1'b1;
  {asel,bsel} = 1'b0;

 #5;
  clk = 1'b0;
  readnum = 3'b101;
  loada = 1'b1;
  write = 1'b0;
 #5;
  clk = 1'b1;

 #5;
  loada = 1'b0;
  clk = 1'b0;
  datapath_in = 16'b0000000000010100;    //20
  write = 1'b1;
  writenum = 3'b110;
 #5;
  clk = 1'b1;
  bsel = 1'b0;

 #5;
  clk = 1'b0;
  readnum = 3'b110;
  loadb = 1'b1;

 #5;
  clk = 1'b1;
 #5;
  loadb = 1'b0;
  clk = 1'b0;
  loadc = 1'b1;
 #5;
  clk = 1'b1;
 #5;
  loadc = 1'b0;
if (datapath_out!=46)
	err = 1'b1;
$display("Output is %d, expecting %d",datapath_out,46);

 #5;                             //test 4
  readnum = 3'bxxx;
  vsel = 1'b1;
  {loada,loadb,loadc } = 3'b000;
  {asel,bsel} = 2'b11;
  clk = 1'b0;
  datapath_in = 16'b0000000000111000; //56
  write= 1'b1;
  writenum = 3'b101;
  shift = 2'b10;
  ALUop = 2'b10;

 #5;
  clk = 1'b1;
  {asel,bsel} = 1'b0;

 #5;
  clk = 1'b0;
  readnum = 3'b101;
  loada = 1'b1;
  write = 1'b0;
 #5;
  clk = 1'b1;

 #5;
  loada = 1'b0;
  clk = 1'b0;
  datapath_in = 16'b0000000000010100;    //20
  write = 1'b1;
  writenum = 3'b110;
 #5;
  clk = 1'b1;
  bsel = 1'b0;

 #5;
  clk = 1'b0;
  readnum = 3'b110;
  loadb = 1'b1;

 #5;
  clk = 1'b1;
 #5;
  loadb = 1'b0;
  clk = 1'b0;
  loadc = 1'b1;
 #5;
  clk = 1'b1;
 #5;
  loadc = 1'b0;
if (datapath_out!=(16'b0000000000001010&16'b0000000000111000))
	err = 1'b1;
$display("Output is %d, expecting %d",datapath_out,16'b0000000000001010&16'b0000000000111000);

 #5;                             //test 5
  readnum = 3'bxxx;
  vsel = 1'b1;
  {loada,loadb,loadc } = 3'b000;
  {asel,bsel} = 2'b11;
  clk = 1'b0;
  datapath_in = 16'b0000000000000111; //7
  write= 1'b1;
  writenum = 3'b000;
  shift = 2'b01;
  ALUop = 2'b00;

 #5;
  clk = 1'b1;
  {asel,bsel} = 2'b00;

 #5;
  clk = 1'b0;
  readnum = 3'b000;
  loadb = 1'b1;          //load in b
  write = 1'b0;
 #5;
  clk = 1'b1;

 #5;
  loadb = 1'b0;         
  clk = 1'b0;
  datapath_in = 16'b0000000000000010;    //2
  write = 1'b1;
  writenum = 3'b001;
 #5;
  clk = 1'b1;
  bsel = 1'b0;

 #5;
  clk = 1'b0;
  readnum = 3'b001;
  loada = 1'b1;
  write = 1'b0;

 #5;
  clk = 1'b1;
 #5;
  loadb = 1'b0;
  clk = 1'b0;
  loadc = 1'b1;
 #5;
  clk = 1'b1;
 #5;
  loadc = 1'b0;
if (datapath_out!=16)
	err = 1'b1;
$display("Output is %d, expecting %d",datapath_out,16);
 #500;

$stop;
end
endmodule
