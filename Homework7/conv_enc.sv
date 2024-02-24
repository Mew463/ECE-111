// rate 1/2 convolutional encoder with programmable taps and length
// bitwise row of AND gates makes feedback pattern programmable
// N = 1 + constraint length
module conv_enc #(parameter N = 6)( // N = shift reg. length
  input     clk, data_in, reset,
  input       [  1:0] load_mask,  // 1: load mask0 pattern; 2: load mask1 
  input       [N-1:0] mask,       // mask pattern to be loaded; prepend with 1  
  output logic[  1:0] data_out    // encoded data out
);  

logic [1:0] my_data_out;
logic [N-1:0] shift_reg;
logic [N-1:0] mask_a, mask_b;


always_ff @(posedge clk, negedge reset) begin // This should be shift register code
  if (!reset) begin
    shift_reg <= {N{1'b0}};
  end
  else begin
    shift_reg <= {shift_reg[N-1:1], data_in};
  end 
end

always_ff @(posedge clk) begin // Check for loading on the posedge of every clock
  if (load_mask == 1)
    mask_a <= mask;
  if (load_mask == 0)
    mask_b <= mask;
end

always_comb begin
  my_data_out[0] = ^(mask_a & shift_reg);
  my_data_out[1] = ^(mask_b & shift_reg);
end

assign data_out = my_data_out;

/* fill in the guts.
Hint: You need to build two parallel single-bit shift registers 
and AND/XOR networks. Build two indepenent single-bit encoders in paralle.
 */

endmodule