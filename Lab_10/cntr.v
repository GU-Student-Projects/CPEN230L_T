// CPEN 230L lab 10 counter
// Daniel Hong 11/16/2023

module cntr 
	#(parameter ct_tc_p)
	(clk_i, enable_i, nLoad_i, loadVal_i, up_i, count_o, term_cnt_o);
	
	input clk_i, enable_i, nLoad_i, up_i;
	input [3:0] loadVal_i;
	output [3:0] count_o;
	output reg term_cnt_o;
	
	reg [3:0] count_r;
	
	always @(posedge clk_i)
	begin
		if (!nLoad_i)
			if (loadVal_i < ct_tc_p)
				count_r = loadVal_i;
			else
				count_r = ct_tc_p;
		else if (enable_i)
			if (up_i)
				if (count_r == ct_tc_p)
					count_r = 0;
				else
					count_r = count_r +1;
			else
				if (count_r == 0)
					count_r = ct_tc_p;
				else
					count_r = count_r -1;
		if (((up_i) & (count_r == ct_tc_p)) | ((!up_i) & (count_r == 4'h0)))
			term_cnt_o = 1'b1;
		else
			term_cnt_o = 1'b0;
	end
	assign count_o = count_r;
endmodule
