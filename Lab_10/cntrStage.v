// CPEN 230L lab 10, general-purpose cascadable counter stage
// Rick Nungester 3/30/16, Edited by John Tadrous 10/30/2017 and 11/13/2018

module cntrStage
  #(parameter cntr_bits_p = 4,    // number of bits in the counter
    parameter cntr_tc_p   = 9) (  // counter terminal count
  input  clk_i,       // positive edge triggered clock
  input  nRst_i,      // asynchronous active low reset
  input  enable_i,    // synchronous active high enable
  output term_cnt_o,  // set during terminal count
  output [cntr_bits_p-1:0] count_o ); // count value

  reg [cntr_bits_p-1:0] count_r=0;    // count register

  always @(posedge clk_i, negedge nRst_i) begin
    if (~nRst_i)
      count_r <= 0;              // if reset, set to 0
    else if (enable_i) begin
      if (count_r == cntr_tc_p)
        count_r <= 0;            // enabled & at tc, wrap to 0
      else
        count_r <= count_r + 1;  // enabled & not TC, increment
    end
  end

  // set outputs from registers used in the always block
  assign count_o = count_r;
  assign term_cnt_o = (count_r == cntr_tc_p);

endmodule
