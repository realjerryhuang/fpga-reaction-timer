module stopwatch(input logic clk,	// System clock (100 MHz)
				input logic rst,	// Active high reset
				input logic start_watch,	// When high, the watch counts
				output logic [$clog2(10000)-1:0] elapsed_time	
				// Time in ms (needs to hold up to 9,999)
);
	
	logic clk_in;	// 1 kHz clock signal
	
	clock_divider my_clk(clk, rst, clk_in);	// Instantiate clock_divider module
	
	always_ff @(posedge clk_in, posedge rst)
		// Reset:
		if (rst) 
			elapsed_time <= '0;
		// Stopwatch at 9,999:
		else if (elapsed_time == 9999 && start_watch == 1)
			elapsed_time <= '0;
		// Stopwatch running:
		else if (start_watch == 1)
			elapsed_time <= elapsed_time + 1;
endmodule
