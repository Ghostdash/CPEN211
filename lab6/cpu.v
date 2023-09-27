module cpu(clk,reset,s,load,in,out,N,V,Z,w);
input clk, reset, s, load;
input [15:0] in;
output [15:0] out;
output N, V, Z, w;

wire [15:0] instruction , sximm5, sximm8;
wire [2:0] opcode, readnum, writenum,status_out,nsel;
wire [1:0] op,shift,vsel,ALUop;
wire [8:0] control;

wire loada,loadb,loadc,loads,write,asel,bsel;

assign write = control[0];
assign loada = control[1];
assign loadb = control[2];
assign vsel = control[4:3];
assign asel = control[5];
assign bsel = control[6];
assign loadc = control[7];
assign loads = control[8];

assign N = status_out[2];
assign V = status_out[1];
assign Z = status_out[0];

vDFF #16 Instruction_Register (load,in,instruction);
instruction_decode Decoder (instruction,nsel,ALUop,sximm5,sximm8,shift,readnum,writenum,opcode,op);
state_machine Moore(opcode,op,s,reset,clk,w,nsel,control);
datapath DP(clk,readnum,vsel,loada,loadb,shift,asel,bsel,ALUop,loadc,loads,writenum,write,sximm8,sximm5,status_out,out);

//note to self: control[0] is write,control[1] is loada,control[2] is loadb,
//control[4:3] is vsel, control[5] is asel , control[6] is bsel,control [7] is loadc,
//control[8] is loads (load status)

endmodule


module state_machine (opcode,op,s,reset,clk,w,nsel,control);
input [2:0] opcode;
input [1:0] op;
input s,reset,clk;

output reg w;                        //indicate wait state
output reg [2:0] nsel;              //which register (readnum and writenum)
output reg [8:0] control;           //?	

`define Wait 3'b000
`define LoadA 3'b001
`define LoadB 3'b010
`define MOV 3'b011
`define Compute 3'b100
`define Store_result 3'b101


wire [2:0] states;
reg [2:0] next_states;

vDFF_states #3 Moore (clk,reset,next_states,states);

always @(*)
case(states)
    `Wait : begin
	control = 9'b000000000;
	w = 1'b1;
	if(s == 1'b0)
	    next_states = `Wait;
	else 
	    case (opcode)
		3'b110: next_states = `MOV ;	  //operation not involving ALU
		3'b101: next_states = `LoadA;     //operation involving ALU (Registers have been loaded)
		default: next_states = `Wait;     //indicates bug or invalid input
	    endcase
	end
    `MOV : begin
	w = 1'b0;
	control[4:3] = 2'b01;
	control[2:0] = 3'b001;
	control[8:5] = 4'b0000;
	if (op == 2'b10)
	    {next_states,nsel} = {`Wait,3'b001};  //do operation on Rn
	else if (op == 2'b00)
	    {next_states,nsel} = {`Compute,3'b010};  //do operation on Rm            
	end
    `LoadA : begin
	w = 1'b0;
	control = 9'b000000010;         //set loada to 1
	next_states = `LoadB;
	nsel = 3'b001;                 //read from Rm
	end

    `LoadB : begin
	w = 1'b0;
	control = 9'b000000100;         //set loadb to 1
	next_states = `Compute;
	nsel = 3'b010;             //read from Rm
	end
    `Compute: begin
	w = 1'b0;
	control[7] = 1'b1;         //set loadc and loads to 1
	control[8] = 1'b1;
	control[6:0] = 7'b0000000;
	if (op == 2'b00)
		control[5] = 1'b0;      //set asel to 0
	next_states = `Store_result;
	end
    `Store_result: begin
	w = 1'b0;
	control[0] = 1'b1;             //set write to 1
	control[4:3] = 2'b11;           //set vsel to 11 (store result)
	control[2:1] = 2'b00;
	control[8:5] = 4'b0000;
	next_states = `Wait;
	nsel = 3'b100;                    //load result and stored it into Rd
	end
    default: {next_states,control }= {`Wait, 9'b0};       //set everything to 0 and next_state to wait
endcase
endmodule



module instruction_decode (instruction,nsel,ALUop,sximm5,sximm8,shift,readnum,writenum,opcode,op);
input [15:0] instruction;
input [2:0] nsel;
output reg [1:0] ALUop,shift,op;
output reg [2:0] opcode,readnum,writenum;
output reg [15:0] sximm5,sximm8;

reg [2:0] Rn,Rd,Rm;

reg[4:0] im5;
reg[7:0] im8;

always @(*) begin
     case(instruction[15:13])                                    
	3'b110: begin
		opcode = instruction [15:13];
		op = instruction[12:11];
		ALUop = 2'bxx;                             //not executing ALU operation
		case(instruction[12:11]) 
			2'b10: begin
				Rn = instruction[10:8];
				im8 = instruction[7:0]; end
			2'b00: begin
				ALUop = 2'b00;              //adding B to A(zeroed) and stored it in Rd
				Rd = instruction[7:5];
				shift = instruction[4:3];
				Rm = instruction[2:0]; end
			default:Rn = 3'bxxx;        //indicates error
		endcase
		readnum = 3'bxxx;             //not reading anything for this stage
		writenum = Rn;
		end
	3'b101: begin
		opcode = instruction [15:13];
		ALUop = instruction[12:11];
		shift = instruction[4:3]; 
		Rm = instruction[2:0];

		if (ALUop == 2'b11) begin
			Rn = 3'b000;
			Rd = instruction[7:5];
		end
		else begin
		        Rn = instruction[10:8];
			if (ALUop == 2'b01)
				Rd = 3'b000;
			else
				Rd = instruction[7:5];
		end	
		case(nsel)
			3'b001: {readnum,writenum} = {Rn,Rn};
			3'b010: {readnum,writenum} = {Rm,Rm};
			3'b100: {readnum,writenum} = {Rd,Rd};
		default:{readnum,writenum} = 6'bxxxxxx;   //not used
		endcase
	end
     default: opcode = 3'b000;
     endcase
	im5 = instruction[4:0];
	sximm8 = {{8{im8[7]}},im8};
	sximm5 = {{11{im5[4]}},im5};
end
endmodule

module vDFF_states (clk, reset, in, out) ;
  parameter n = 1;  // width
  input clk,reset ;
  input [n-1:0] in ;
  output [n-1:0] out ;
  reg [n-1:0] out ;

  always @(posedge clk)
	if (reset==1'b1)
		out = `Wait;
	else
		out = in;
endmodule 

