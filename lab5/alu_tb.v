module ALU_tb();
reg [15:0]Ain, Bin;
reg [1:0] ALUop;

wire [15:0] out;
wire Z;

reg err;

ALU DUT(Ain,Bin,ALUop,out,Z);

initial begin
  Ain = 13;  //16'b0000000000001101
  Bin = 10;  //16'b0000000000001010
  ALUop = 2'b00;
  err = 1'b0;
 #5;
  if (out!=23)
	err = 1'b1;
  $display("The output is %b, expecting %16b",out,23);
  ALUop = 2'b01;
 #5;
  if (out!=(13-10))
	err = 1'b1;
  $display("The output is %b, expecting %16b",out,3);
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
