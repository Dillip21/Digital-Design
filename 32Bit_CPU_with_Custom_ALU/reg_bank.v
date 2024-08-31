`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dillip
// 
// Create Date: 08.05.2024 20:41:39
// Design Name: 
// Module Name: reg_bank
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

module reg_bank(rs1_addr,rs2_addr,rs1_data,rs2_data,rd_addr,rd_data,clk);

input  clk;  	
input [4:0] rs1_addr;	
input [4:0] rs2_addr;	
output [31:0] rs1_data;	
output [31:0] rs2_data;	
input [4:0] rd_addr;	
input [31:0] rd_data;	
 reg [31:0] Reg[0:31];
    
    begin
		assign rs1_data = Reg[rs1_addr];
		assign rs2_data = Reg[rs2_addr];
    end
	
	always@ (posedge clk)
		begin
		 Reg[rd_addr] = rd_data;
		end	
endmodule