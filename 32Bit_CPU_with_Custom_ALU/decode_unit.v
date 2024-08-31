`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dillip
// 
// Create Date: 08.05.2024 19:21:27
// Design Name: 
// Module Name: fetch_decode_unit
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

module fetch_decode_unit(clk,instr,opcode,rs1_addr,rs2_addr,rd_addr,func);
    
    input clk;
    output reg [31:0] instr;
    output reg [6:0] opcode;
    output reg [4:0] rs1_addr;
    output reg [4:0] rs2_addr;
    output reg [4:0] rd_addr;
    output reg [2:0] func;

     reg [31:0] Instr_mem[0:255];//Intruction memory 255*32 bits
     reg [3:0]PC;
     
     always@(posedge clk)
     begin
      instr = Instr_mem[PC];
      PC = PC+1;
     end
     
 always@(posedge clk)
 begin
    opcode <= instr[6:0];
	rs1_addr <= instr[19:15];
	rs2_addr <= instr[24:20];
	rd_addr <= instr[11:7];
	func <= instr[14:12];
 end

endmodule
