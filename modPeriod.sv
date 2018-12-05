module modPeriod(in, reset, clk, max, min, decrease, increase, out);
	input logic [23:0] in, max, min;
	input logic clk, reset, decrease, increase;
	output logic [23:0] out;
		
	logic [23:0] temp;	
	
	always_comb begin
		if (increase & ((out << 1) <= max))
			temp = out << 1;
		else if (decrease & ((out >> 1) >= min))
			temp = out >> 1;
		else
			temp = out;
	end
	
	always_ff @(posedge clk) begin
		if (reset)
			out <= in;
		else
			out <= temp;
	end

endmodule

module modPeriod_testbench();

endmodule 
