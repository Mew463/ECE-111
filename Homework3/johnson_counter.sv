// 4-bit counter behavioral code
`timescale 1ns/1ns
module johnson_counter    // Module start declaration
 // Parameter declaration, count signal width set to '4'  
 #(parameter WIDTH=4)  
 ( 
    input logic clk,
    input logic clear, 
    input logic preset,
    input  wire[WIDTH-1:0] load_cnt,
    output wire[WIDTH-1:0] count
 );

 // Local variable declaration since you can't assign OUTPUT values in ALWAYS statements 
 reg[WIDTH-1:0] cnt_value; 
  
// TA Said to only have one always block or else it will toggle unpredictably
// ADD THE ENTIRE WAVEFORM!!
 always @(posedge clk, negedge clear) 
    begin
        if (~clear)
            cnt_value = 4'b0000;
        else begin
            if (preset == 0)
                cnt_value = load_cnt;
            else    
                cnt_value = {~cnt_value[0], cnt_value[3:1]};
        end
    end       
assign count = cnt_value; // Turns out you can't assign OUTPUT values in ALWAYS statements 

initial begin
    $dumpfile("dump.vcd.tmp");
    $dumpvars;
end

endmodule: johnson_counter  // Module end declaration