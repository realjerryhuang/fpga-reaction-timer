module reaction_timer_top(
	input logic 		clk,			// 100 MHz system clock
	input logic 		rst,			// Active-high reset
	input logic 		start_stop_btn,	// User button
	output logic 		led,			// Reaction indicator
	output logic [3:0] 	an,				// SSD anodes
	output logic [6:0] 	seg				// SSD segments
);
	
	// Define states (RESET, SET, GO, SCORE):
	typedef enum logic [1:0] {S0, S1, S2, S3} statetype;
	statetype state, nextstate;
	
	// INTERNAL SIGNALS
	// Start/stop button edge detection:
	logic start_btn_d;
	logic start_pulse;
	
	// Random delay counter:
	logic my_clk;
	logic [7:0] delay;
	logic [7:0] delay_counter;
	logic delay_done;
	
	// Stopwatch:
	logic stopwatch_en;
	logic [$clog2(10000)-1:0] elapsed_time;

	// SSD:
	logic [$clog2(10000)-1:0] display_value;
	logic [6:0] ssd_digits [3:0];
	
	// MODULE INSTANTIATIONS
	random_number_generator my_rng(clk, rst, state == S0, delay);
	stopwatch my_stopwatch(clk, rst, stopwatch_en, elapsed_time);
	binary_to_ssd my_b2ssd(display_value, ssd_digits);
	basys_ssd my_ssd(clk, rst, ssd_digits, an, seg);
	clock_divider #(500000) my_clock_divider(clk, rst, my_clk);	// New clock divider for the delay counter to achieve usable delays
	
	// SEQUENTIAL LOGIC
	// Start/stop button edge detection:
	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin
			start_btn_d <= 0;
			start_pulse <= 0;
		end 
		else begin
			start_pulse <= start_stop_btn & ~start_btn_d;
			start_btn_d <= start_stop_btn;
		end
	end
	
	// Delay counter:
	always_ff @(posedge my_clk, posedge rst) begin
		if (rst) begin
			delay_counter <= 0;
			delay_done <= 0;
		end
		else if (state == S1) begin
			if (delay_counter >= delay)
				delay_done <= 1;
			else begin
				delay_counter <= delay_counter + 1;
				delay_done <= 0;
			end
		end
		else begin
			delay_counter <= 0;
			delay_done <= 0;
		end
	end
	
	// FSM state register:
	always_ff @(posedge clk, posedge rst)
		if (rst) state <= S0;
		else state <= nextstate;
	
	// COMBINATIONAL LOGIC
	// Next state logic:
	always_comb begin
		nextstate = state;
		stopwatch_en = 0;
		led = 0;
	
		case(state)
			S0:	begin	// RESET
				if (start_pulse) nextstate = S1;
				else nextstate = S0;
			end
			S1: begin 	// SET
				if (delay_done) nextstate = S2;
				else nextstate = S1;
			end
			S2:	begin	// GO
				stopwatch_en = 1;	// Begin timer
				led = 1;	// Turn on indicator
				if (start_pulse)
					nextstate = S3;
				else nextstate = S2;
			end
			S3:	begin	// SCORE
				// Hold until main reset
			end
		endcase
	end

	// Output logic
	always_comb begin		
		if (state == S2 || state == S3)
			display_value = elapsed_time;
		else
			display_value = 0;
	end
	
endmodule