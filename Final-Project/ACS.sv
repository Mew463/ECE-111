module ACS		                        // add-compare-select
(
input       path_0_valid,
input       path_1_valid,
input [1:0] path_0_bmc,	            // branch metric computation
input [1:0] path_1_bmc,				
input [7:0] path_0_pmc,				   // path metric computation
input [7:0] path_1_pmc,

output logic        selection,
output logic        valid_o,
output [7:0]  path_cost
);  

wire  [7:0] path_cost_0;			   // branch metric + path metric
wire  [7:0] path_cost_1;
logic [1:0] paths;

logic [7:0] path_cost_tmp;

assign paths = {path_0_valid,path_1_valid};
assign path_cost_0 = path_0_pmc + path_0_bmc;
assign path_cost_1 = path_1_pmc + path_1_bmc;
assign path_cost = path_cost_tmp;

always_comb begin
   valid_o = path_0_valid|path_1_valid;
   case(paths) 
      2'b00: begin
         selection = 0;
         path_cost_tmp = 0;
      end
      2'b01: begin
         selection = 1;
         path_cost_tmp = path_cost_1;
      end
      2'b10: begin
         selection = 0;
         path_cost_tmp = path_cost_0;
      end
      2'b11: begin
         if (path_cost_0 > path_cost_1) begin
            selection = 1; 
            path_cost_tmp = path_cost_1;
         end
         else begin
            selection = 0; 
            path_cost_tmp = path_cost_0;
         end
      end
   endcase
end


/* Fill in the guts per ACS instructions
*/

endmodule
