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
int count = 0;

always_ff @(posedge clk, negedge reset_n) // Want to use always_ff for clock 
begin
  if (!reset_n) begin
    my_lfsr_data <= {N{1'b0}};
    count <= 0;
  end
  else begin
    if (load_seed) begin
      my_lfsr_data <= seed_data;
      count <= 0;
    end
    else begin
      if (N != 5 && N != 8) 
        my_lfsr_data <= {my_lfsr_data[N-1:0], my_lfsr_data[N-1] ^ my_lfsr_data[N-2]};
      else if (N == 5) 
        my_lfsr_data <= {my_lfsr_data[N-1:0], my_lfsr_data[N-1] ^ my_lfsr_data[N-3]};
      else 
        my_lfsr_data <= {my_lfsr_data[N-1:0], my_lfsr_data[N-1] ^ my_lfsr_data[5] ^  my_lfsr_data[4] ^  my_lfsr_data[3]};

      // $display("%d", count);
      if (count == (2**N))
        count <= 2;
      else
        count <= count + 1;
  
    end
  end
end

assign lfsr_done = (count == (2**N)-2);

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