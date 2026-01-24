module seven_segment_digit(input logic [3:0] digit,
							output logic [6:0] display_bits	// Active low
);
	always_comb
		case(digit)
			//						  	  abc_defg
			0:			display_bits = 7'b000_0001;
			1:			display_bits = 7'b100_1111;
			2:			display_bits = 7'b001_0010;
			3:			display_bits = 7'b000_0110;
			4:			display_bits = 7'b100_1100;
			5:			display_bits = 7'b010_0100;
			6:			display_bits = 7'b010_0000;
			7:			display_bits = 7'b000_1111;
			8:			display_bits = 7'b000_0000;
			9:			display_bits = 7'b000_1100;
			default:	display_bits = 7'b111_1111;
		endcase
endmodule