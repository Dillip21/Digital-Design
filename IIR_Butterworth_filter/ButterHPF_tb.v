//Dillip S
//ButterHPF_tb


`timescale 1 ns / 100 ps

module iir_tb ();
localparam CORDIC_CLK_PERIOD = 2;                   // To create 1 GHz CORDIC sampling clock
localparam IIR_CLK_PERIOD = 10;                     // To create 1 kHz IIR Highpass filter sampling clock
localparam signed [15:0] PI_POS = 16'h 6488;        // +pi in fixed-point 1.2.13
localparam signed [15:0] PI_NEG = 16'h 9B78;        //-pi in fixed-point 1.2.13


localparam PHASE_INC_100HZ = 9.42;                  // Phase jump for 100Hz sine wave synthesis 
localparam PHASE_INC_200HZ = 4.71;                  // Phase jump for 200Hz sine wave synthesis

reg cordic_clk = 1'b0; 
reg iir_clk = 1'b0;
reg phase_tvalid = 1'b0;
reg signed [15:0] phase_100HZ=0;                    // 100Hz phase sweep, 1.2.13
reg signed [15:0] phase_200HZ = 0;                  // 200Hz phase sweep. 1.2.13

wire sincos_100HZ_tvalid;
wire signed [15:0] sin_100HZ, cos_100HZ;            // 1.1.14 100Hz sine/cosine

wire sincos_200HZ_tvalid;
wire signed [15:0] sin_200HZ, cos_200HZ;            // 1.1.14 200Hz sine/cosine

reg signed [15:0] noisy_signal = 0;          // Resampled 100Hz sine + 200Hz sine. 1.1.14 
wire signed [15:0] filtered_signal;          // Filtered signal output from IIR Highpass filter

// Synthesize 28Hz sine 
cordic_0 cordic_inst_0 (
.aclk                 (cordic_clk),
.s_axis_phase_tvalid  (phase_tvalid), 
.s_axis_phase_tdata   (phase_100HZ),
.m_axis_dout_tvalid   (sincos_100HZ_tvalid),
.m_axis_dout_tdata    ({sin_100HZ})
);

// Synthesize 30m2 sine
cordic_0 cordic_inst_1 (
.aclk                 (cordic_clk),
.s_axis_phase_tvalid  (phase_tvalid), 
.s_axis_phase_tdata   (phase_200HZ),
.m_axis_dout_tvalid   (sincos_200HZ_tvalid),
.m_axis_dout_tdata    ({sin_200HZ})
);

// Phase sweep
always @(posedge cordic_clk)
begin
    phase_tvalid <= 1'b1;             

// Sweep phase to synthesize 100Hz sine              
    if (phase_100HZ + PHASE_INC_100HZ < PI_POS) begin
        phase_100HZ <= phase_100HZ + PHASE_INC_100HZ;
    end else begin 
        phase_100HZ <= PI_NEG+ (phase_100HZ + PHASE_INC_100HZ - PI_POS);
    end
    
// Sweep phase to synthesize 200Hz sine 
    if (phase_200HZ + PHASE_INC_200HZ <= PI_POS) begin
        phase_200HZ <= phase_200HZ + PHASE_INC_200HZ;
    end else begin
        phase_200HZ <= PI_NEG + (phase_200HZ + PHASE_INC_200HZ - PI_POS);
    end
end


// Create 1 GHz Cordic clock
always begin
    cordic_clk = #(CORDIC_CLK_PERIOD/2) ~cordic_clk;
end

// Create 1 kHz IIR clock
always begin
    iir_clk = #(IIR_CLK_PERIOD/2) ~iir_clk;
end
// Noisy signal 100Hz sine + 200Hz sine
// Noisy signal is resampled at 1 kHz IIR sampling rate
always @(posedge iir_clk)
begin
    noisy_signal <= (sin_100HZ + sin_200HZ) / 2;
end
// Feed noisy signal into IIR Highpass filter
iir IIR_filter_inst ( 
    .clk (iir_clk), 
    .noisy_signal (noisy_signal), 
    .filtered_signal (filtered_signal)
);

    

endmodule