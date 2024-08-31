`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dillip
// 
// Create Date: 08.05.2024 23:45:23
// Design Name: 
// Module Name: ALU_dut
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


module ALU_dut( );

    reg clk;
    wire [31:0] instr;
    wire [6:0] opcode;
    wire [4:0] rs1_addr;
    wire [4:0] rs2_addr;
    wire [4:0] rd_addr;
    wire [2:0] func;
    
    wire [3:0] ctrl_sig;
    
    wire [31:0] rs1_data;	
    wire [31:0] rs2_data;	
    wire [31:0] rd_data;
    
    integer i;
    
    fetch_decode_unit IF_ID(clk,instr,opcode,rs1_addr,rs2_addr,rd_addr,func);
    control_unit IC(instr,func,opcode,ctrl_sig);
    reg_bank Register(rs1_addr,rs2_addr,rs1_data,rs2_data,rd_addr,rd_data,clk);
    ALU_unit IE(ctrl_sig,rs1_data,rs2_data,rd_data,clk);

    initial
    begin 
    clk=1'b0;
    forever #5 clk=~clk;
    end
    
    initial
    begin
    Register.Reg[0]=32'h0000000F; 
    Register.Reg[1]=32'h0000000C; 
    Register.Reg[4]=32'hFF0000FF; 
    Register.Reg[5]=32'h00000004; 
    Register.Reg[7]=32'h70000000;
    Register.Reg[8]=32'hF0000000;
    end
    
    initial
    begin
     IF_ID.PC=1'b0;
     IF_ID.Instr_mem[0]=32'b00000000000100000000000100110011;// R2=R0+R1
     IF_ID.Instr_mem[1]=32'b01000000000100000000000110110011;// R3=R0-R1
     IF_ID.Instr_mem[2]=32'b00000000010100100001001100110011;// R6=R4<<R5
     IF_ID.Instr_mem[3]=32'b00000000100000111010010010110011;// Set R9, if R7<R8 signed
     IF_ID.Instr_mem[4]=32'b00000000100000111011010100110011;// RSet R10, if R7<R8 unsigned
     IF_ID.Instr_mem[5]=32'b00000000000100000100010110110011;// R11=R0^R1
     IF_ID.Instr_mem[6]=32'b00000000010100100101011000110011;// R12=R4>>R5
     IF_ID.Instr_mem[7]=32'b01000000010100100101011010110011;// R13=R4>>>R5
     IF_ID.Instr_mem[8]=32'b00000000000100000110011100110011;// R14=R0 | R1
     IF_ID.Instr_mem[9]=32'b00000000000100000111011110110011;// R15=R0 & R1
     
     #115    for(i=0 ; i<32 ; i=i+1)
               $display("R[%0d] = %0h",i,Register.Reg[i]);
     $stop;
     end
endmodule

//module ALU_dut();

//    reg clk;
//    reg reset;                    // Added reset signal
//    wire [31:0] instr;
//    wire [6:0] opcode;
//    wire [4:0] rs1_addr;
//    wire [4:0] rs2_addr;
//    wire [4:0] rd_addr;
//    wire [2:0] func;
    
//    wire [3:0] ctrl_sig;
    
//    wire [31:0] rs1_data;	
//    wire [31:0] rs2_data;	
//    wire [31:0] rd_data;
    
//    integer i;
    
//    fetch_decode_unit IF_ID(clk, instr, opcode, rs1_addr, rs2_addr, rd_addr, func);
//    control_unit_fsm IC(clk, reset, instr, func, opcode, ctrl_sig); // FSM control unit
//    reg_bank Register(rs1_addr, rs2_addr, rs1_data, rs2_data, rd_addr, rd_data, clk);
//    ALU_unit IE(ctrl_sig, rs1_data, rs2_data, rd_data, clk);

//    // Clock generation
//    initial begin
//        clk = 1'b0;
//        forever #5 clk = ~clk;
//    end
    
//    // Register initialization
//    initial begin
//        Register.Reg[0] = 32'h0000000F; 
//        Register.Reg[1] = 32'h0000000C; 
//        Register.Reg[4] = 32'hFF0000FF; 
//        Register.Reg[5] = 32'h00000004; 
//        Register.Reg[7] = 32'h70000000;
//        Register.Reg[8] = 32'hF0000000;
//    end
    
//    // Instruction memory initialization
//    initial begin
//        IF_ID.PC = 1'b0;
//        IF_ID.Instr_mem[0] = 32'b00000000000100000000000100110011; // R2=R0+R1
//        IF_ID.Instr_mem[1] = 32'b01000000000100000000000110110011; // R3=R0-R1
//        IF_ID.Instr_mem[2] = 32'b00000000010100100001001100110011; // R6=R4<<R5
//        IF_ID.Instr_mem[3] = 32'b00000000100000111010010010110011; // Set R9, if R7<R8 signed
//        IF_ID.Instr_mem[4] = 32'b00000000100000111011010100110011; // Set R10, if R7<R8 unsigned
//        IF_ID.Instr_mem[5] = 32'b00000000000100000100010110110011; // R11=R0^R1
//        IF_ID.Instr_mem[6] = 32'b00000000010100100101011000110011; // R12=R4>>R5
//        IF_ID.Instr_mem[7] = 32'b01000000010100100101011010110011; // R13=R4>>>R5
//        IF_ID.Instr_mem[8] = 32'b00000000000100000110011100110011; // R14=R0 | R1
//        IF_ID.Instr_mem[9] = 32'b00000000000100000111011110110011; // R15=R0 & R1
//    end
    
//    // FSM and test sequence
//    initial begin
//        reset = 1'b1;
//        #10 reset = 1'b0;  // Reset the FSM

//        #115;  // Wait for instructions to execute

//        // Display register values
//        for(i = 0; i < 32; i = i + 1) begin
//            $display("R[%0d] = %0h", i, Register.Reg[i]);
//        end
        
//        $stop;
//    end

//    // Monitor FSM state transitions and ctrl_sig
//    initial begin
//        $monitor("Time: %0t | FSM State: %b | ctrl_sig: %b | instr: %h", 
//                 $time, IC.state, ctrl_sig, instr);
//    end
    
//endmodule


//module ALU_dut();

//    reg clk;
//    reg reset;                    // Added reset signal
//    wire [31:0] instr;
//    wire [6:0] opcode;
//    wire [4:0] rs1_addr;
//    wire [4:0] rs2_addr;
//    wire [4:0] rd_addr;
//    wire [2:0] func;
    
//    wire [3:0] ctrl_sig;
    
//    wire [31:0] rs1_data;	
//    wire [31:0] rs2_data;	
//    wire [31:0] rd_data;
    
//    integer i;
    
//    fetch_decode_unit IF_ID(clk, instr, opcode, rs1_addr, rs2_addr, rd_addr, func);
//    control_unit_fsm IC(clk, reset, instr, func, opcode, ctrl_sig); // FSM control unit
//    reg_bank Register(rs1_addr, rs2_addr, rs1_data, rs2_data, rd_addr, rd_data, clk);
//    ALU_unit IE(ctrl_sig, rs1_data, rs2_data, rd_data, clk);

//    // Clock generation
//    initial begin
//        clk = 1'b0;
//        forever #5 clk = ~clk;
//    end
    
//    // Register initialization
//    initial begin
//        Register.Reg[0] = 32'h0000000A; // Modified initial values
//        Register.Reg[1] = 32'h00000005; 
//        Register.Reg[4] = 32'hFF00FF00; 
//        Register.Reg[5] = 32'h00000002; 
//        Register.Reg[7] = 32'h70000000;
//        Register.Reg[8] = 32'hF0000000;
//    end
    
//    // Instruction memory initialization
//    initial begin
//        IF_ID.PC = 1'b0;
//        IF_ID.Instr_mem[0] = 32'b00000000010100001000000110110011; // R3=R1+R2 (Addition)
//        IF_ID.Instr_mem[1] = 32'b01000000010100001001000110110011; // R4=R1-R2 (Subtraction)
//        IF_ID.Instr_mem[2] = 32'b00000000100000110010001110110011; // R6=R3<<R4 (Shift Left Logical)
//        IF_ID.Instr_mem[3] = 32'b00000000110001001010010010110011; // Set R9, if R4<R5 (Signed)
//        IF_ID.Instr_mem[4] = 32'b00000000110001001011010100110011; // Set R10, if R4<R5 (Unsigned)
//        IF_ID.Instr_mem[5] = 32'b00000000010100001100011010110011; // R13=R5>>R3 (Shift Right Logical)
//        IF_ID.Instr_mem[6] = 32'b01000000010100001101011010110011; // R15=R5>>>R3 (Shift Right Arithmetic)
//        IF_ID.Instr_mem[7] = 32'b00000000010100000111011100110011; // R7=R1&R2 (AND)
//        IF_ID.Instr_mem[8] = 32'b00000000010100000110011100110011; // R8=R1|R2 (OR)
//        IF_ID.Instr_mem[9] = 32'b00000000010100000101011100110011; // R9=R1^R2 (XOR)
//    end
    
//    // FSM and test sequence
//    initial begin
//        reset = 1'b1;
//        #10 reset = 1'b0;  // Reset the FSM

//        #120;  // Wait for instructions to execute

//        // Display register values
//        for(i = 0; i < 32; i = i + 1) begin
//            $display("R[%0d] = %0h", i, Register.Reg[i]);
//        end
        
//        $stop;
//    end

//    // Monitor FSM state transitions and ctrl_sig
//    initial begin
//        $monitor("Time: %0t | FSM State: %b | ctrl_sig: %b | instr: %h", 
//                 $time, IC.state, ctrl_sig, instr);
//    end
    
//endmodule

