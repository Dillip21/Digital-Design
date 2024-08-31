`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dillip
// 
// Create Date: 08.05.2024 18:34:23
// Design Name: 
// Module Name: control_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//module control_unit(instr,func,opcode,ctrl_sig);
    
//    input [31:0] instr;
//    input [2:0] func;
//    input [6:0] opcode; 
//    output reg [3:0] ctrl_sig;   
    
//    always@(*)
//        if( instr[31:25]==7'b0)
//            case(func) 
//                3'b000: ctrl_sig=4'b0001;
//                3'b001: ctrl_sig=4'b0011;
//                3'b010: ctrl_sig=4'b0100;
//                3'b011: ctrl_sig=4'b0101;
//                3'b100: ctrl_sig=4'b0110;
//                3'b101: ctrl_sig=4'b0111;
//                3'b110: ctrl_sig=4'b1001;
//                3'b111: ctrl_sig=4'b1010;
//                default:ctrl_sig=4'b0000;
//             endcase
//         else
//            if( func==3'b000)
//             ctrl_sig=4'b0010;
//             else
//             ctrl_sig=4'b1000;

//endmodule

module control_unit_fsm(
    input [31:0] instr,
    input [2:0] func,
    input [6:0] opcode, 
    input clk,                // Clock signal
    input reset,              // Reset signal
    output reg [3:0] ctrl_sig // Control signal output
);
    
    // State encoding using local parameters
    localparam IDLE = 2'b00;
    localparam FETCH = 2'b01;
    localparam DECODE = 2'b10;
    localparam EXECUTE = 2'b11;

    reg [1:0] state, next_state; // Current and next states

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (instr[31:25] == 7'b0000000) begin
                    next_state = FETCH;
                end else begin
                    next_state = IDLE;
                end
            end

            FETCH: begin
                next_state = DECODE;
            end

            DECODE: begin
                next_state = EXECUTE;
            end

            EXECUTE: begin
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic based on state and inputs
    always @(*) begin
        case (state)
            IDLE: ctrl_sig = 4'b0000;

            FETCH: ctrl_sig = 4'b0001;

            DECODE: begin
                if (instr[31:25] == 7'b0000000) begin
                    case (func)
                        3'b000: ctrl_sig = 4'b0001;
                        3'b001: ctrl_sig = 4'b0011;
                        3'b010: ctrl_sig = 4'b0100;
                        3'b011: ctrl_sig = 4'b0101;
                        3'b100: ctrl_sig = 4'b0110;
                        3'b101: ctrl_sig = 4'b0111;
                        3'b110: ctrl_sig = 4'b1001;
                        3'b111: ctrl_sig = 4'b1010;
                        default: ctrl_sig = 4'b0000;
                    endcase
                end else if (func == 3'b000) begin
                    ctrl_sig = 4'b0010;
                end else begin
                    ctrl_sig = 4'b1000;
                end
            end

            EXECUTE: begin
                // Execute logic could modify ctrl_sig further or use it to control other modules
                ctrl_sig = ctrl_sig; // Example: maintain the control signal
            end

            default: ctrl_sig = 4'b0000;
        endcase
    end

endmodule
