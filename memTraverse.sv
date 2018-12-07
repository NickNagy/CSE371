/* assumes you can't write when reverse is true
assumes write will have been true before read is ever true 

THIS MODULE IS A MESS!!! I made it under a time constraint and I intend to improve upon it later

*/
module memTraverse #(parameter ADDR_WIDTH = 6) (clk, reset, read, write, reverse, full, cycle, loopExists, currAddr);
	input logic clk, reset, reverse, read, write;
	output logic full, loopExists, cycle;
	output logic [ADDR_WIDTH-1:0] currAddr;
	
	logic [ADDR_WIDTH-1:0] minRec, maxRec, nextMin, nextMax, nextAddr;
	logic firstWriteDone; // logic only works if assume that read always happens after a write has occurred
	
	assign loopExists = (minRec != maxRec);
	
	always_comb begin
		if (loopExists)
			cycle = (currAddr == minRec);
		else
			cycle = (currAddr == 0);
	end
	
	// may be able to change now that we have firstWriteDone
	always_comb begin
		if (reset)
			nextMax = 0;
		else if (write & ~firstWriteDone) begin
			if (maxRec == 2**ADDR_WIDTH-1)
				nextMax = 0;
			else
				nextMax = maxRec + 1'b1;
		end else if (~loopExists)
			nextMax = nextAddr;
		else
			nextMax = maxRec;
	end
	
	always_comb begin
		if (reset)
			nextMin = 0;
		else if (~(read|write) | (read & ~loopExists))
			nextMin = nextAddr;
		else
			nextMin = minRec;
	end
	
	// 
	always_comb begin
		if (reset)
			nextAddr = 0;
		else if (write) begin
			// if data was already written, should restrict self to minRec & maxRec
			if (firstWriteDone) begin
				if (currAddr == maxRec)
					nextAddr = minRec;
				else
					nextAddr = currAddr + 1'b1;
			// otherwise should move thru entire memory block
			end else begin
				if (currAddr == 2**ADDR_WIDTH-1)
					nextAddr = 0;
				else
					nextAddr = currAddr + 1'b1;
			end
		end else if (read) begin
			if (reverse) begin
				if (currAddr == minRec)
					nextAddr = maxRec;
				else
					nextAddr = currAddr - 1'b1;
			end else begin
				if (currAddr == maxRec)
					nextAddr = minRec;
				else
					nextAddr = currAddr + 1'b1;
			end
		end else if (loopExists) begin
			if (reverse) begin
				if (currAddr == minRec)
					nextAddr = maxRec;
				else
					nextAddr = currAddr - 1'b1;
			end else begin
				if (currAddr == maxRec)
					nextAddr = minRec;
				else
					nextAddr = currAddr + 1'b1;
			end
		end else begin
			if (reverse) begin
				if (currAddr == 0)
					nextAddr = 2**ADDR_WIDTH-1;
				else
					nextAddr = currAddr - 1'b1;
			end else begin
				if (currAddr == 2**ADDR_WIDTH-1)
					nextAddr = 0;
				else
					nextAddr = currAddr + 1'b1;
			end
		end
	end
	
	always_ff @(posedge clk) begin
		currAddr <= nextAddr;
		minRec <= nextMin;
		maxRec <= nextMax;
		if (reset) begin
			full <= 0;
			firstWriteDone <= 0;
		//	loopExists <= 0;
		end else begin
			if (read & ~firstWriteDone)
				firstWriteDone <= 1;
			if (~full & loopExists & (minRec == maxRec))
				full <= 1;
//			if (~loopExists & ~(maxRec == minRec))
//				loopExists <= 1;
		end
	end
endmodule

module memTraverse_testbench();
	logic clk, reset, read, reverse, write, cycle, loopExists, full;
	
	parameter ADDR_WIDTH = 3;
	parameter CLOCK_PERIOD = 100;
	
	logic [ADDR_WIDTH-1:0] currAddr;
	
	memTraverse #(ADDR_WIDTH) dut (.clk, .reset, .reverse, .read, .write, .full, .cycle, .loopExists, .currAddr);
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// logic is drastically simplified if we can make this assumption!
	assert property (@(posedge clk) ~(reverse & write));
	assert property (@(posedge clk) ~(read & ~loopExists));
	
	initial begin
		reset <= 1; read <= 0; write <= 0; reverse <= 0; @(posedge clk);
		// test idle with no loop
		reset <= 0;
		for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
			@(posedge clk);
		end
		// test read before write
//		read <= 1;
//		for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
//			@(posedge clk);
//		end
		// test write (not full)
		read <= 0; write <= 1;
		for (int i = 0; i < ADDR_WIDTH; i++) begin
			@(posedge clk);
		end
		// test read (not full)
		write <= 0; read <= 1;
		for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
			@(posedge clk);
		end
		// test write beyond full
		write <= 1; read <= 0;
		for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
			@(posedge clk);
		end
		// test read when full
//		for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
//			@(posedge clk);
//		end
//		reset <= 1; read <= 0; @(posedge clk);
		// test write and read when reverse is true
		reset <= 0; reverse <= 1; read <= 1;
		@(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk);
//		write <= 0; read <= 1; @(posedge clk); @(posedge clk);
		$stop;
	end
endmodule
