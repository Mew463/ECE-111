// UART TX RTL Code
module uart_top #(parameter NUM_CLKS_PER_BIT=16)
(input             tx_clk, tx_rstn, rx_clk, rx_rstn,  
 input [7:0]       tx_din,
 input             tx_start,
 output logic      tx_done, rx_done,
 output logic[7:0] rx_dout);


// wire to connect output of uart_tx "tx" signal to
// uart_rx "rx" signal
wire serial_data_bit;

// Instantiate uart transmitter module
// student to add code

uart_tx #(.NUM_CLKS_PER_BIT(NUM_CLKS_PER_BIT)) uart_tx_instance (
  .clk(tx_clk),
  .rstn(tx_rstn),
  .din(tx_din),
  .start(tx_start),
  .done(tx_done),
  .tx(serial_data_bit)
);

// Instantiate uart receiver module
// student to add code

uart_rx #(.NUM_CLKS_PER_BIT(NUM_CLKS_PER_BIT)) uart_rx_instasnce (
  .clk(rx_clk),
  .rstn(rx_rstn),
  .rx(serial_data_bit),
  .done(rx_done),
  .dout(rx_dout)
);

endmodule: uart_top


