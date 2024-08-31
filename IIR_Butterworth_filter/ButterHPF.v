//ButterHPF_tb


`timescale 1ns / 1ps


module iir (
    input clk,
    input signed [15:0] noisy_signal,  
    output signed [15:0] filtered_signal
);

parameter [16:0] a [0:5] = '{16'h1000, 
                                16'hD065, 
                                16'h3CE5, 
                                16'hD747, 
                                16'h0E19, 
                                16'hFDFF}; // Coefficients for numerator
parameter [16:0] b [0:5] = '{16'h05AA, 
                                16'hE3AB, 
                                16'h38AA, 
                                16'hC756, 
                                16'h1C55, 
                                16'hFA56}; // Coefficients for denominator

reg signed [15:0] delayed_signal [0:5];
reg signed [31:0] bprod [0:5];
reg signed [31:0] bprod [0:5];
reg signed [32:0] bsum_0 [0:2];
reg signed [33:0] bsum_1 [0:1];
reg signed [34:0] bsum_2;
reg signed [15:0] ydelayed_signal [0:5];
reg signed [31:0] aprod [0:5];
reg signed [31:0] aprod [0:5];
reg signed [32:0] asum_0 [0:2];
reg signed [33:0] asum_1 [0:1];
reg signed [34:0] asum_2;

always @(posedge clk) begin
    delayed_signal[0] <= noisy_signal;
    for (integer i = 1; i <= 5; i = i + 1) begin
        delayed_signal[i] <= delayed_signal[i - 1];
    end
end

// Pipelined multiply and accumulate
always @(posedge clk)
begin
    for (integer j=0; j<=5; j=j+1) begin
        bprod[j] <= delayed_signal[j] * b[j];
    end
end

always @(posedge clk)
begin
    bsum_0[0] <= (bprod[0]+ bprod[1]);
    bsum_0[1] <= (bprod[2]+ bprod[3]);
    bsum_0[2] <= (bprod[4]+ bprod[5]);
end
always @(posedge clk)
begin
    bsum_1[0] <= (bsum_0[0] + bsum_0[1]);
    bsum_1[1] <= (bsum_0[2]);
end
always @(posedge clk)
begin
    bsum_2 <= (bsum_1[0] + bsum_1[1]);
end

always @(posedge clk) begin
    ydelayed_signal[0] <= $signed(bsum_2[34:0]);
    for (integer k = 1; k <= 5; k = k + 1) begin
        ydelayed_signal[k] <= ydelayed_signal[k - 1];
    end
end
// Pipelined multiply and accumulate
always @(posedge clk)
begin
    for (integer l=0; l<=5; l=l+1) begin
        aprod[l] <= ydelayed_signal[l] * a[l];
    end
end
always @(posedge clk)
begin
    asum_0[0] <= (aprod[0]+ aprod[1]);
    asum_0[1] <= (aprod[2]+ aprod[3]);
    asum_0[2] <= (aprod[4]+ aprod[5]);
end
always @(posedge clk)
begin
    asum_1[0] <= (asum_0[0] + asum_0[1]);
    asum_1[1] <= (asum_0[2]);
end
always @(posedge clk)
begin
    asum_2 <= (asum_1[0] + asum_1[1]);
end

assign filtered_signal = $signed (asum_2[34:9]);



endmodule