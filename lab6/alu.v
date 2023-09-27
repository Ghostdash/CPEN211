module ALU(Ain,Bin,ALUop,out,N,V,Z);
  input [15:0] Ain, Bin;
  input [1:0] ALUop;
  output [15:0] out;
  output N,V,Z;

  reg [15:0] out;
  reg N,V,Z;
  always @(*) begin
	{N,V,Z} = 3'b000;
     case(ALUop)
 	2'b00: out = Ain + Bin;
	2'b01: begin                                     //only update status if ALUop is 01 (doing cmp command)
		out = Ain - Bin;
		if (out=={16{1'b0}})                       //if 2 are equal
			Z = 1'b1;
		else
			Z = 1'b0;
     		if (out[15] == 1'b1)                       //if output is negative (B>A)
			N = 1'b1;
     		else
			N = 1'b0;
		if (Ain[15] == Bin[15])                   //if the inputs have the same sign
        		V = 1'b1;
     		else
			V = 1'b0;
		end
	2'b10: out = Ain & Bin;
	2'b11: out = ~Bin;
      default: out = {16{1'bx}};             //indicatator for bug
     endcase
  end
endmodule
