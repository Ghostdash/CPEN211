module cpu_tb();

reg clk,reset,s,load;
reg [15:0] in;

wire [15:0] out;
wire N,V,Z,w;

reg err;

cpu DUT(clk,reset,s,load,in,out,N,V,Z,w);

initial begin
    clk = 0; #5;
    forever begin
      clk = 1; #5;
      clk = 0; #5;
    end
end

initial begin
    err = 0;
    reset = 1; s = 0; load = 0; in = 16'b0;
    #10;
    reset = 0; 
    #10;

    in = 16'b1101000000000111;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1;
      $display("FAILED: MOV R0, #7");
      $stop;
    end

    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1101000100000010;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R1 !== 16'h2) begin
      err = 1;
      $display("FAILED: MOV R1, #2");
      $stop;
    end

    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1010000101001000;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'h10) begin
      err = 1;
      $display("FAILED: ADD R2, R1, R0, LSL#1");
      $stop;
    end

    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1011000101000000;        //AND 7,2 , no shift (AND Rd, Rn,Rm)
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'h2) begin
      err = 1;
      $display("FAILED: AND R2, R1, R0");
      $stop;
    end


    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1010100100000010;             //CMP R2,R1
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (Z !== 1'b1) begin
      err = 1;
      $display("FAILED: CMP R2,R1");
      $stop;
    end


    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1011100101000001;        //~R1 , no shift (AND Rd, Rn,Rm)
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== ~(16'b0000000000000010)) begin
      err = 1;
      $display("FAILED: ~R1");
      $stop;
    end
 
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1101000000000010;   //2 in R0
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h2) begin
      err = 1;
      $display("FAILED: MOV R0, #2");
      $stop;
    end

    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1101000111111010;   //-6 in R0
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R1 !== 16'b1111111111111010) begin
      err = 1;
      $display("FAILED: MOV R1, #-6");
      $stop;
    end

    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1010000101000000;    //ADD R2, R1,R0 (no shift)
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'b1111111111111100) begin      //-4
      err = 1;
      $display("FAILED: ADD R2, R1, R0 (no shift)");
      $stop;
    end
     
      $display("No mistakes found.");
$stop;
end
endmodule
