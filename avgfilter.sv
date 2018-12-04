module avgfilter(clk, in, out);
	input logic clk;
	input logic [23:0] in;
	output logic [23:0] out;
	
	logic signed [23:0] q0, q1, q2, q3, q4, q5, q6, res0, res1, res2, res3, res4, res5, in_signed, in_divided;
	
	assign in_signed = in;
	
	always_ff @(posedge clk) begin
		q0 <= in;
		q1 <= q0;
		q2 <= q1;
		q3 <= q2;
		q4 <= q3;
		q5 <= q4;
		q6 <= q5;
	end
	
	always_comb begin
		if (in[23])
			in_divided = in_signed>>>3;
		else
			in_divided = in_signed>>3;
		if (q0[23])
			res0 = in_divided + (q0>>>3);
		else
			res0 = in_divided + (q0>>3);
		if (q1[23])
			res1 = res0 + (q1>>>3);
		else
			res1 = res0 + (q1>>3);
		if (q2[23])
			res2 = res1 + (q2>>>3);
		else
			res2 = res1 + (q2>>3);
		if (q3[23])
			res3 = res2 + (q3>>>3);
		else
			res3 = res2 + (q3>>3);
		if (q4[23])
			res4 = res3 + (q4>>>3);
		else
			res4 = res3 + (q4>>3);
		if (q5[23])
			res5 = res4 + (q5>>>3);
		else
			res5 = res4 + (q5>>3);
		if (q6[23])
			out = res5 + (q6>>>3);
		else
			out = res5 + (q6>>3);
	end

endmodule

module avgfilter_testbench();
	logic clk;
	logic [23:0] in, out;
	
	avgfilter dut (.clk, .in, .out);
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		in <= 24'd1; @(posedge clk);
		in <= 24'd2; @(posedge clk);
		in <= 24'd3; @(posedge clk);
		in <= 24'd4; @(posedge clk);
		in <= 24'd5; @(posedge clk);
		in <= 24'd6; @(posedge clk);
		in <= 24'd7; @(posedge clk);
		in <= 24'd8; @(posedge clk);
		in <= 24'd9; @(posedge clk);
		in <= 24'd10; @(posedge clk);
		in <= 24'd20; @(posedge clk);
		in <= 24'd50; @(posedge clk);
		in <= 24'd20; @(posedge clk);
		in <= 24'd0; @(posedge clk);
		in <= 24'b111111111111111111111111; @(posedge clk);
		in <= 24'd0; @(posedge clk);
		in <= 24'b100000000000000001111111; @(posedge clk);
		@(posedge clk);
		$stop;
	end
	
endmodule
