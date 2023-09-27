module cpu(clk,reset,load,in,mdata,out,N,V,Z,w,mem_addr,mem_cmd);
input clk, reset, load;
input [15:0] in,mdata;
output [15:0] out;
output N, V, Z, w;
output [8:0] mem_addr;         //memory address 
output [1:0] mem_cmd;

wire [15:0] instruction , sximm5, sximm8;
wire [2:0] opcode, readnum, writenum,status_out,nsel;
wire [1:0] op,shift,vsel,ALUop;
wire [14:0] control;

wire loada,loadb,loadc,loads,write,asel,bsel;
wire load_ir,load_pc,reset_pc,addr_sel,load_addr;

wire [8:0] next_pc,pc_in,PC;
wire [8:0] addr_in,addr_out;          //data address block

assign write = control[0];
assign loada = control[1];
assign loadb = control[2];
assign vsel = control[4:3];
assign asel = control[5];
assign bsel = control[6];
assign loadc = control[7];
assign loads = control[8];
assign load_ir = control[9];
assign load_pc = control[10];
assign reset_pc = control[11];
assign addr_sel = control[12];
assign mem_cmd = control[14:13];

assign N = status_out[2];
assign V = status_out[1];
assign Z = status_out[0];

assign pc_in = PC + 1'b1;                        //add 1 to PC
assign next_pc = reset_pc? 9'b0 : pc_in;              //reset logic for pc counter
assign mem_addr = addr_sel? PC : addr_out;             //mux for mem_adr

assign addr_in = out[8:0];

vDFFE #16 Instruction_Register (clk,load_ir,in,instruction);    //instruction loader
vDFFE #9 Program_Counter (clk,load_pc,next_pc,PC);            //pc loader
vDFFE #9 Data_address (clk,load_addr,addr_in,addr_out);    //data address

instruction_decode Decoder (instruction,nsel,ALUop,sximm5,sximm8,shift,readnum,writenum,opcode,op);
state_machine Moore(opcode,op,reset,clk,w,nsel,control,load_addr);
datapath DP(clk,readnum,vsel,loada,loadb,shift,asel,bsel,ALUop,loadc,loads,writenum,write,mdata,PC,sximm8,sximm5,status_out,out);

//note to self: control[0] is write,control[1] is loada,control[2] is loadb,
//control[4:3] is vsel, control[5] is asel , control[6] is bsel,control [7] is loadc,
//control[8] is loads (load status)

//control[9] is load_ir, control[10] is load_pc ,control[11] is reset_pc, control [12]
// is addr_sel ,control[14:13] is mem_cmd

endmodule


module state_machine (opcode,op,reset,clk,w,nsel,control,load_addr);
input [2:0] opcode;
input [1:0] op;
input reset,clk;

output reg w,load_addr;             //indicate wait state
output reg [2:0] nsel;              //which register (readnum and writenum)
output reg [14:0] control;       

`define Decode 4'b0000
`define LoadA 4'b0001
`define LoadB 4'b0010
`define LDR 4'b0100
`define Load_Rd 4'b0101

`define RST 4'b0110                  //updated for lab7
`define IF1 4'b0111
`define IF2 4'b1000
`define UpdatePC 4'b1001
`define WriteImm 4'b1010
`define Load_result 4'b1011
`define STR 4'b1100
`define Write_result 4'b1101
`define Store_mem 4'b1110
`define Wait_for_update 4'b1111

`define MNONE 2'b01
`define MREAD 2'b10
`define MWRITE 2'b11

wire [3:0] states;
reg [3:0] next_states;

vDFF_states #4 Moore (clk,reset,next_states,states);

