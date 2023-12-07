// CPEN 230L 5-digit counter test bench
// Daniel Hong 11/29/23

`timescale 1ms / 1us  // 1ms time tick, with 1us resolution

module cnt5digits_tb;
    reg     clk = 1'b1;
    reg     nLoad;
    reg     enable = 1'b1;
    reg     up_down;
    reg     [7:0]   loadVal = 8'b0;
    wire    [3:0]   digit0;
    wire    [3:0]   digit1;
    wire    [3:0]   digit2;
    wire    [3:0]   digit3;
    wire    [3:0]   digit4;

    always
        #0.25 clk = ~clk;   // clock flip every 0.25 ms
                            // totalling 2 clock cycles per ms
                            
    initial begin
        $dumpfile("a.vcd");                 // for GTKWave
        $dumpvars(0, cnt5digits_tb);        // for GTKWave
        $display(" time count");            // table header
        $monitor("%3dms %1d%1d%1d%1d%1d",   // table data
                $time, digit4, digit3, digit2, digit1, digit0);
        
                                            // Test sequence
                up_down = 1'b0;             // @ t=0,       set direction to down
                nLoad = 1'b0;               //              reset the timer
	    #0.26	nLoad = 1'b1;               // @ t=0.26 ms, release nLoad/nRst, clock start to count at next cycle
	    #0.24	loadVal = 8'b00010000;      // @ t=0.5  ms, set loadVal to 10, clock not affected
        #36.125 up_down = 1'b1;             // @ t=36.75ms, set direction to up and reload the timer with value 10
                nLoad = 1'b0;               //              showing reset is synchronous, as value is not reset until next pos clk edge
        #2.375  nLoad = 1'b1;               // @ t=39   ms, releast nLoad/nRst, clock start to count
        #7.50   enable = 1'b0;              // @ t=46.50ms, disable the counter
        #4.125  enable = 1'b1;              // @ t=50.75ms, enable the counter, showing disable control is synchronous, 
                                            //              as it start the clock on the next pos clk edge
        #4.375  $finish;                    // @ t=55   ms, finish the simulation
    end

    // DUT, Base 2, terminal count 1, 1 bit width counter
    cnt5digits #(.freq_p (2000), .base_p (2), .update_per_sec_p (125)) DUT (
        clk, enable, nLoad, up_down, loadVal, {digit4, digit3, digit2, digit1, digit0});
endmodule
