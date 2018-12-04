module signalCutter (in, reset, clk, out);
	input logic in, clk, reset;
	output logic out;
	
	logic temp;
	
	always_ff @(posedge clk) begin
		if (reset) begin
			temp <= 0;
		end else begin
			temp <= in;
		end
	end
	
	assign out = in & ~temp;
	
endmodule

module signalCutter_testbench();
	logic in, clk, reset, out;
	
	signalCutter dut (.in, .reset, .clk, .out);
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; in <= 1; @(posedge clk); @(posedge clk); @(posedge clk);
		in <= 0; @(posedge clk); @(posedge clk); @(posedge clk);
		$stop;
	end
	
endmodule