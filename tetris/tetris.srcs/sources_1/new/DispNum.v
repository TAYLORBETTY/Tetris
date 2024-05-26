`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/26 15:31:50
// Design Name: 
// Module Name: DispNum
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


module DispNum(
    input [15:0] HEXS,
    input [1:0] clk100HZ,
    input rst,
    input [3:0] EN,
    input [3:0] P,
    output [ 3:0] AN,
    output [ 7:0] SEG
    );

    wire [3:0] HEX;

    Mux4to1 Mux1(.S(clk100HZ),.D0(P[0]),.D1(P[1]),.D2(P[2]),.D3(P[3]),.Y(SEG[7]));
    Mux4to1b4 MUX(.S(clk100HZ), .D0(HEXS[3:0]), .D1(HEXS[7:4]),  .D2(HEXS[11:8]),  .D3(HEXS[15:12]), .Y(HEX));
    MyMC14495 mc14495( .D(HEX), .SEG(SEG[6:0]) );
    Enabler E( .S(clk100HZ), .D0(EN[0]),  .D1(EN[1]), .D2(EN[2]), .D3(EN[3]), .AN(AN));

endmodule

