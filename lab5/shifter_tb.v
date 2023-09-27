module shifter_tb();
reg [15:0] in;
reg [1:0]shift;
wire [15:0] sout;

reg err;
shifter DUT (in,shift,sout);

initial begin
  in = 16'b0000000000010100;  //20
  shift = 2'b00;
  err = 1'b0;
 #5;
  if (sout!=16'b0000000000010100)
	err = 1'b1;
  $display("Output is %b, expecting %16b",sout,20);
  shift = 2'b01;
 #5;
  if (sout!=16'b0000000000101000)
	err = 1'b1;
  $display("Output is %b, expecting %16b",sout,40);
  shift = 2'b10;
 #5;
  if (sout!=16'b0000000000001010)
	err = 1'b1;
  $display("Output is %b, expecting %16b",sout,10);
  shift = 2'b11;
 #5;
  if (sout!=16'b0000000000001010)
	err = 1'b1;
  $display("Output is %b, expecting %16b",sout,10);
  #500;
  $stop;
end
endmodule