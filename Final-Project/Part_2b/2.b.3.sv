module viterbi_tx_rx(
   input    clk,
   input    rst,
   input    encoder_i,
   input    enable_encoder_i,
   output   decoder_o);

   wire  [1:0] encoder_o;

   int error_counter;
   logic   [1:0] encoder_o_reg;
   
   logic       enable_decoder_in;
   wire        valid_encoder_o;

   int bad_bit_ct = 1;
   int word_ct = 0;

   always @ (posedge clk, negedge rst) 
      if(!rst) begin  
         error_counter  <= 0;
         encoder_o_reg  <= 2'b00;
         enable_decoder_in <= 1'b0;
      end
      else	   begin   
         word_ct = word_ct + 1;

         enable_decoder_in <= valid_encoder_o; 
         encoder_o_reg  <= 2'b00;
         error_counter  <= error_counter + 1;
         if($random % 16 == 0) begin
            encoder_o_reg  <= {~encoder_o[1],~encoder_o[0]};	 
            if (word_ct <= 256) begin
               bad_bit_ct <= bad_bit_ct + 1;
               $display("bad bits = %d", bad_bit_ct);
            end
         end
         else
            encoder_o_reg  <= {encoder_o[1],encoder_o[0]};
      end   

// insert your convolutional encoder here
// change port names and module name as necessary/desired
   encoder encoder1	     (
      .clk,
      .rst,
      .enable_i(enable_encoder_i),
      .d_in(encoder_i),
      .valid_o(valid_encoder_o),
      .d_out(encoder_o)   );

// insert your term project code here 
   decoder decoder1	     (
      .clk,
      .rst,
      .enable(enable_decoder_in),
      .d_in(encoder_o_reg),
      .d_out(decoder_o)   );

endmodule
