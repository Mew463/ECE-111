//Linear Feedback Shift Register
module lfsr
#(parameter N = 4) // Number of bits for LFSR should support N = 2...8
(
  input logic clk, reset_n, load_seed,
  input logic[N-1:0] seed_data,
  output logic lfsr_done,
  output logic[N-1:0] lfsr_data
);

logic[N-1:0] my_lfsr_data;
logic[N-1:0] next_lfsr_data;

always @(negedge reset_n) 
begin
  my_lfsr_data = {N{1'b1}};
end

always @(posedge clk)
begin
  if (load_seed)
    my_lfsr_data = seed_data;
  else begin
    case (N)
      2: my_lfsr_data = {my_lfsr_data[N-1:0], my_lfsr_data[N-1] ^ my_lfsr_data[0]};
      3: my_lfsr_data = {my_lfsr_data[N-1:0], my_lfsr_data[N-1] ^ my_lfsr_data[1]};
      4: my_lfsr_data = {my_lfsr_data[N-1:0], my_lfsr_data[N-1] ^ my_lfsr_data[2]};
      5: my_lfsr_data = {my_lfsr_data[N-1:0], my_lfsr_data[N-1] ^ my_lfsr_data[2]};
      6: my_lfsr_data = {my_lfsr_data[N-1:0], my_lfsr_data[N-1] ^ my_lfsr_data[4]};
      7: my_lfsr_data = {my_lfsr_data[N-1:0], my_lfsr_data[N-1] ^ my_lfsr_data[5]};
      8: my_lfsr_data = {my_lfsr_data[N-1:0], my_lfsr_data[N-1] ^ my_lfsr_data[5] ^  my_lfsr_data[4] ^  my_lfsr_data[3]};
    endcase

    case (N)
      2: next_lfsr_data = {my_lfsr_data[N-1:0], my_lfsr_data[N-1] ^ my_lfsr_data[0]};
      3: next_lfsr_data = {my_lfsr_data[N-1:0], my_lfsr_data[N-1] ^ my_lfsr_data[1]};
      4: next_lfsr_data = {my_lfsr_data[N-1:0], my_lfsr_data[N-1] ^ my_lfsr_data[2]};
      5: next_lfsr_data = {my_lfsr_data[N-1:0], my_lfsr_data[N-1] ^ my_lfsr_data[2]};
      6: next_lfsr_data = {my_lfsr_data[N-1:0], my_lfsr_data[N-1] ^ my_lfsr_data[4]};
      7: next_lfsr_data = {my_lfsr_data[N-1:0], my_lfsr_data[N-1] ^ my_lfsr_data[5]};
      8: next_lfsr_data = {my_lfsr_data[N-1:0], my_lfsr_data[N-1] ^ my_lfsr_data[5] ^  my_lfsr_data[4] ^  my_lfsr_data[3]};
    endcase

    if (next_lfsr_data == seed_data)
      lfsr_done = 1;
    else  
      lfsr_done = 0;
  end
end

assign lfsr_data = my_lfsr_data;

//Guidance on translating polynomials to HW though pseudocodes below
//For N=4: polynomial is x^4+ x^3 + 1
//the corrresponding pseudo-code for XOR gate given below. Notice that the index used is one less than the equation
	//xor_output = lfsr_data[3] ^ lfsr_data[2];
	
//Another example, when N=5, the correponding polynomial is x^5 + x^3 + 1
//this polynomial will yield XOR hardware shown by pseudo code below
	//xor_output = lfsr_data[4] ^ lfsr_data[2];
	
//Note: We are tapping indexes which are one less than the exponent. This is because the numbering for the polynomial exponents starts from 1 and goes till N....whereas, the numbering convention we follow is starting from 0 going up to N-1. 

//student to add implementation for LFSR code below

initial begin
	$dumpfile("dump.vcd.tmp");
	$dumpvars;
end

endmodule: lfsr