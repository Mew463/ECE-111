// Barrel Shifter RTL Model
// `include "mux_2x1_behavioral.sv"
module barrel_shifter (
  input logic select,  // select=0 shift operation, select=1 rotate operation
  input logic direction, // direction=0 right move, direction=1 left move
  input logic[1:0] shift_value, // number of bits to be shifted (0, 1, 2 or 3)
  input logic[3:0] din,
  output logic[3:0] dout
);

logic[3:0] my_din, my_dout;

logic[3:0] stage1_mux_in0, stage1_mux_in1, stage1_mux_out;
logic[3:0] stage2_mux_in0, stage2_mux_in1, stage2_mux_out;

always@(din) begin // Updates all the INPUT values based on DIR or SEL
  if (direction == 1) begin // This is for left shift
    my_din[0] = din[3];
    my_din[1] = din[2];
    my_din[2] = din[1];
    my_din[3] = din[0];
  end
  if (direction == 0) begin // This is for right shift
    my_din[0] = din[0];
    my_din[1] = din[1];
    my_din[2] = din[2];
    my_din[3] = din[3];
  end

  stage1_mux_in0[3:0] = my_din[3:0]; // Setup the in0s for the stage1 muxes
  
  if (select == 0) begin     // Shift
    stage1_mux_in1[3] = 0;
    stage1_mux_in1[2] = 0;
  end else begin             // Rotate
    stage1_mux_in1[3] = my_din[1];
    stage1_mux_in1[2] = my_din[0];
  end
  stage1_mux_in1[1] = my_din[3]; // This stuff always happens
  stage1_mux_in1[0] = my_din[2];
end

// Instantiate module and calculates first stage MUXes
mux_2x1 firstStageBarrelMuxes[0:3] (.in0(stage1_mux_in0), .in1(stage1_mux_in1), .sel(shift_value[1]), .out(stage1_mux_out));

always@(stage1_mux_out) begin  // Updates all the second stage MUXes after first stage is done
  stage2_mux_in0[3] = stage1_mux_out[3];
  stage2_mux_in1[2] = stage1_mux_out[3];
  stage2_mux_in0[2] = stage1_mux_out[2];
  stage2_mux_in1[1] = stage1_mux_out[2];
  stage2_mux_in0[1] = stage1_mux_out[1];
  stage2_mux_in1[0] = stage1_mux_out[1];
  stage2_mux_in0[0] = stage1_mux_out[0];
  if (select == 0) begin // Shift
    stage2_mux_in1[3] = 0;
  end else begin         // Rotate
    stage2_mux_in1[3] = stage1_mux_out[0];
  end
end

// Instantiate module and calculates second stage MUXes
mux_2x1 secondStageBarrelMuxes[0:3] (.in0(stage2_mux_in0), .in1(stage2_mux_in1), .sel(shift_value[0]), .out(stage2_mux_out));

always@(stage2_mux_out) begin // This block needs to run once dout values get updated
  if (direction == 1) begin 
    my_dout[0] = stage2_mux_out[3];
    my_dout[1] = stage2_mux_out[2];
    my_dout[2] = stage2_mux_out[1];
    my_dout[3] = stage2_mux_out[0];
  end

  if (direction == 0) begin
    my_dout[0] = stage2_mux_out[0];
    my_dout[1] = stage2_mux_out[1];
    my_dout[2] = stage2_mux_out[2];
    my_dout[3] = stage2_mux_out[3];
  end 
end

assign dout[3:0] = my_dout[3:0];

initial begin
	$dumpfile("dump.vcd.tmp");
	$dumpvars;
end

endmodule: barrel_shifter


