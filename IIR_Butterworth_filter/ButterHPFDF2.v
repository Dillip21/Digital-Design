//Dillip S
//ButterHPF


`timescale 1ns / 1ps

module pipelined_iir(clk, reset, x, y) ;

output wire signed [15:0] y;
input wire signed [15:0] x;

// filter coefficients
wire signed [15:0] b1, b2, b3, b4, b5, b6,
                   a2, a3, a4, a5, a6;
input wire clk, reset ;

// filter variables
//wire signed [63:0] b1_in, b2_in, b3_in, b4_in, b5_in, b6_in, b7_in, b8_in, b9_in, b10_in, b11_in, b12_in, b13_in;
wire signed [31:0] b1_in, b2_in, b3_in, b4_in, b5_in, b6_in;
wire signed [31:0] a2_out, a3_out, a4_out, a5_out, a6_out;
//wire signed [63:0] a2_out, a3_out, a4_out, a5_out, a6_out, a7_out, a8_out, a9_out, a10_out, a11_out, a12_out, a13_out;

// history pipeline regs
reg signed [31:0] f1_n1, f1_n2, f1_n3, f1_n4, f1_n5, f1_n6; 
// history pipeline inputs
wire signed [31:0] f1_n1_input, f1_n2_input, f1_n3_input, f1_n4_input, f1_n5_input, f1_n6_input, f1_n0; 

// filter coefficients values
assign a1 = 32768;
assign a2 = -97498;
assign a3 = 124715;
assign a4 = -83402;
assign a5 = 28872;
assign a6 = -4110;

assign b1 = 11605;
assign b2 = -58026;
assign b3 = 116052;
assign b4 = -116052;
assign b5 = 58026;
assign b6 = -11605;


// update filter variables
assign b1_in = b1*x;
assign b2_in = b2*x;
assign b3_in = b3*x;
assign b4_in = b4*x;
assign b5_in = b5*x;
assign b6_in = b6*x;


assign a1_out = a1*f1_n0;
assign a2_out = a2*f1_n0;
assign a3_out = a3*f1_n0;
assign a4_out = a4*f1_n0;
assign a5_out = a5*f1_n0;
assign a6_out = a6*f1_n0;


// add operations
assign f1_n0_input = b1_in + f1_n1 - a1_out;
assign f1_n1_input = b2_in + f1_n2 - a2_out;
assign f1_n2_input = b3_in + f1_n3 - a3_out;
assign f1_n3_input = b4_in + f1_n4 - a4_out;
assign f1_n4_input = b5_in + f1_n5 - a5_out;
//assign f1_n5_input = b6_in + f1_n6 - a6_out;
assign f1_n5_input = b6_in - a6_out;


// scale the output and turncate for audio codec
//assign f1_n0 = (f1_n1 + b1_in) >>> 20;
//assign y = f1_n0;
assign y = b1_in;

// Run the filter state machine at audio sample rate
always @ (negedge clk) 
begin
    if (reset)
    begin
        f1_n1 <= 0;
        f1_n2 <= 0; 
        f1_n3 <= 0;
        f1_n4 <= 0;
        f1_n5 <= 0;
        f1_n6 <= 0; 
     
    end
    else 
    begin
        f1_n1 <= f1_n1_input;
        f1_n2 <= f1_n2_input;  
        f1_n3 <= f1_n3_input;
        f1_n4 <= f1_n4_input;
        f1_n5 <= f1_n5_input;
//        f1_n6 <= f1_n6_input;      
        
    end
end 
endmodule