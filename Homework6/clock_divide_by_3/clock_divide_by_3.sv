//clock divide by 3 RTL code
module clock_divide_by_3 ( 
 input  logic clkin, reset,
 output logic clkout);

logic myclkout;
logic [2:0] i;
logic [2:0] nexti;
always_ff @(posedge clkin or posedge reset) begin
    if (reset) begin
        myclkout <= 0;
        i <= 0;
    end 
    else
        i <= nexti;
end

always_ff @(negedge clkin) begin
    i <= nexti;
    // if (i != 0)
    //     i <= i + 1;
end

always_comb begin
    nexti = i + 1;
    if (nexti > 5)
        nexti = 0;

    if (i < 4 && i > 0)
        myclkout = 1;
    else
        myclkout = 0;
end

// always @(i) begin
//     if (i > 5)
//         i = 0;

//     if (i < 4 && i > 0)
//         myclkout = 1;
//     else
//         myclkout = 0;
// end


assign clkout = myclkout; 

endmodule: clock_divide_by_3