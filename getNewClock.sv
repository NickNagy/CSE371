module getNewClock (reset, period, CLOCK_50, newClock);
	input logic reset, CLOCK_50;
	input logic [23:0] period;
	output logic newClock;
	
	logic [23:0] counter;
	logic halfPeriod;
	
	assign halfPeriod = (counter == (period>>1));

	always_ff @(posedge CLOCK_50) begin
		if (reset) begin
			counter <= 24'd0;
			newClock <= 0;
		end else begin
			if (halfPeriod) begin
				counter <= 24'd0;
				newClock <= ~newClock;
			end else
				counter <= counter + 1'b1;
		end
	end
	
endmodule 

module getNewClock_testbench();
	logic reset, CLOCK_50, newClock;
	logic [23:0] period;
	
	assign period = 24'd382;
	
	getNewClock dut (.reset, .period, .CLOCK_50, .newClock);
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
		reset <= 1; @(posedge CLOCK_50);
		reset <= 0;
		for (int i = 0; i < 3*CLOCK_PERIOD; i++) begin
			@(posedge CLOCK_50);
		end
		$stop;
	end
endmodule
