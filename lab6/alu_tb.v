module ALU_tb();
reg [15:0]Ain, Bin;
reg [1:0] ALUop;

wire [15:0] out;
wire N,V,Z;

reg err;

ALU DUT(Ain,Bin,ALUop,out,N,V,Z);

initial begin
  Ain = 13;  //16'b0000000000001101
  Bin = 10;  //16'b0000000000001010
  ALUop = 2'b00;
  err = 1'b0;
  
  $display("A is %b",Ain);
  $display("B is %b",Bin);
 #5;
  if (out!=Ain+Bin)
	err = 1'b1;
  $display("The output is %b, expecting %16b",out,Ain+Bin);
  ALUop = 2'b01;
 #5;
  if (out!=Ain-Bin)
	err = 1'b1;
  $display("The output is %b, expecting %16b",out,Ain-Bin);
  ALUop = 2'b10;
 #5;
  if (out!=Ain&Bin)
	err = 1'b1;
  $display("The output is %b, expecting %16b",out,Ain&Bin);  
  ALUop = 2'b11;
 #5;
  if (out!=~Bin)
	err = 1'b1;
  $display("The output is %b, expecting %16b",out,~Bin); 
 #5;
  Ain = -3;  
  Bin = 10;  
  ALUop = 2'b00;
  err = 1'b0;
  
  $display("A is %b",Ain);
  $display("B is %b",Bin);
 #5;
  if (out!=Ain+Bin)
	err = 1'b1;
  $display("The output is %b, expecting %16b",out,Ain+Bin);
  ALUop = 2'b01;
 #5;
  if (out!=Ain-Bin)
	err = 1'b1;
  $display("The output is %b, expecting %16b",out,Ain-Bin);
  ALUop = 2'b10;
 #5;
  if (out!=Ain&Bin)
	err = 1'b1;
  $display("The output is %b, expecting %16b",out,Ain&Bin);  
  ALUop = 2'b11;
 #5;
  if (out!=~Bin)
	err = 1'b1;
  $display("The output is %b, expecting %16b",out,~Bin); 
  #500;
  $stop;
end
endmodule
