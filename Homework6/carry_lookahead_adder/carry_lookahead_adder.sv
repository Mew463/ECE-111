// `include "fulladder.sv"
module carry_lookahead_adder#(parameter N=4)(
  input logic[N-1:0] A, B,
  input logic CIN,
  output logic[N:0] result
);

logic[N:0] myresult;
logic[N-1:0] myCIN;
logic lastcout;


always_comb begin
  myCIN[0] = CIN;
  myCIN[1] = (A[0]&B[0]) | ((A[0]|B[0])&myCIN[0]);
  myCIN[2] = (A[1]&B[1]) | ((A[1]|B[1])&myCIN[1]);
  myCIN[3] = (A[2]&B[2]) | ((A[2]|B[2])&myCIN[2]);
  // $display("%b",myCIN);
end

fulladder FA0 (.a(A[0]), .b(B[0]), .cin(myCIN[0]), .sum(myresult[0]));
fulladder FA1 (.a(A[1]), .b(B[1]), .cin(myCIN[1]), .sum(myresult[1]));
fulladder FA2 (.a(A[2]), .b(B[2]), .cin(myCIN[2]), .sum(myresult[2]));
fulladder FA3 (.a(A[3]), .b(B[3]), .cin(myCIN[3]), .sum(myresult[3]), .cout(lastcout));

assign myresult[4] = lastcout;
assign result = myresult;

  
endmodule: carry_lookahead_adder