always @(*)
case(states) 
    `RST : begin
	   control[12:10] = 3'b11;  //set reset_pc and load_pc to 1
	   control[9:0] = 10'b0;    //set everything else to 0
	   control[14:13] = 2'b00;
	   load_addr = 1'b0;
	   next_states = `IF1;
	   end

    `IF1 : begin
	   control[12] = 1'b1;        //addr_sel = 1, mem_cmd = `Mread
	   control[14:13] = `MREAD;
	   control[11:10] = 2'b0;
	   control[9] = 1'b1;
           load_addr = 1'b0;
	   next_states = `IF2;
	   end

    `IF2 : begin
	   control[12] = 1'b1;       //load_ir = 1;
	   control[14:13] = `MREAD;
	   control[12:10] = 3'b0;
	   control[9] = 1'b0;
	   control[8:0] = 9'b0;
	   load_addr = 1'b0;
	   next_states = `UpdatePC;
	   end

    `UpdatePC : begin
		control[14:11] = 4'b0;
		control[10] = 1'b1;    //load_pc set to 1
		control[9:0] = 10'b0; 
	        load_addr = 1'b0;
		next_states = `Decode;
	        end

    `WriteImm : begin
		nsel = 3'b100;
		control[0] = 1'b1;
		control[4:3] = 2'b01;
		control[2:1] = 2'b00;
		control[14:5] = 10'b0;
	        load_addr = 1'b0;
		next_states = `IF1;
		end

    `Decode : begin
	control = 9'b000000000;
	w = 1'b1;
	case (opcode)
	    3'b110: next_states = `WriteImm ;   //operation not involving ALU
	    3'b101: next_states = `LoadA;     //operation involving ALU (Registers have been loaded)
	    3'b011: next_states = `LoadA;
	    3'b100: next_states = `LoadA;
	    3'b111: next_states = `Decode;        //HALT state
	    default: next_states = `Decode;     //indicates bug or invalid input
	endcase
	end

    `LoadA : begin
	w = 1'b0;
	control = 9'b000000010;         //set loada to 1
	next_states = `LoadB;
	nsel = 3'b001;                 //read from Rn
	end

    `LoadB : begin
	w = 1'b0;
	if (opcode == 3'b011 || opcode == 3'b100) begin
	    control[6] = 1'b1;          //b takes the value of address
	    nsel = 3'bxxx;              //not used    
	end
	else begin
	    nsel = 3'b010;
	    control[6] = 1'b0;
	end
	control[2] = 1'b1;         //set loadb to 1
	control[1:0] = 2'b0;
	control[5:3] = 3'b0;
	control[14:8] = 7'b0;
	control[7] = 1'b1;
	if (opcode == 3'b100)
	    next_states = `STR;
	else
	    next_states = `LDR;
	end

    `LDR: begin
	w = 1'b0;
	control[14:13] = `MREAD;       //read from memory
	control[12:10] = 3'b0;  
	control[9] = 1'b1;              //load_ir set to 1
	control[7] = 1'b1;         //set loadc and loads to 1
	control[8] = 1'b1;
	control[6:1] = 7'b0000000;
	control[0] = 1'b1;
	load_addr = 1'b1;              //instruct it to load address
	next_states = `Load_result;
	end
	
    `STR: begin
	w = 1'b0;
	control[14:10] = 5'b0;        //addr_sel set to 0
	control[7] = 1'b1;            //loadc to 1
	control[6] = 1'b1;            //loadb to 1
	control[5:0] = 7'b0;          //everything else to 0
	load_addr = 1'b1;
	next_states = `Load_Rd;
	end

    `Load_Rd: begin
	w = 1'b0;
	nsel = 3'b100;
	control[5] = 1'b1;        //set asel to 1 (A is set to 0
	control[2] = 1'b1;        //set loadb to 1  
	control[7] = 1'b1;
	control[6] = 1'b0;     
	control[12:8] = 5'b0;
	control[14:13] = `MWRITE;
	control[1:0] = 2'b00;
	load_addr = 1'b0;          //stop updating address
	next_states = `Store_mem;
	end
	
    
    `Load_result: begin
	w = 1'b0;
	next_states = `Write_result; 
 	control[8:1] = 8'b0;            //vsel is mdata
	control[0] = 1'b1;
	nsel = 3'b100;                     //nsel set to Rd
	end

     `Write_result: begin
	w = 1'b0;
	control[14:10] = 5'b0;
	control[9] = 1'b1;
	control[8:1] = 8'b0;
	control[0] = 1'b1;
	next_states = `IF1;
	end

      `Store_mem: begin
	 control[7] = 1'b1;    //only update loadc
	 control[14:13] = `MWRITE;
	 next_states = `Wait_for_update;
	end 
      
      `Wait_for_update: next_states = `IF1;

    default: {next_states,control}= {`IF1, 15'b0};       //set everything to 0 and next_state to RST
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
     opcode = instruction [15:13];
     case(instruction[15:13])                                    
	3'b110: begin
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
        3'b011: begin
		ALUop = 2'b00;                       //perform addition
		Rn = instruction [10:8];
		Rd = instruction [7:5];
		readnum = Rn;
		writenum = Rd;
		end
	3'b100: begin
		ALUop = 2'b00;
		shift = 2'b00;
		Rn = instruction [10:8];
		Rd = instruction [7:5];
		case(nsel) 
			3'b001: {readnum,writenum} = {Rn,Rn};
			3'b100: {readnum,writenum} = {Rd,Rd};
		default:{readnum,writenum} = 6'bxxxxxx;   //not used
		endcase
		end
	
     default: opcode = 3'bxxx;
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
		out = `RST;
	else
		out = in;
endmodule 

