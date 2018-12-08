// note: this module is buggy :(
module modPeriod(in, reset, clk, max, min, decrease, increase, out, LEDR);
	input logic [23:0] in, max, min;
	input logic clk, reset, decrease, increase;
	output logic [9:0] LEDR;
	output logic [23:0] out;
		
	logic [23:0] temp;
	logic [9:0] nextLEDR;	
	
	always_comb begin
		if (increase & ((out << 1) <= max)) begin
			temp = out << 1;
			nextLEDR = LEDR << 1;
		end else if (decrease & ((out >> 1) >= min)) begin
			temp = (out >> 1);
			nextLEDR[8:0] = (LEDR >> 1);
			nextLEDR[9] = 1;
		end else begin
			temp = out;
			nextLEDR = LEDR;
		end
	end
	
	always_ff @(posedge clk) begin
		if (reset) begin
			out <= in;
			LEDR <= 10'b1111100000;
		end else begin
			out <= temp;
			LEDR <= nextLEDR;
		end
	end

endmodule

module modPeriod_testbench();

endmodule 
