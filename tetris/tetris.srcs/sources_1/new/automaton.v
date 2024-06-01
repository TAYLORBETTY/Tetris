`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/01 12:39:41
// Design Name: 
// Module Name: automaton
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


module automaton(
    input clk,
    input rst,
    input game_over_signal,
    output reg [1:0] state
    );
    parameter Start = 2'b00, Playing = 2'b01, Over = 2'b10;

    initial begin
        state <= Start;
    end
    always @(posedge clk or posedge rst) begin
        if(rst) state <= Start;
        else begin
            case(state) 
                Start:begin
                    if(keyboard_ready && keyboard_data == 8'h29) begin 
                        state <= Playing;
                    end
                    else begin 
                        state <= state;
                    end
                end
                Playing:begin
                    if(game_over_signal) begin
                        state <= Over;
                    end
                    else begin 
                        state <= state;
                    end
                end
                Over: begin
                    if(keyboard_ready && keyboard_data == 8'h29) begin
                        state <= Start;
                    end
                    else begin
                        state <= state;
                    end
                end
            endcase
        end
    end
endmodule
