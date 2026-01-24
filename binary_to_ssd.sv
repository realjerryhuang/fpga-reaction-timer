module binary_to_ssd(input logic [$clog2(10000)-1:0] binary_in,	// Up to 9,999
					output logic [6:0] display_out [3:0]	// 4 arrays of 7 bits
);

	logic [3:0] decimal_in_0, decimal_in_1, decimal_in_2, decimal_in_3;
	logic [6:0] display_bits_0, display_bits_1, display_bits_2, display_bits_3;
	
	// Convert binary numbers into decimal digits
	always_comb begin
		decimal_in_0 = binary_in % 10;
		decimal_in_1 = (binary_in/10) % 10;
		decimal_in_2 = (binary_in/100) % 10;
		decimal_in_3 = (binary_in/1000) % 10;
	end
	
	// Instantiate SSDs
	seven_segment_digit ssd_0(decimal_in_0, display_bits_0);
	seven_segment_digit ssd_1(decimal_in_1, display_bits_1);
	seven_segment_digit ssd_2(decimal_in_2, display_bits_2);
	seven_segment_digit ssd_3(decimal_in_3, display_bits_3);
	
	always_comb begin
		display_out[0] = display_bits_0;		// Digit 0
		display_out[1] = display_bits_1;		// Digit 1
		display_out[2] = display_bits_2;		// Digit 2
		display_out[3] = display_bits_3;		// Digit 3
	end
endmodule
