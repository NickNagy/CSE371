//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

// Controls:
// KEY[2]: reset the system.
// KEY[3]: Run the autofocus system.
// SW[9]: Choose between full and central auto-focus, plus yellow rectangle.

module DE1_SOC_D8M_RTL(

	//////////// ADC //////////
	output		          		ADC_CONVST,
	output		          		ADC_DIN,
	input 		          		ADC_DOUT,
	output		          		ADC_SCLK,

	//////////// Audio //////////
	input 		          		AUD_ADCDAT,
	inout 		          		AUD_ADCLRCK,
	inout 		          		AUD_BCLK,
	output		          		AUD_DACDAT,
	inout 		          		AUD_DACLRCK,
	output		          		AUD_XCK,

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		    [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,

	//////////// I2C for Audio and Video-In //////////
	output		          		FPGA_I2C_SCLK,
	inout 		          		FPGA_I2C_SDAT,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// IR //////////
	input 		          		IRDA_RXD,
	output		          		IRDA_TXD,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// PS2 //////////
	inout 		          		PS2_CLK,
	inout 		          		PS2_CLK2,
	inout 		          		PS2_DAT,
	inout 		          		PS2_DAT2,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// Video-In //////////
	input 		          		TD_CLK27,
	input 		     [7:0]		TD_DATA,
	input 		          		TD_HS,
	output		          		TD_RESET_N,
	input 		          		TD_VS,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS,

	//////////// GPIO_1, GPIO_1 connect to D8M-GPIO //////////
	output 		          		CAMERA_I2C_SCL,
	inout 		          		CAMERA_I2C_SDA,
	output		          		CAMERA_PWDN_n,
	output		          		MIPI_CS_n,
	inout 		          		MIPI_I2C_SCL,
	inout 		          		MIPI_I2C_SDA,
	output		          		MIPI_MCLK,
	input 		          		MIPI_PIXEL_CLK,
	input 		     [9:0]		MIPI_PIXEL_D,
	input 		          		MIPI_PIXEL_HS,
	input 		          		MIPI_PIXEL_VS,
	output		          		MIPI_REFCLK,
	output		          		MIPI_RESET_n,
	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	inout 		    [35:0]		GPIO	
	
);

//=============================================================================
// Added code to insert Filter.sv into the output path
//=============================================================================
	// The signals from the system to the filter.
	logic 		          		pre_VGA_BLANK_N;
	logic 		     [7:0]		pre_VGA_B;
	logic 		     [7:0]		pre_VGA_G;
	logic 		          		pre_VGA_HS;
	logic 		     [7:0]		pre_VGA_R;
	logic 		          		pre_VGA_SYNC_N;
	logic 		          		pre_VGA_VS;
	// The signals from the filter to the VGA
	logic 		          		post_VGA_BLANK_N;
	logic 		     [7:0]		post_VGA_B;
	logic 		     [7:0]		post_VGA_G;
	logic 		          		post_VGA_HS;
	logic 		     [7:0]		post_VGA_R;
	logic 		          		post_VGA_SYNC_N;
	logic 		          		post_VGA_VS;
					
	Filter #(.WIDTH(640), .HEIGHT(480))
		filter (.VGA_CLK(VGA_CLK),
					.iVGA_B(pre_VGA_B), .iVGA_G(pre_VGA_G), .iVGA_R(pre_VGA_R),
					.iVGA_HS(pre_VGA_HS), .iVGA_VS(pre_VGA_VS),
					.iVGA_SYNC_N(pre_VGA_SYNC_N), .iVGA_BLANK_N(pre_VGA_BLANK_N),
					.oVGA_B(post_VGA_B), .oVGA_G(post_VGA_G), .oVGA_R(post_VGA_R),
					.oVGA_HS(post_VGA_HS), .oVGA_VS(post_VGA_VS),
					.oVGA_SYNC_N(post_VGA_SYNC_N), .oVGA_BLANK_N(post_VGA_BLANK_N),
					.HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
					.LEDR(KEDR), .KEY(KEY[1:0]), .SW(SW[8:0]));
					
	assign VGA_BLANK_N = post_VGA_BLANK_N;
	assign VGA_B = post_VGA_B + avg_write_data[23:16]
	;
	assign VGA_G = post_VGA_G + avg_write_data[23:16];
	assign VGA_HS = post_VGA_HS;
	assign VGA_R = post_VGA_R + avg_write_data[23:16];
	assign VGA_SYNC_N = post_VGA_SYNC_N;
	assign VGA_VS = post_VGA_VS;

//=============================================================================
// REG/logic  declarations
//=============================================================================


logic 	[15:0]SDRAM_RD_DATA;
logic 			DLY_RST_0;
logic 			DLY_RST_1;
logic 			DLY_RST_2;

logic 			SDRAM_CTRL_CLK;
logic         D8M_CK_HZ ; 
logic         D8M_CK_HZ2 ; 
logic         D8M_CK_HZ3 ; 

logic  [7:0] RED   ; 
logic  [7:0] GREEN  ; 
logic  [7:0] BLUE 		 ; 
logic  [12:0] VGA_H_CNT;			
logic  [12:0] VGA_V_CNT;	

logic         READ_Request ;
logic  	[7:0] B_AUTO;
logic  	[7:0] G_AUTO;
logic  	[7:0] R_AUTO;
logic         RESET_N  ; 

logic         I2C_RELEASE ;  
logic         AUTO_FOC ; 
logic         CAMERA_I2C_SCL_MIPI ; 
logic         CAMERA_I2C_SCL_AF;
logic         CAMERA_MIPI_RELAESE ;
logic         MIPI_BRIDGE_RELEASE ;  
 
logic         LUT_MIPI_PIXEL_HS;
logic         LUT_MIPI_PIXEL_VS;
logic  [9:0]  LUT_MIPI_PIXEL_D  ;
logic         MIPI_PIXEL_CLK_; 
logic  [9:0]  PCK;



//=======================================================
// Structural coding
//=======================================================
//--INPU MIPI-PIXEL-CLOCK DELAY
CLOCK_DELAY  del1(  .iCLK (MIPI_PIXEL_CLK),  .oCLK (MIPI_PIXEL_CLK_ ) );


assign LUT_MIPI_PIXEL_HS=MIPI_PIXEL_HS;
assign LUT_MIPI_PIXEL_VS=MIPI_PIXEL_VS;
assign LUT_MIPI_PIXEL_D =MIPI_PIXEL_D ;

//------UART OFF --
assign UART_RTS =0; 
assign UART_TXD =0; 
//------HEX OFF --
//assign HEX2           = 7'h7F;
//assign HEX3           = 7'h7F;
//assign HEX4           = 7'h7F;
//assign HEX5           = 7'h7F;



//------ MIPI BRIGE & CAMERA RESET  --
assign CAMERA_PWDN_n  = 1; 
assign MIPI_CS_n      = 0; 
assign MIPI_RESET_n   = RESET_N ;

//------ CAMERA MODULE I2C SWITCH  --
assign I2C_RELEASE    = CAMERA_MIPI_RELAESE & MIPI_BRIDGE_RELEASE; 
assign CAMERA_I2C_SCL =( I2C_RELEASE  )?  CAMERA_I2C_SCL_AF  : CAMERA_I2C_SCL_MIPI ;   


/*
The code below was originally contained in top.sv. However, as the project grew it became more difficult to constantly modify inputs
and outputs between heirarchies of modules.

For the sake of time constraints, the bulk of top.sv was copied into this module. The instantiation of top.sv has been commented out.
*/
//top aud (.CLOCK_50, .CLOCK2_50, .SW, .KEY, .FPGA_I2C_SCLK, .FPGA_I2C_SDAT, .AUD_XCK, .GPIO_0(GPIO), .AUD_DACLRCK, .AUD_ADCLRCK, .AUD_BCLK, .AUD_ADCDAT, .AUD_DACDAT, .LEDR);

logic button_left, button_right, button_middle;
// bin_x and bin_y
ps2 mouse (.start(SW[8]), .reset(SW[9]), .CLOCK_50, .PS2_CLK, .PS2_DAT, .button_left, .button_right, .button_middle); //, .bin_x, .bin_y);

assign GPIO[0] = readMem;
assign GPIO[1] = writeMem;

logic speedUpRecording, slowDownRecording;

logic [23:0] initSamplePeriod, maxSamplePeriod, minSamplePeriod, samplePeriod;
assign initSamplePeriod = 24'd500;
assign maxSamplePeriod = initSamplePeriod << 4;
assign minSamplePeriod = initSamplePeriod >> 2;

// speeding up the recording corresponds to decreasing the period of the sampling clock signal
modPeriod mp (.in(initSamplePeriod), .max(maxSamplePeriod), .min(minSamplePeriod), .increase(slowDownRecording), .decrease(speedUpRecording), .clk(CLOCK_50), .reset(SW[9]), .out(samplePeriod), .LEDR(LEDR[9:1]));

signalCutter key1cut (.in(button_right), .reset(SW[9]), .clk(CLOCK_50), .out(speedUpRecording));
signalCutter key2cut (.in(button_left), .reset(SW[9]), .clk(CLOCK_50), .out(slowDownRecording));

logic rwClk;
getNewClock newClk (.CLOCK_50, .reset(SW[9] | slowDownRecording | speedUpRecording), .period(samplePeriod), .newClock(rwClk));

logic writeMem, readMem;
trackMemSignals tracker (.signalIn(button_middle), .clk(CLOCK_50), .reset(SW[9]), .write(writeMem), .read(readMem));

logic [23:0] avg_write_data;

logic  read_ready, write_ready, read, write;
logic  [23:0] readdata_left, readdata_right;
logic  [23:0] writedata_left, writedata_right;

assign avg_write_data = (writedata_left + writedata_right) >> 1;

logic reset;
assign  reset = ~KEY[0];
logic reverse;
assign reverse = SW[0];

assign read = read_ready;
assign write = write_ready;

logic cycleLeft, cycleRight;
audioLooper loopLeft (.in(readdata_left), .clk(CLOCK_50), .reset(SW[9]), .write(writeMem), .read(readMem), .rwClk(rwClk), .reverse(reverse), .cycle(cycleLeft), .out(writedata_left));
audioLooper loopRight (.in(readdata_right), .clk(CLOCK_50), .reset(SW[9]), .write(writeMem), .read(readMem), .rwClk(rwClk), .reverse(reverse), .cycle(cycleRight), .out(writedata_right)); 

assign LEDR[0] = cycleLeft & cycleRight;	
	
// TODO: testbench

endmodule
 
//----- RESET RELAY  --		
RESET_DELAY			u2	(	
							.iRST  ( KEY[2] ),
                     .iCLK  ( CLOCK2_50 ),
							.oRST_0( DLY_RST_0 ),
							.oRST_1( DLY_RST_1 ),
							.oRST_2( DLY_RST_2 ),					
						   .oREADY( RESET_N)  
							
						);
 
//------ MIPI BRIGE & CAMERA SETTING  --  
MIPI_BRIDGE_CAMERA_Config    cfin(
                      .RESET_N           ( RESET_N ), 
                      .CLK_50            ( CLOCK2_50 ), 
                      .MIPI_I2C_SCL      ( MIPI_I2C_SCL ), 
                      .MIPI_I2C_SDA      ( MIPI_I2C_SDA ), 
                      .MIPI_I2C_RELEASE  ( MIPI_BRIDGE_RELEASE ),  
                      .CAMERA_I2C_SCL    ( CAMERA_I2C_SCL_MIPI ),
                      .CAMERA_I2C_SDA    ( CAMERA_I2C_SDA ),
                      .CAMERA_I2C_RELAESE( CAMERA_MIPI_RELAESE )
             );
				 
//------MIPI / VGA REF CLOCK  --
pll_test pll_ref(
	                   .inclk0 ( CLOCK3_50 ),
	                   .areset ( ~KEY[2]   ),
	                   .c0( MIPI_REFCLK    ) //20Mhz

    );
	 
//------MIPI / VGA REF CLOCK  -
VIDEO_PLL pll_ref1(
	                   .inclk0 ( CLOCK2_50 ),
	                   .areset ( ~KEY[2] ),
	                   .c0( VGA_CLK )        //25 Mhz	
    );	 
//------SDRAM CLOCK GENNERATER  --
sdram_pll u6(
		               .areset( 0 ) ,     
		               .inclk0( CLOCK_50 ),              
		               .c1    ( DRAM_CLK ),       //100MHZ   -90 degree
		               .c0    ( SDRAM_CTRL_CLK )  //100MHZ     0 degree 							
		              
	               );		
						
//------SDRAM CONTROLLER --
Sdram_Control	   u7	(	//	HOST Side						
						   .RESET_N     ( KEY[2] ),
							.CLK         ( SDRAM_CTRL_CLK ) , 
							//	FIFO Write Side 1
							.WR1_DATA    ( LUT_MIPI_PIXEL_D[9:0] ),
							.WR1         ( LUT_MIPI_PIXEL_HS & LUT_MIPI_PIXEL_VS ) ,
							
							.WR1_ADDR    ( 0 ),
                     .WR1_MAX_ADDR( 640*480 ),
						   .WR1_LENGTH  ( 256 ) , 
		               .WR1_LOAD    ( !DLY_RST_0 ),
							.WR1_CLK     ( MIPI_PIXEL_CLK_),

                     //	FIFO Read Side 1
						   .RD1_DATA    ( SDRAM_RD_DATA[9:0] ),
				        	.RD1         ( READ_Request ),
				        	.RD1_ADDR    (0 ),
                     .RD1_MAX_ADDR( 640*480 ),
							.RD1_LENGTH  ( 256  ),
							.RD1_LOAD    ( !DLY_RST_1 ),
							.RD1_CLK     ( VGA_CLK ),
											
							//	SDRAM Side
						   .SA          ( DRAM_ADDR ),
							.BA          ( DRAM_BA ),
							.CS_N        ( DRAM_CS_N ),
							.CKE         ( DRAM_CKE ),
							.RAS_N       ( DRAM_RAS_N ),
							.CAS_N       ( DRAM_CAS_N ),
							.WE_N        ( DRAM_WE_N ),
							.DQ          ( DRAM_DQ ),
							.DQM         ( DRAM_DQM  )
						   );	 	 
	 
//------ CMOS CCD_DATA TO RGB_DATA -- 

RAW2RGB_J				u4	(	
							.RST          ( pre_VGA_VS ),
							.iDATA        ( SDRAM_RD_DATA[9:0] ),

							//-----------------------------------
                     .VGA_CLK      ( VGA_CLK ),
                     .READ_Request ( READ_Request ),
                     .VGA_VS       ( pre_VGA_VS ),	
							.VGA_HS       ( pre_VGA_HS ), 
	                  			
							.oRed         ( RED  ),
							.oGreen       ( GREEN),
							.oBlue        ( BLUE )


							);		 
//------AOTO FOCUS ENABLE  --
AUTO_FOCUS_ON  vd( 
                      .CLK_50      ( CLOCK2_50 ), 
                      .I2C_RELEASE ( I2C_RELEASE ), 
                      .AUTO_FOC    ( AUTO_FOC )
               ) ;
					

//------AOTO FOCUS ADJ  --
FOCUS_ADJ adl(
                      .CLK_50        ( CLOCK2_50 ) , 
                      .RESET_N       ( I2C_RELEASE ), 
                      .RESET_SUB_N   ( I2C_RELEASE ), 
                      .AUTO_FOC      ( KEY[3] & AUTO_FOC ), 
                      .SW_Y          ( 0 ),
                      .SW_H_FREQ     ( 0 ),   
                      .SW_FUC_LINE   ( SW[9] ),   
                      .SW_FUC_ALL_CEN( SW[9] ),
                      .VIDEO_HS      ( pre_VGA_HS ),
                      .VIDEO_VS      ( pre_VGA_VS ),
                      .VIDEO_CLK     ( VGA_CLK ),
		                .VIDEO_DE      (READ_Request) ,
                      .iR            ( R_AUTO ), 
                      .iG            ( G_AUTO ), 
                      .iB            ( B_AUTO ), 
                      .oR            ( pre_VGA_R ) , 
                      .oG            ( pre_VGA_G ) , 
                      .oB            ( pre_VGA_B ) , 
                      
                      .READY         ( READY ),
                      .SCL           ( CAMERA_I2C_SCL_AF ), 
                      .SDA           ( CAMERA_I2C_SDA )
);

//------VGA Controller  --

VGA_Controller		u1	(	//	Host Side
							 .oRequest( READ_Request ),
							 .iRed    ( RED    ),
							 .iGreen  ( GREEN  ),
							 .iBlue   ( BLUE   ),
							 
							 //	VGA Side
							 .oVGA_R  ( R_AUTO[7:0] ),
							 .oVGA_G  ( G_AUTO[7:0] ),
							 .oVGA_B  ( B_AUTO[7:0] ),
							 .oVGA_H_SYNC( pre_VGA_HS ),
							 .oVGA_V_SYNC( pre_VGA_VS ),
							 .oVGA_SYNC  ( pre_VGA_SYNC_N ),
							 .oVGA_BLANK ( pre_VGA_BLANK_N ),
							 //	Control Signal
							 .iCLK       ( VGA_CLK ),
							 .iRST_N     ( DLY_RST_2 ),
							 .H_Cont     ( VGA_H_CNT ),						
						    .V_Cont     ( VGA_V_CNT )								
		);	


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
//------VS FREQUENCY TEST = 60HZ --
							
//FpsMonitor uFps( 
//	   .clk50    ( CLOCK2_50 ),
//	   .vs       ( LUT_MIPI_PIXEL_VS ),
//	
//	   .fps      (),
//	   .hex_fps_h( HEX1 ),
//	   .hex_fps_l( HEX0 )
//);


//--LED DISPLAY--
CLOCKMEM  ck1 ( .CLK(VGA_CLK )   ,.CLK_FREQ  (25000000  ) , . CK_1HZ (D8M_CK_HZ   )  )        ;//25MHZ
CLOCKMEM  ck2 ( .CLK(MIPI_REFCLK   )   ,.CLK_FREQ  (20000000   ) , . CK_1HZ (D8M_CK_HZ2  )  ) ;//20MHZ
CLOCKMEM  ck3 ( .CLK(MIPI_PIXEL_CLK_)   ,.CLK_FREQ  (25000000  ) , . CK_1HZ (D8M_CK_HZ3  )  )  ;//25MHZ


//assign LEDR = { D8M_CK_HZ ,D8M_CK_HZ2,D8M_CK_HZ3 ,5'h0,CAMERA_MIPI_RELAESE ,MIPI_BRIDGE_RELEASE  } ; 

endmodule
