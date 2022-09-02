`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:41:04 05/12/2022 
// Design Name: 
// Module Name:    RISCVpipeline 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module RISCVpipeline(
	
	output [31:0] current_pc,
	output [31:0] instruction,

	input clk, rst
	);
	wire c;
	wire [1:0] LED_clk;
	wire [31:0] pc, ins;
	wire ind_ctl_0, ind_ctl_1, ind_ctl_2, ind_ctl_3, ind_ctl_4, ind_ctl_5, ind_ctl_6, ind_ctl_7;
	wire exe_ctl_0, exe_ctl_1, exe_ctl_2, exe_ctl_3, exe_ctl_4, exe_ctl_5, exe_ctl_6, exe_ctl_7;
	wire mem_ctl_0, mem_ctl_1, mem_ctl_2, mem_ctl_3, mem_ctl_4, mem_ctl_5, mem_ctl_6, mem_ctl_7;
	wire wb_ctl_0,  wb_ctl_1,  wb_ctl_2,  wb_ctl_3,  wb_ctl_4,  wb_ctl_5,  wb_ctl_6,  wb_ctl_7;
	
	wire [31:0]  ind_pc;
   wire [31:0]	 ind_data1, ind_data2, ind_imm,			exe_data2, exe_addr, exe_result,		mem_addr, mem_result, mem_data,		wb_data;
	wire [4:0]	 ind_rd,	exe_rd,	mem_rd,	wb_rd;
	wire [6:0]	 ind_funct7;
	wire [2:0]	 ind_funct3;
	wire 			 ind_jal, ind_jalr,		exe_zero,		mem_PCSrc;
	
	
	
	assign current_pc = pc;
	assign instruction = ins;
////////////////////////
	InFetch A1_InFetch(		
		.PCSrc(mem_PCSrc),
		.PCimm_in(mem_addr),
		.PC_out(pc),
		.instruction_out(ins),
		.reset(rst),
		.clk(clk));					
////////////////////////
	InDecode A3_InDecode(
	.PC_in(pc),
	
	
	.instruction_in(ins),
	.WriteReg(wb_rd),
	.WriteData(wb_data),
	.reset(rst),
	.clk(clk),
	
	.Ctl_ALUSrc_out(ind_ctl_0),
	.Ctl_MemtoReg_out(ind_ctl_1),
	.Ctl_RegWrite_out(ind_ctl_2),
	.Ctl_MemRead_out(ind_ctl_4),
	.Ctl_Branch_out(ind_ctl_4),
	.Ctl.ALUOpcode1_out(ind_ctl_6),
	.Ctl_ALUOpcode0_out(ind_ctl_7),
	.PC_out(ind_pc),
	.Rd_out(ind_rd),
	
	.ReadData1_out(ind_data1),
	.ReadData2_out(ind_data2),
	.Immediate_out(ind_imm),
	.funct7_out(ind_funct7),
	.funct3_out(ind_funct3),
	.jalr_out(ind_jalr),
	.jal_out(ind_jal)
	
	
	
	);
////////////////////////
	Execution A4_Execution(

 .Ctl_ALUSrc_in(ind_ctl_0),
 .Ctl_MemtoReg_in(ind_ctl_1),
 .Ctl_RegWrite_in(ind_ctl_2),
 
 
 .Ctl_MemtoReg_out(exe_ctl_1),
 .Ctl_RegWrite_out(exe_ctl_2),
 
 .Ctl_MemRead_in(ind_ctl_3), 
 .Ctl_MemRead_out(exe_ct_3),
 .Ctl)Memwrite_in(ind_ctl_4),
 .Ctl_Memwrite_out(exe_ctl_3),
 .Ctl_Branch_in(ind_ctl_5), 
 .Ctl_Memwrite_out(exe_ctl_4),
 .Ctl_ALUOpcode_in(ind_ctl_6),
 .Ctl_ALUOpcode_in(ind_ctl_7),
 
 
 .Rd_in(ind_rd),
 .Rd_out(exe_rd),
 .Zero_out(exe_zero)
 
 .ReadData1_in(ind_data1),
 .ReadData2_in(ind_data2),
 .Immediate_in(ind_imm),
 .ALUresult_out(exe_result),
 .Pc_in(ind_pc),
 .Pcimm_out(exe_addr),
 .funct7_in(ind_funct7),
 .funct3_in(ind_funct3),
 .clk(clk)
 
 

	);
////////////////////////			
	Memory A6_Memory( 
	
	.Ctl_MemtoReg_in(exe_ctl_1),
	.Ctl_MemtoReg_out(mem_ctl_1),
	.Ctl_RegWrite_in(exe_ctl_2),
	.Ctl_RegWrite_out(mem_ctl_2),
	.Ctl_MemRead_in(exe_ctl_3),
	.Ctl_MemWrite_in(exe_ctl_4),
	.Ctl_Branch_in(exe_ctl_5),
	
	.Rd_in(exe_rd),
	.Rd_out(mem_rd),
	.PCSrc(mem_PCSrc),
	.Read_Data(mem_data),
	.ALUresult_in(exe_result),
	.ALUresult_out(mem_result),
	.PCimm_in(exe_addr),
	.PCimm_out(mem_addr),
	.Zero_in(exe_zero),
	.reset(rst),
	.clk(clk)
	);
////////////////////////
	WB A7_WB(
	
	.Ctl_MemtoReg_in(mem_ctl_1),
	.Ctl_RegWrite_out(wb_ctl_2),
	.Ctl_RegWrite_in(mem_ctl_2),
	.ReadDatafromMem_in(mem_data),
	.WriteDatatoReg_out(wb_data),
	.ALUresult_in(mem_result),
	.Rd_in(mem_rd),
	.Rd_out(wb_rd)
	
	);
endmodule
