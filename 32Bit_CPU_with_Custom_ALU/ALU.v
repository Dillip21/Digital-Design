`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dillip
// 
// Create Date: 08.05.2024 22:43:13
// Design Name: 
// Module Name: ALU_unit
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

module ALU_unit( ctrl_sig,in1,in2,result,clk);
    input clk;
    input [3:0] ctrl_sig;
    input signed [31:0] in1;
    input signed [31:0] in2;
    output reg signed [31:0] result;
    
    always@(posedge clk)
      #1  case(ctrl_sig)
            4'b0001: result<=in1 + in2;
            
            4'b0010: result<=in1 - in2;
            
            4'b0011: result<=in1 << in2[4:0];
            
            4'b0100:    begin
                            if(in1[31]==0 && in2[31]==0)
                                begin
                                    if(in1 < in2)
                                    result<=32'b1;
                                    else
                                    result<=32'b0;
                                end
                                else if(in1[31]==1 && in2[31]==0)
                                      result<=32'b1;
                                else if(in1[31]==0 && in2[31]==1)
                                      result<=32'b0;
                                 else if(in1[31]==1&&in2[31]==1)
                                    begin
                                    if(in1[30:0] > in2[30:0])
                                    result<=32'b1;
                                    else
                                    result<=32'b0;
                                    end
                         end
                         
            4'b0101:  if(in1[31:0] < in2[31:0])
                        result<=32'b1;
                        else
                        result<=32'b0;
                                      
            4'b0110: result<=in1 ^ in2;
            
            4'b0111: result<=in1 >> in2[4:0];
            
            4'b1000: result<=in1 >>> in2[4:0];
            
            4'b1001: result<=in1 | in2;
            
            4'b1010: result<=in1 & in2;
            
        endcase
endmodule