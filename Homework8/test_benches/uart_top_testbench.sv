//UART TOP Testbench Code
`timescale 1ns/1ns
module uart_top_testbench;
// Uart Transmitter and Receiver clock frequency
// CLK_PERIOD_NS * 2 = 10 x 2 = 20ns
parameter CLK_PERIOD_NS = 10;

// Number of bits in UART packets
// 1 Start bit + 8 Data Bits + 1 Stop bit = 10
parameter NUM_SERIAL_BITS = 10;

// Number of clocks per bit will be used by 
// within uart transmitter and receiver.
// Witin Uart Tx, this will be used to transmit each serial bit
// for NUM_CLKS_PER_BIT count.
// Within Uart Rx, this will be used to find mid point of serial data bit
// and then sample data.
// NUM_CLKS_PER_BIT = Frequency / Baud Rate
// Frequency = 1 / (2 * CLK_PERIOD_NS)
// Example : for Frequency 50 Mhz, Baud Rate = 115200
// NUM_CLKS_PER_BIT = (50 x 10^6) / 115200 = 434
// parameter NUM_CLKS_PER_BIT = 434;
parameter NUM_CLKS_PER_BIT = 62;  // for faster simulation and easy debug setting value to 16 instead of 434

// Only required for testbench for allowing 10 bits parallel
// data getting converted and transmitted serially on rx signal
// from uart receiver. Between two din packets injected by testbench
// into uart tx, this will be used as a delay
parameter TRANSMIT_TIME = (NUM_CLKS_PER_BIT * (CLK_PERIOD_NS*2) * NUM_SERIAL_BITS);

// local variable
bit clock_tx, clock_rx, clock_by_n, rstn;
bit start;
wire done, ready;
bit [7:0] din;
wire[7:0] dout;
logic[7:0] byte_data;
//logic[7:0] byte_data[int];
int index;

// Instantiate design under test
uart_top #(.NUM_CLKS_PER_BIT(NUM_CLKS_PER_BIT)) DUT(
.tx_clk(clock_tx),
.tx_rstn(rstn),
.rx_clk(clock_rx),
.rx_rstn(rstn),
.tx_start(start),
.tx_done(done),
.tx_din(din),
.rx_done(ready),
.rx_dout(dout)
);

initial begin

// Wait 20 ns for global reset to finish 
#20;
rstn = 1;
#20;

// Initialize 8-data to be transmitted
byte_data = 8'hA2;
for(integer i=0; i<4; i++) begin
 // wait for posedge of clock and then assign start = 1
 @(posedge clock_tx);
 start = 1;

 // wait for once cycle and then assign start = 0
 @(posedge clock_tx);
 start = 0;

 // create new 8-bit data packet
 byte_data = byte_data + 8'h3;	   //	 $random;

 // assign uart tx input din, 8-bit generated datat
 din = byte_data;
           
//if (dout == byte_data)
// $display("Test Passed - Correct Byte Received time=%t  expected=%h   actual=%h", $time, byte_data, dout);
 //else
 // $display("Test Error- Incorrect Byte Received time=%t  expected=%h   actual=%h", $time, byte_data, dout);

 //#(BIT_PERIOD_NS);

 // wait until entire uart tx packet (10bits din) are
 // serially transmitted by uart transmitter
 // on its rx output signal before new uart packet
 // are injected into uart transmitter
 #TRANSMIT_TIME;

 // wait for uart transmitter to indicate to testbench
 // that entire 10-bits were transmitted, before new
 // uart packet is injected into uart transmitter
 @(negedge done);
end

// Wait & terminate
#500ns $finish;
end

// wait for ready signal to be asserted from
// uart receiver to capture parallel data
// out (dout) from uart receiver and compare with
// parallel 8bit data which was injected into 
// uart transmitter on din signal.
always@(posedge ready) begin
 // Check that the correct 8-bit parallel data was received at the output of uart rx on dout port 
 if (dout == byte_data)
  $display("Test Passed - Correct Byte Received time=%t  expected=%h   actual=%h", $time, byte_data, dout);
 else begin
  $error("Test Error- Incorrect Byte Received time=%t  expected=%h   actual=%h", $time, byte_data, dout);
  $finish;
 end
 index = index + 1; 
end

// Clock generator logic (used by both uart tx and uart rx modules)
always begin
  #CLK_PERIOD_NS clock_tx = 1'b1;
  #CLK_PERIOD_NS clock_tx = 1'b0;
end
always begin
  #CLK_PERIOD_NS clock_rx = 1'b1;
  #CLK_PERIOD_NS clock_rx = 1'b0;
end

initial begin
	$dumpfile("dump.vcd.tmp");
	$dumpvars;
end
endmodule