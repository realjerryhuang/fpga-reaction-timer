module basys_ssd(input logic clk,	// 100 MHz system clock
				input logic rst,	// Active high reset
				input logic [6:0] ssd_in [3:0],	// Four digits to display
				output logic [3:0] an,	// Display to drive
				output logic [6:0] seg	// Number to display
);

	logic clk_in;	// Decreased clock speed for refresh rate
	clock_divider #(50000) my_clock(clk, rst, clk_in);	// 1 kHz
	
	logic [1:0] counter;	// Cycle between displays
	
	// Sequential; increment counter:
	always_ff @(posedge clk_in, posedge rst)
		if (rst) counter <= 0;
		else counter <= counter + 1;
	
	// Combinational; assign an and seg	
	always_comb begin
		case (counter)
			2'd0:	an = 4'b1110;	// Digit 0
			2'd1:	an = 4'b1101;	// Digit 1
			2'd2:	an = 4'b1011;	// Digit 2
			2'd3:	an = 4'b0111;	// Digit 3
		endcase
		seg = ssd_in[counter];
	end
endmodule