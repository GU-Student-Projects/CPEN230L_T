// CPEN 230L lab 10 5-digit counter
// Daniel Hong 11/30/2023

module cnt5digits
	#(parameter freq_p = 50000000,
	  parameter base_p = 10,
	  parameter update_per_sec_p = 1)
	(clk_i, enable_i, nLoad_i, up_i, loadVal_i, count_o);
	
	input clk_i, enable_i, nLoad_i, up_i;
	input [7:0] loadVal_i;
	output [19:0] count_o;
	wire [4:0] cntr_r;
	
	// get clk update
	cntrStage #(.cntr_bits_p ($clog2(freq_p/base_p/base_p/base_p/update_per_sec_p -1)),
				.cntr_tc_p (freq_p/base_p/base_p/base_p/update_per_sec_p -1))
	clk_upd_stage (clk_i, nLoad_i, enable_i, cntr_r[0], );
	
	// 5 digit counter
	cntr #(.ct_tc_p(base_p -1))
	dig_0 (clk_i, cntr_r[0]&enable_i, nLoad_i, 4'b0000, up_i, count_o[ 3: 0], cntr_r[1]);
	
	cntr #(.ct_tc_p(base_p -1))
	dig_1 (clk_i, cntr_r[1]&cntr_r[0]&enable_i, nLoad_i, 4'b0000, up_i, count_o[ 7: 4], cntr_r[2]);
	
	cntr #(.ct_tc_p(base_p -1))
	dig_2 (clk_i, cntr_r[2]&cntr_r[1]&cntr_r[0]&enable_i, nLoad_i, 4'b0000, up_i, count_o[11: 8], cntr_r[3]);
	
	cntr #(.ct_tc_p(base_p -1))
	dig_3 (clk_i, cntr_r[3]&cntr_r[2]&cntr_r[1]&cntr_r[0]&enable_i, nLoad_i, loadVal_i[3:0], up_i, count_o[15:12], cntr_r[4]);
	
	cntr #(.ct_tc_p(base_p -1))
	dig_4 (clk_i, cntr_r[4]&cntr_r[3]&cntr_r[2]&cntr_r[1]&cntr_r[0]&enable_i, nLoad_i, loadVal_i[7:4], up_i, count_o[19:16],);
	
endmodule

