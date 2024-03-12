module tbu
(
input       clk,
input       rst,
input       enable,
input       selection,
input [7:0] d_in_0,
input [7:0] d_in_1,
output logic  d_o,
output logic  wr_en);

logic         d_o_reg;
logic         wr_en_reg;

logic   [2:0] pstate;
logic   [2:0] nstate;

logic         selection_buf;

always @(posedge clk)    begin
   selection_buf  <= selection;
   wr_en          <= wr_en_reg;
   d_o            <= d_o_reg;
end
always @(posedge clk, negedge rst) begin
   if(!rst)
      pstate   <= 3'b000;
   else if(!enable)
      pstate   <= 3'b000;
   else if(selection_buf && !selection)
      pstate   <= 3'b000;
   else
      pstate   <= nstate;
end

always_comb begin
   wr_en_reg = selection;
   d_o_reg = (selection)? d_in_1[pstate] : 1'b0;
   case (pstate)
      0: if (!selection)
            if (d_in_0[pstate] == 1'b0)
               nstate = 0;
            else
               nstate = 1;
         else
            if (d_in_1[pstate] == 1'b0)
               nstate = 0;
            else
               nstate = 1;

      1: if (!selection)
            if (d_in_0[pstate] == 1'b0)
               nstate = 3;
            else
               nstate = 2;
         else
            if (d_in_1[pstate] == 1'b0)
               nstate = 3;
            else
               nstate = 2;

      2: if (!selection)
            if (d_in_0[pstate] == 1'b0)
               nstate = 4;
            else
               nstate = 5;
         else
            if (d_in_1[pstate] == 1'b0)
               nstate = 4;
            else
               nstate = 5;

      3: if (!selection)
            if (d_in_0[pstate] == 1'b0)
               nstate = 7;
            else
               nstate = 6;
         else
            if (d_in_1[pstate] == 1'b0)
               nstate = 7;
            else
               nstate = 6;

      4: if (!selection)
            if (d_in_0[pstate] == 1'b0)
               nstate = 1;
            else
               nstate = 0;
         else
            if (d_in_1[pstate] == 1'b0)
               nstate = 1;
            else
               nstate = 0;

      5: if (!selection)
            if (d_in_0[pstate] == 1'b0)
               nstate = 2;
            else
               nstate = 3;
         else
            if (d_in_1[pstate] == 1'b0)
               nstate = 2;
            else
               nstate = 3;

      6: if (!selection)
            if (d_in_0[pstate] == 1'b0)
               nstate = 5;
            else
               nstate = 4;
         else
            if (d_in_1[pstate] == 1'b0)
               nstate = 5;
            else
               nstate = 4;

      7: if (!selection)
            if (d_in_0[pstate] == 1'b0)
               nstate = 6;
            else
               nstate = 7;
         else
            if (d_in_1[pstate] == 1'b0)
               nstate = 6;
            else
               nstate = 7;
   endcase

end

/*  combinational logic drives:
wr_en_reg, d_o_reg, nstate (next state)
from selection, d_in_1[pstate], d_in_0[pstate]
See assignment text for details
*/

endmodule
