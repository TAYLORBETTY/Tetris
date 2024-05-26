`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/26 15:41:53
// Design Name: 
// Module Name: MyMC14485
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


module MyMC14495 (
    input [3:0] D,
    output [6:0] SEG
    );

    assign SEG[0] = ~D[3] & D[2] & ~D[1] & ~D[0] | ~D[3] & ~D[2] & ~D[1] & D[0] | D[3] & ~D[2] & D[1] & D[0] | D[3] & D[2] & ~D[1] & D[0] ;
    assign SEG[1] = ~D[3] & D[2] & ~D[1] & D[0] | D[3] & D[1] & D[0] | D[3] & D[2] & ~D[0] | D[2] & D[1] & ~D[0];
    assign SEG[2] = D[3] & D[2] & D[1] | D[3] & D[2] & ~D[0]| ~D[3] & ~D[2] & D[1] & ~D[0];
    assign SEG[3] = D[2] & D[1] & D[0] | D[3] & ~D[2] & D[1] & ~D[0 ]| ~D[3] & D[2] & ~D[1] & ~D[0] | ~D[3] & ~D[2] & ~D[1] & D[0];
    assign SEG[4] = ~D[3] & D[0] | ~D[2] & ~D[1] & D[0] | ~D[3] & D[2] & ~D[1];
    assign SEG[5] = ~D[3] & ~D[2] & D[0] | ~D[3] & ~D[2] & D[1] | ~D[3] & D[1] & D[0] | D[3] & D[2] & ~D[1] & D[0];
    assign SEG[6] = ~D[3] & ~D[2] & ~D[1] | ~D[3] & D[2] & D[1] & D[0] | D[3] & D[2] & ~D[1] & ~D[0];

endmodule