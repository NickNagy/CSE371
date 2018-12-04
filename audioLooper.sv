`timescale 1ps/1ps
module audioLooper #(parameter ADDR_WIDTH = 16) (clk, reset, in, write, read, reverse, out);
	input logic clk, reset, write, read, reverse;
	input logic [23:0] in;
	output logic [23:0] out;
	
	logic loopExists, rwClock;
	logic [ADDR_WIDTH-1:0] loopAddr, nextLoopAddr, loopMax, nextLoopMax;
	logic [23:0] memOut;
	
	logic rwSignal;
	getNewClock newClk (.CLOCK50(clk), .reset, .frequency(24'd400), .newClock(rwClock));
	
	signalCutter cutter (.in(rwClock), .reset, .clk, .out(rwSignal));
	
	
	logic [23:0] loopMem [0:2**ADDR_WIDTH-1];
	
	always_comb begin
		if (reset)
			nextLoopMax = 0;
		else if (write & (loopAddr > loopMax))
			nextLoopMax = loopAddr;
		else
			nextLoopMax = loopMax;
	end
	
	// iterate through memory addresses while reading
	always_comb begin
		if (reset)
			nextLoopAddr = 0;
		else if (write) begin
			if (loopAddr == 2**ADDR_WIDTH-1)
				nextLoopAddr = 0;
			else
				nextLoopAddr = loopAddr + 1'b1;
		end else if (read) begin
			if (reverse) begin
				if (loopAddr == 0)
					nextLoopAddr = loopMax;
				else
					nextLoopAddr = loopAddr - 1'b1;
			end else begin
				if (loopAddr >= loopMax)
					nextLoopAddr = 0;
				else
					nextLoopAddr = loopAddr + 1'b1;
			end
		end else
			nextLoopAddr = loopAddr;
	end

	always_ff @(posedge clk) begin
		if (reset) begin
			loopAddr <= 0;
			loopMax <= 0;
			loopExists <= 0;
		end else begin
			if (read & loopExists & rwSignal) begin
				memOut <= loopMem[loopAddr];
				loopAddr <= nextLoopAddr;
			end else if (write) begin
				loopExists <= 1;
				if (rwSignal) begin
					loopMem[loopAddr] <= in;
					loopMax <= nextLoopMax;
					loopAddr <= nextLoopAddr;
				end
			end
		end
	end
	
	always_comb begin
		if (reset)
			out = 23'b0;
		else if (read & loopExists)
			out = memOut[23:0];
		else
			out = in;
	end
	
	//assign out = temp;
endmodule

module audioLooper_testbench();
	logic [23:0] in, out;
	logic clk, reset, read, write, reverse;
	
	parameter CLOCK_PERIOD = 100;
	parameter ADDR_WIDTH = 4;
	
	audioLooper #(ADDR_WIDTH) dut (.in, .clk, .reset, .read, .write, .reverse, .out);
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		in <= 23'd0;
		forever #(CLOCK_PERIOD) in <= in + 1'b1;
	end
	
	// shouldn't both be true
	assert property (@(posedge clk) ~(read & write));
	
	// TESTING
	// what happens if I try to read before I've written?
	// what happens if I have read and write true at the same time?
	// what happens if I write for more addresses than in memory?
	initial begin
		reset <= 1; read <= 0; write <= 0; reverse <= 0; @(posedge clk); @(posedge clk); @(posedge clk);
		reset <= 0; read <= 1; @(posedge clk);
		@(posedge clk);
		reverse <= 1; @(posedge clk);
		@(posedge clk);
		read <= 0; write <= 1; @(posedge clk);
		// what happens when looping goes for longer than memory depth?
		for (int i = 0; i <= 50; i++) begin
			@(posedge clk);
		end
		//reset <= 1; @(posedge clk); // now check that proper region is looped
		//reset <= 0; @(posedge clk);
		@(posedge clk);
		@(posedge clk);
		write <= 0; read <= 1; reverse <= 0; @(posedge clk);
		for (int j = 0; j < 2; j++) begin
			for (int k = 0; k < 50; k++) begin
				@(posedge clk);
			end
			reverse <= ~reverse; @(posedge clk);
		end
		$stop;
	end
endmodule