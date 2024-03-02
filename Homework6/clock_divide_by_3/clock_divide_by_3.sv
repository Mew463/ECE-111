//clock divide by 3 RTL code
module clock_divide_by_3 ( 
 input  logic clkin, reset,
 output logic clkout);

logic [2:0] i;
logic [2:0] nexti;
always_ff @(posedge clkin) begin
    if (reset) begin
        clkout <= 0;
        i <= 0;
    end 
    else
        i <= nexti;
end

always_ff @(negedge clkin) begin
    if (!reset && i != 0) // Want our clock to start on the rising edge of the main clock cycle
        i <= nexti;
end

always_comb begin
    nexti = i + 1;
    if (nexti > 5)
        nexti = 0;

    if (i < 4 && i > 0)
        clkout = 1;
    else
        clkout = 0;
end

endmodule: clock_divide_by_3