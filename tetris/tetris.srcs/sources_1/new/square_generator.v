`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/24 13:05:14
// Design Name: 
// Module Name: square_generator
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


module square_generator(
    input clk,
    input rst,
    input rdn,
    output  [3:0] square_x,
    output  [3:0] square_y,
    output  [2:0] square_type
    );
    parameter MaxTypeNum = 7;
    parameter Width = 8;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            square_x <= 0;
            square_y <= 0;
        end else if (rdn) begin
            square_type <= $random() % MaxTypeNum;
            square_x <= 4'd3;
            square_y <= 4'd0;
        end
    end
endmodule
