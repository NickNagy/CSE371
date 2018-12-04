module getNewClock (reset, frequency, CLOCK50, newClock);
	input logic reset, CLOCK50;
	input logic [23:0] frequency;
	output logic newClock;
	
	logic [23:0] counter;
	logic halfPeriod;
	
	assign halfPeriod = (counter == (frequency>>1));
	
	always_ff @(posedge CLOCK50) begin
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
	logic reset, CLOCK50, newClock;
	logic [23:0] frequency;
	
	assign frequency = 24'd382;
	
	getNewClock dut (.reset, .frequency, .CLOCK50, .newClock);
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		CLOCK50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK50 <= ~CLOCK50;
	end
	
	initial begin
		reset <= 1; @(posedge CLOCK50);
		reset <= 0;
		for (int i = 0; i < 3*CLOCK_PERIOD; i++) begin
			@(posedge CLOCK50);
		end
		$stop;
	end
endmodule