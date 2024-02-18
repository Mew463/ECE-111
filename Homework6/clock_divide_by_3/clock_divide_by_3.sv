//clock divide by 3 RTL code
module clock_divide_by_3 ( 
 input  logic clkin, reset,
 output logic clkout);

logic myclkout;
int i = 0;
always_ff @(posedge clkin or posedge reset) begin
    if (reset) begin
        myclkout <= 0;
        i <= 0;
    end 
    else 
        i <= i + 1;
end

always_ff @(negedge clkin) begin
    if (i != 0)
        i <= i + 1;
end


always @(i) begin
    if (i > 5)
        i = 0;

    if (i < 4 && i > 0)
        myclkout = 1;
    else
        myclkout = 0;
end


assign clkout = myclkout; 

endmodule: clock_divide_by_3