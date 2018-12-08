module audioTop (CLOCK_50, CLOCK2_50, SW, KEY, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, GPIO_0,
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT, LEDR);

	input logic CLOCK_50, CLOCK2_50;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	output logic [9:0] LEDR;
	output logic [35:0] GPIO_0;
	// I2C Audio/Video config interface
	output logic FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output logic AUD_XCK;
	input logic AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input logic AUD_ADCDAT;
	output logic AUD_DACDAT;
	
	// Local logics.
	logic read_ready, write_ready, read, write, writeMem, readMem, speedUpRecording, slowDownRecording;
	logic [23:0] readdata_left, readdata_right;
	logic [23:0] writedata_left, writedata_right;
	logic reset;
	assign reset = ~KEY[0];
	logic reverse;
	assign reverse = SW[0];

	assign read = read_ready;
	assign write = write_ready;
	
	signalCutter key1cut (.in(~KEY[1]), .reset(SW[9]), .clk(CLOCK_50), .out(speedUpRecording));
	signalCutter key2cut (.in(~KEY[2]), .reset(SW[9]), .clk(CLOCK_50), .out(slowDownRecording));
	
	// filtered data, noise reduction:
	//avgfilter avgL (.clk(CLOCK_50), .in(readdata_left), .read_ready(read_ready), .write_ready(write_ready), .out(writedata_left));
	//avgfilter avgR (.clk(CLOCK_50), .in(readdata_right), .read_ready(read_ready), .write_ready(write_ready), .out(writedata_right));

	// constraints for sample rates
	logic [23:0] initSamplePeriod, maxSamplePeriod, minSamplePeriod, samplePeriod;
	assign initSamplePeriod = 24'd400;
	assign maxSamplePeriod = initSamplePeriod << 4;
	assign minSamplePeriod = initSamplePeriod >> 2;
	
	// speeding up the recording corresponds to decreasing the period of the sampling clock signal
	modPeriod mp (.in(initSamplePeriod), .max(maxSamplePeriod), .min(minSamplePeriod), .increase(slowDownRecording), .decrease(speedUpRecording), .clk(CLOCK_50), .reset(SW[9]), .out(samplePeriod), .LEDR(LEDR));
	
	// clock for read & write signals @ a slower frequency than CLOCK_50 --> so that we can sample audio over a longer stretch of time
	logic rwClk;
	getNewClock newClk (.CLOCK_50(CLOCK_50), .reset(SW[9] | slowDownRecording | speedUpRecording), .period(samplePeriod), .newClock(rwClk));

	// write and read are same input source, keep track of which mode we are in
	trackMemSignals tracker (.signalIn(~KEY[3]), .clk(CLOCK_50), .reset(SW[9]), .write(writeMem), .read(readMem));
	
	assign GPIO_0[0] = readMem;
	assign GPIO_0[1] = writeMem;

	audioLooper loopLeft (.in(readdata_left), .clk(CLOCK_50), .reset(SW[9]), .rwClk(rwClk), .write(writeMem), .read(readMem), .reverse(reverse), .out(writedata_left));
	audioLooper loopRight (.in(readdata_right), .clk(CLOCK_50), .reset(SW[9]), .rwClk(rwClk), .write(writeMem), .read(readMem), .reverse(reverse), .out(writedata_right));
	
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following logics:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule




