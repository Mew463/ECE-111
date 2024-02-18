`timescale 1ns/1ns
//Carry Lookahead Adder Testbench Code
module carry_lookahead_adder_testbench;
 parameter N = 4;
 logic[N-1:0] in0, in1;
 logic carryin;
 logic[N:0] sum;

// Instantiate design under test
carry_lookahead_adder #(.N(N)) design_instance(
.A(in0),
.B(in1),
.CIN(carryin),
.result(sum)
);

initial begin
// Initialize Inputs
in0=0;
in1=0;
carryin=0;
// Wait 100 ns 
#100;
in0=2;
in1=1;
carryin=1;
#50 
in0=1;
in1=1;
carryin=0;
#50
in0=2;
in1=2;
carryin=0;
#50
in0=3;
in1=1;
carryin=0;
#50; 
in0=4;
in1=7;
carryin=1;
#50; 
in0=15;
in1=2;
carryin=0;
#50;
in0=10;
in1=5;
carryin=0;
#50;
end


// always@(in0) begin
//     #1;
//     $display(" time=%0t   A=%b   B=%b   CIN=%b   result=%b\n", $time, in0, in1, carryin, sum);
// end
initial begin
 $monitor(" time=%0t   A=%b   B=%b   CIN=%b   result=%b\n", $time, in0, in1, carryin, sum);
end

initial begin
	$dumpfile("dump.vcd.tmp");
	$dumpvars;
end
endmodule