module lab3_top(SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
input [9:0] SW;
input [3:0] KEY;
output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
output [9:0] LEDR; // optional: use these outputs for debugging on your DE1-SoC

wire [3:0] counter;
reg [6:0] temp;
reg [3:0] temp_c;
reg [3:0] next_states;
wire [3:0] states;

`define CLOSED {7'b1001110,7'b0001110,7'b1111110,7'b1011011,7'b1001111,7'b0111101}
`define OPEN {7'b0000000,7'b0000000,7'b1111110,7'b1000111,7'b1001111,7'b0011101}
`define ERROR {7'b0000000,7'b1001111,7'b0000101,7'b0000101,7'b1111110,7'b0000101}
`define START {6{7'b0000000}}

`define eight 4'b1000
`define three 4'b0011
`define four 4'b0100
`define seven 4'b0111

`define start 4'b0000
`define num1_t 4'b0001
`define num2_t 4'b0010
`define num3_t 4'b0011
`define num4_t 4'b0100
`define num5_t 4'b0101
`define correct 4'b0110
`define wrong 4'b1000
`define closed 4'b1101
`define error 4'b1110

vDFFcounter #(4) STATE(~KEY[3],next_states,states,temp_c,counter);  //instantiate DFF with counter

always @(*)  begin
  temp_c = counter;
  if (KEY[0] == 1'b0) begin
      next_states = `start;                          
	   temp_c = 4'b0000; 			//reset the counter
	end
  else begin
	case(SW[3:0])
	`eight: begin                 //when 8 is entered
	   case(states)
		 `start: next_states = `num1_t;
		 `num1_t:next_states = `num2_t;

		 `error: next_states = `error;    //while in error, ignore any inputs
		default: next_states = `wrong;
            endcase
	    temp = 7'b1111111;
	end

	`three: begin                 //when 3 is entered
	    case(states)
		 `num2_t: next_states = `num3_t;
		 `num3_t: next_states = `num4_t;
		 `error:  next_states = `error; 
		 default: next_states = `wrong;
	    endcase
	    temp = 7'b1111001;
	end

	`four: begin
	    case(states)
		 `num4_t: next_states = `num5_t;
		 `error:  next_states = `error;
		 default: next_states = `wrong;
	    endcase
	    temp = 7'b0110011;
	end

	`seven: begin
	    case(states)
		 `num5_t: next_states = `correct;
		 `error:  next_states = `error;
		 default: next_states = `wrong;
	    endcase
	    temp = 7'b1110000;
	end

	4'b0000: {next_states,temp} = {`wrong,7'b1111110};    //other numbers
	4'b0001: {next_states,temp} = {`wrong,7'b0110000};
	4'b0010: {next_states,temp} = {`wrong,7'b1101101};
	4'b0101: {next_states,temp}= {`wrong,7'b1011011};
	4'b0110: {next_states,temp}= {`wrong,7'b1011111};
	4'b1001: {next_states,temp} = {`wrong,7'b1111011};

  	default: next_states = `error;                       //if no number between 0-9, set next state to be error
  	endcase

	if (next_states == `wrong && counter == 4'b0110)
	  next_states = `closed;
  end
  if (states == `correct)                                //outputs
   {HEX5,HEX4,HEX3,HEX2,HEX1,HEX0} = `OPEN;
  else if(states == `closed)
  {HEX5,HEX4,HEX3,HEX2,HEX1,HEX0} = `CLOSED;
  else if(states == `error)
  {HEX5,HEX4,HEX3,HEX2,HEX1,HEX0} = `ERROR;
  else if(states == `start)
  {HEX5,HEX4,HEX3,HEX2,HEX1,HEX0} = `START;
  else
	HEX0 = temp;                                  //show the number being entered
end
endmodule


module vDFFcounter(clk,in,out,temp_c,counter);
  parameter n = 1;
  input clk;
  input [n-1:0]in;
  output [n-1:0] out ;
  reg [n-1:0] out ;
  
  input [3:0] temp_c;
  output [3:0] counter;
  reg [3:0]counter;
  always@(posedge clk) begin
    out = in;
    counter = temp_c+1'b1;

  end
endmodule 


