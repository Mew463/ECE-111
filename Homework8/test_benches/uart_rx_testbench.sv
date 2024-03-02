//UART RX Testbench Code
`timescale 1ns/1ns
module uart_rx_testbench;

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
// Note : Below mentioned parameter is set to 16 which corresponds to 3.125,000 baudrate which is not supported by UART 
// However 16 is still set below for faster simulation and validate Uart Rx FSM.
parameter NUM_CLKS_PER_BIT = 16; 

// Each serial data bit period. 
// Uart Transmitter each clock time period
// Only used in testbench to inject serial bits into uart receiver
parameter BIT_PERIOD_NS = (NUM_CLKS_PER_BIT * (CLK_PERIOD_NS *2));

// Effectively both transmitter and receiver are having same bit period
// Uart Tx Bit Period = BIT_PERIOD_NS  (320ns)
// Uart Rx Bit Period = NUM_CLKS_PER_BIT * CLK_PERIOD_NS * 2 (16 x 20 = 320ns)

logic clock, clock_by_n, rstn;
logic rx, done;
logic [7:0] dout;
logic[7:0] byte_data;

// Instantiate design under test
uart_rx #(.NUM_CLKS_PER_BIT(NUM_CLKS_PER_BIT)) DUT(
.clk(clock),
.rstn(rstn),
.rx(rx),
.done(done),
.dout(dout)
);

initial begin
// Initialize Inputs
rstn = 0;
clock = 0;
clock_by_n = 0;
rx = 0;

// Wait 20 ns for global reset to finish 
#20;
rstn = 1;
rx = 1; // Initialize rx = 1 to be in stop state
#20;

// Initialize data to be transmitted into uart rx
byte_data = 8'hA2;

// Send 8-bit of data serially 4 times into uart rx module
for(integer i=0; i<4; i++) begin
 // Create 8-bit data packet with some random value
 byte_data = byte_data + 8'h3;

 // Wait for 1 clock period
 @(posedge clock_by_n);

 // Transmit 8-bit data serially to uart rx
 uart_write_byte(byte_data);
            
 // Check that the correct 8-bit parallel data was received at the output of uart rx on dout port 
 if (dout == byte_data)
  $display("Test Passed - Correct Byte Received time=%t  expected=%h   actual=%h", $time, byte_data, dout);
 else
  $display("Test Error- Incorrect Byte Received time=%t  expected=%h   actual=%h", $time, byte_data, dout);

 // Wait for half a clock edge of rx transmitting data rate 
 #(BIT_PERIOD_NS);
end

// Wait for some time
#500ns;

// terminate simulation
$finish();
end


// Drive 8-bit serial data on uart receiver rx port 
task uart_write_byte (input logic [7:0] data);
 begin
  // Send Start Bit
  rx = 1'b0;
  #(BIT_PERIOD_NS);
 
  // Send Data Byte serially
  for (int i=0; i<8; i=i+1) begin
   rx = data[i];
   #(BIT_PERIOD_NS);
  end
      
  // Send Stop Bit
  rx <= 1'b1;
 end
endtask

// Clock generator logic (faster clock for uart receiver to operate on)
always@(clock) begin
  #CLK_PERIOD_NS clock <= !clock;
end

// Clock generator logic.
// Slower clock. Each serial data bit will be generated by uart transmitter
// using this clock rate and sent to uart receiver asynchronously
always@(clock_by_n) begin
  #BIT_PERIOD_NS clock_by_n <= !clock_by_n;
  // $display("%b", dout);
end

initial begin
	$dumpfile("dump.vcd.tmp");
	$dumpvars;
end
endmodule