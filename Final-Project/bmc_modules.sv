module bmc000				  // branch metric computation case 0
(
   input    [1:0] rx_pair,
   output   [1:0] path_0_bmc,
   output   [1:0] path_1_bmc);

logic tmp00, tmp01, tmp10, tmp11;

tmp00 = rx_pair[0]; 
tmp10 = !rx_pair[0];

tmp01 = rx_pair[1];
tmp11 = !rx_pair[1];

path_0_bmc[1] = tmp00 & tmp01;
path_0_bmc[0] = tmp00 ^ tmp01;

path_1_bmc[1] = tmp10 & tmp11;
path_1_bmc[0] = tmp10 ^ tmp11;

endmodule

module bmc001				  // branch metric computation case 1 (INVERTED)
(
   input    [1:0] rx_pair,
   output   [1:0] path_0_bmc,
   output   [1:0] path_1_bmc);

logic tmp00, tmp01, tmp10, tmp11;

tmp00 = rx_pair[0]; 
tmp10 = !rx_pair[0];

tmp01 = !rx_pair[1];
tmp11 = rx_pair[1];

path_0_bmc[1] = tmp00 & tmp01;
path_0_bmc[0] = tmp00 ^ tmp01;

path_1_bmc[1] = tmp10 & tmp11;
path_1_bmc[0] = tmp10 ^ tmp11;

endmodule

module bmc010				  // branch metric computation case 2 (INVERTED)
(
   input    [1:0] rx_pair,
   output   [1:0] path_0_bmc,
   output   [1:0] path_1_bmc);

logic tmp00, tmp01, tmp10, tmp11;

tmp00 = rx_pair[0]; 
tmp10 = !rx_pair[0];

tmp01 = !rx_pair[1];
tmp11 = rx_pair[1];

path_0_bmc[1] = tmp00 & tmp01;
path_0_bmc[0] = tmp00 ^ tmp01;

path_1_bmc[1] = tmp10 & tmp11;
path_1_bmc[0] = tmp10 ^ tmp11;

endmodule

module bmc011				  // branch metric computation case 3
(
   input    [1:0] rx_pair,
   output   [1:0] path_0_bmc,
   output   [1:0] path_1_bmc);

logic tmp00, tmp01, tmp10, tmp11;

tmp00 = rx_pair[0]; 
tmp10 = !rx_pair[0];

tmp01 = rx_pair[1];
tmp11 = !rx_pair[1];

path_0_bmc[1] = tmp00 & tmp01;
path_0_bmc[0] = tmp00 ^ tmp01;

path_1_bmc[1] = tmp10 & tmp11;
path_1_bmc[0] = tmp10 ^ tmp11;

endmodule

module bmc100				  // branch metric computation case 4
(
   input    [1:0] rx_pair,
   output   [1:0] path_0_bmc,
   output   [1:0] path_1_bmc);

logic tmp00, tmp01, tmp10, tmp11;

tmp00 = rx_pair[0]; 
tmp10 = !rx_pair[0];

tmp01 = rx_pair[1];
tmp11 = !rx_pair[1];

path_0_bmc[1] = tmp00 & tmp01;
path_0_bmc[0] = tmp00 ^ tmp01;

path_1_bmc[1] = tmp10 & tmp11;
path_1_bmc[0] = tmp10 ^ tmp11;

endmodule

module bmc101				  // branch metric computation case 5 (INVERTED)
(
   input    [1:0] rx_pair,
   output   [1:0] path_0_bmc,
   output   [1:0] path_1_bmc);

logic tmp00, tmp01, tmp10, tmp11;

tmp00 = rx_pair[0]; 
tmp10 = !rx_pair[0];

tmp01 = !rx_pair[1];
tmp11 = rx_pair[1];

path_0_bmc[1] = tmp00 & tmp01;
path_0_bmc[0] = tmp00 ^ tmp01;

path_1_bmc[1] = tmp10 & tmp11;
path_1_bmc[0] = tmp10 ^ tmp11;

endmodule

module bmc110				  // branch metric computation case 6 (INVERTED)
(
   input    [1:0] rx_pair,
   output   [1:0] path_0_bmc,
   output   [1:0] path_1_bmc);

logic tmp00, tmp01, tmp10, tmp11;

tmp00 = rx_pair[0]; 
tmp10 = !rx_pair[0];

tmp01 = !rx_pair[1];
tmp11 = rx_pair[1];

path_0_bmc[1] = tmp00 & tmp01;
path_0_bmc[0] = tmp00 ^ tmp01;

path_1_bmc[1] = tmp10 & tmp11;
path_1_bmc[0] = tmp10 ^ tmp11;

endmodule

module bmc111				  // branch metric computation case 7
(
   input    [1:0] rx_pair,
   output   [1:0] path_0_bmc,
   output   [1:0] path_1_bmc);

logic tmp00, tmp01, tmp10, tmp11;

tmp00 = rx_pair[0]; 
tmp10 = !rx_pair[0];

tmp01 = rx_pair[1];
tmp11 = !rx_pair[1];

path_0_bmc[1] = tmp00 & tmp01;
path_0_bmc[0] = tmp00 ^ tmp01;

path_1_bmc[1] = tmp10 & tmp11;
path_1_bmc[0] = tmp10 ^ tmp11;

endmodule