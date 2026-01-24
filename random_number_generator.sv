module random_number_generator(input logic clk,
								input logic rst,	// Active high, resets LFSR to a non-zero seed
								input logic generate_num,	// When high, generate the next number
								output logic [7:0] random_number);

	// Fibonacci Linear Feedback Shift Register (LFSR):	
	always_ff @(posedge clk, posedge rst)
		if (rst) 
			random_number <= 'd100;	// Non-zero seed
		else if (generate_num)
			// bit[7] XOR bit[5] XOR bit[4] XOR bit[3]
			random_number <= {random_number[6:0], random_number[7] ^ random_number[5] ^ random_number[4] ^ random_number[3]};
endmodule