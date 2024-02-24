// rate 1/2 convolutional encoder with programmable taps and length
// bitwise row of AND gates makes feedback pattern programmable
// N = 1 + constraint length
module conv_enc #(parameter N = 6)( // N = shift reg. length
  input        clk, data_in, reset,
  input  [1:0] load_mask,  // 1: load mask0 pattern; 2: load mask1 
  input  [N-1:0] mask,       // mask pattern to be loaded; prepend with 1  
  output logic[1:0] data_out    // encoded data out
);  

logic [N-1:0] shift_reg, mask_a, mask_b;

always_ff @(posedge clk, negedge reset) begin // This should be shift register code
  if (!reset) 
    shift_reg <= {N{1'b0}};
  else 
    if (load_mask == 2'b00)
      shift_reg <= {data_in, shift_reg[N-1:1]}; // According to testbench it should be MSB on the left
end

always_ff @(posedge clk) begin // Check for loading on the posedge of every clock
  if (load_mask == 2'b01)
    mask_a <= mask;
  if (load_mask == 2'b10)
    mask_b <= mask;
end

always_comb begin
  data_out[0] = ^(mask_a & shift_reg);
  data_out[1] = ^(mask_b & shift_reg);
end

endmodule