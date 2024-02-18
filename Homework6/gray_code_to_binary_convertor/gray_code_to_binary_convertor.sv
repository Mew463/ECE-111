module gray_code_to_binary_convertor #(parameter N = 4)( 
  input logic clk, rstn, 
  input logic[N-1:0] gray_value,
  output logic[N-1:0] binary_value);

logic[N-1:0] myout;

always_ff @(posedge clk, negedge rstn) begin
  if (!rstn) 
    myout = {N{1'b0}};
  else begin
    myout[N-1] = gray_value[N-1];
    for (int i = N-2; i >= 0; i--) begin
      myout[i] = gray_value[i] ^ myout[i+1];
    end
  end
end

assign binary_value = myout;

endmodule: gray_code_to_binary_convertor
