/* 
This is a version of audioLooper.sv that can theoretically perform much more impressive features.
However, I ran out of time to debug when this project was originally assigned.

Instantiates memTraverse.sv
*/
`timescale 1ps/1ps
module audioLooper #(parameter ADDR_WIDTH = 15) (clk, rwClk, reset, in, write, read, reverse, cycle, out);
	input logic clk, rwClk, reset, write, read, reverse;
	input logic [23:0] in;
	output logic [23:0] out;
	output logic cycle;
	
	logic loopExists;
	logic [ADDR_WIDTH-1:0] loopAddr, nextLoopAddr, loopMax, nextLoopMax;
	
	logic rwSignal;
	
	signalCutter cutter (.in(rwClk), .reset, .clk, .out(rwSignal));
	
	logic [23:0] loopMem [0:2**ADDR_WIDTH-1];
	
	logic full, firstWriteDone; // don't know if we really need this
	memTraverse #(ADDR_WIDTH) mT (.clk(rwClk), .reset, .read, .write(write & ~reverse), .reverse, .full, .firstWriteDone, .loopExists, .cycle, .currAddr(loopAddr));
	
	/* to go back to setup from before, 
	uncomment the comb and seq below, 
	get rid of cycle output 
	undo the + in and + loopMem stuff
	undo the ~reverse in the seq
	and comment out memTravers above */
	
	// update max index of memory for loop
//	always_comb begin
//		if (reset)
//			nextLoopMax = 0;
//		else if (write & (loopAddr > loopMax))
//			nextLoopMax = loopAddr;
//		else
//			nextLoopMax = loopMax;
//	end
	
	// iterate through memory addresses while reading
//	always_comb begin
//		if (reset)
//			nextLoopAddr = 0;
//		else if (write) begin
//			if (loopAddr == 2**ADDR_WIDTH-1)
//				nextLoopAddr = 0;
//			else
//				nextLoopAddr = loopAddr + 1'b1;
//		end else if (read) begin
//			if (reverse) begin
//				if (loopAddr == 0)
//					nextLoopAddr = loopMax;
//				else
//					nextLoopAddr = loopAddr - 1'b1;
//			end else begin
//				if (loopAddr >= loopMax)
//					nextLoopAddr = 0;
//				else
//					nextLoopAddr = loopAddr + 1'b1;
//			end
//		end else
//			nextLoopAddr = loopAddr;
//	end

	// sometimes mem address is off immediately after switching to read
	// gives delay before correct memory output
	logic signalReady, signalReadyNext;
	always_comb begin
		if (reset | (write & signalReady))
			signalReadyNext = 0;
		else if (read & rwSignal)
			signalReadyNext = 1;
		else
			signalReadyNext = signalReady;
	end
	
	//integer i;
	always_ff @(posedge clk) begin
		signalReady <= signalReadyNext;
//		if (reset) begin
//			loopAddr <= 0;
//			loopMax <= 0;
//			loopExists <= 0;
//		end else begin
//			if (read & loopExists & rwSignal) begin
//				loopAddr <= nextLoopAddr;
//			end else if (write) begin
//				loopExists <= 1;
		if (write & ~reverse) begin
			loopMem[loopAddr] <= in + loopMem[loopAddr]; // change if fails
		end
	end

//	always_ff @(posedge rwClk) begin
//		if (write & ~reverse) begin
//			if (firstWriteDone)
//				loopMem[loopAddr] <= in + loopMem[loopAddr];
//			else
//				loopMem[loopAddr] <= in;
//		end
//	end
	
	always_comb begin
		if (reset)
			out = 23'b0;
		else if (read & loopExists & signalReady) // add back in "read" if fails
			out = in + loopMem[loopAddr]; // change if fails
		else
			out = in;
	end
	
endmodule

module audioLooper_testbench();
	logic clk, rwClk, reset, cycle, write, read, reverse;
	logic [23:0] in, out;
	
	parameter ADDR_WIDTH = 3;
	parameter CLOCK_PERIOD = 100;
	
	audioLooper #(ADDR_WIDTH) dut (.in, .clk, .rwClk, .reset, .write, .read, .reverse, .cycle, .out);
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		rwClk <= 0;
		forever #(3*CLOCK_PERIOD/2) rwClk <= ~rwClk;
	end
	
	initial begin
		in <= 24'b0;
		forever @(posedge clk) in <= in + 1'b1;
	end
	
	assert property (@(posedge clk) ~(read&write));
	//assert property (@(posedge clk) ~(read & ~loopExists));
	assert property (@(posedge clk) ~(write & reverse));
	
	initial begin
		reset <= 1; write <= 0; read <= 0; reverse <= 0; @(posedge clk); @(posedge clk); @(posedge clk);
		reset <= 0; write <= 1; @(posedge clk);
		for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
			@(posedge clk);
		end
		write <= 0; read <= 1; @(posedge clk);
		for (int i = 0; i < 2; i++) begin
			for (int j = 0; j < 2**ADDR_WIDTH; j++) begin
				@(posedge clk);
			end
			reverse <= ~reverse;
		end
		// copy pasted... checking logic now that first write was completed
		read <= 0; write <= 1; @(posedge clk);
		for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
			@(posedge clk);
		end
		write <= 0; read <= 1; @(posedge clk);
		for (int i = 0; i < 2; i++) begin
			for (int j = 0; j < 2**ADDR_WIDTH; j++) begin
				@(posedge clk);
			end
			reverse <= ~reverse;
		end
		$stop;
	end
endmodule
