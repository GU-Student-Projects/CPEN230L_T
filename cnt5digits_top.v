// CPEN 230L lab 10 5-digit counter top file
// Daniel Hong 11/30/2023

module cnt5digits_top(CLOCK_50, KEY3, KEY0, SW, HEX5, HEX4, HEX3, HEX2, HEX1);
	input CLOCK_50, KEY3, KEY0;
	input [17:0] SW;
	output [6:0] HEX5;
	output [6:0] HEX4;
	output [6:0] HEX3;
	output [6:0] HEX2;
	output [6:0] HEX1;
	
	wire clean_nLoad_w, clean_enable_w;
	wire [19:0] count_w;
	
	parameter clk_freq = 50000000;
	parameter base = 16;
	parameter update_per_sec = 1;
	
	// input debouncer for enable and load
	debouncer db_load(CLOCK_50, KEY0, clean_nLoad_w);
	debouncer db_halt(CLOCK_50, KEY3, clean_enable_w);
	
	// 5-digit counter
	cnt5digits
	#(.freq_p (clk_freq),
	  .base_p (8), 
	  .update_per_sec_p (update_per_sec))
	cntr (CLOCK_50, clean_enable_w, clean_nLoad_w, SW[9], SW[17:10], count_w);
	
	// output count
	dec7seg_m dec5(count_w[19:16], HEX5);
	dec7seg   dec4(count_w[15:12], HEX4);
	dec7seg   dec3(count_w[11: 8], HEX3);
	dec7seg   dec2(count_w[ 7: 4], HEX2);
	dec7seg   dec1(count_w[ 3: 0], HEX1);
endmodule
c