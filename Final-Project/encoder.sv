module encoder               // use this one
(  input             clk,
   input             rst,
   input             enable_i,
   input             d_in,
   output logic      valid_o,
   output logic [1:0] d_out);

   // logic [1:0] tmp_d_out;
   
   logic         [2:0] cstate;
   logic         [2:0] nstate;
   logic               valid_oQ;   
   logic         [1:0] d_out_reg;

   always_comb begin
      valid_oQ  =   enable_i;
   end								   

   assign d_out_reg[0] = d_in;
   assign d_out_reg[1] = d_in ^ cstate[2] ^ cstate[1];
   assign nstate[1:0]  = cstate[2:1];
   assign nstate[2]    = d_in^cstate[1]^cstate[0];

   always @ (posedge clk,negedge rst)   begin
      // $display("data in=%d cstate=%d nstate=%d data out=%b%b",d_in,cstate, nstate, d_out_reg[1],d_out_reg[0]);
      if(!rst)
         cstate   <= 3'b000;
      else if(!enable_i)
         cstate   <= 3'b000;
      else
         cstate   <= nstate;
      
      d_out    <=  (enable_i)? d_out_reg : 2'b00;
	   valid_o  <= valid_oQ;
   end

   // assign d_out = tmp_d_out;

endmodule
