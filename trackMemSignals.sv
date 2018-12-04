module trackMemSignals (signalIn, clk, reset, write, read);
	input logic signalIn, clk, reset;
	output logic write, read;
	
	logic signal;
	logic [1:0] state, nextState;
	
	signalCutter cutter (.in(signalIn), .clk, .reset, .out(signal));
	
	
	always_comb begin
		if (signal) begin
			if (state == 2'b10)
				nextState = 2'b01;
			else
				nextState = state + 1'b1;
		end else
			nextState = state;
	end
	
	always_ff @(posedge clk) begin
		if (reset)
			state <= 2'b00;
		else
			state <= nextState;
	end
	
	assign write = (state == 2'b01);
	assign read = (state == 2'b10); 
endmodule 

module trackMemSignals_testbench();
	logic signalIn, clk, reset, write, read;
	
	trackMemSignals dut (.signalIn, .clk, .reset, .write, .read);
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; signalIn <= 0; @(posedge clk);
		reset <= 0; @(posedge clk);
		signalIn <= 1; @(posedge clk); // write
		signalIn <= 0; @(posedge clk); @(posedge clk);
		signalIn <= 1; @(posedge clk); // read
		signalIn <= 0; @(posedge clk); @(posedge clk);
		signalIn <= 1; @(posedge clk); @(posedge clk); @(posedge clk); // write and also hopefully only for one cycle
		$stop;
	end
endmodule