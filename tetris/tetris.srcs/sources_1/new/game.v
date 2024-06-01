`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/23 20:22:10
// Design Name: 
// Module Name: game
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


module game(
    input clk,
    input rst,
    input [7:0] keyboard_data,
    input keyboard_ready,

    output reg [2399:0] map, // 10 × 20 大小的网�???
    output reg [1:0] state_r
    );
    function integer Hash;
        input [3:0]x,y;
        Hash = y*10 + x;
    endfunction//利用hash函数把二维的坐标转为一维的数字
    integer hash_index,next_hash_index;
    integer i,j;
    reg game_over_signal;
    wire [1:0] state;
    integer shape[6:0][3:0][3:0];   //设了一个7*4*4大小的数组，shape[1][2][3] = -10
                                    //表示第1种形状的方块旋转2个90度后，
                                    //第3个格子相对第0个格子的距离为 (0,-1)
    integer i, j;                  
    reg [1:0] rotate_degree;
    reg in_square;
    integer cnt;
    wire [3:0] square_x,square_y;
    wire [2:0] square_type;
    reg [11:0] slice_12b;
    wire clk_fall;//这是下落的信号，还没想好怎么�?
    reg generate_signal;
    parameter   White = 12'b111111111111, 
                Black = 12'b000000000000, 
                Blue = 12'b000000001111, 
                Red = 12'b111100000000, 
                Green = 12'b000011110000;
    parameter I = 3'b000, J = 3'b001, L = 3'b010, Z = 3'b011, S = 3'b100, T = 3'b101, O = 3'b110;

    //状态机
    automaton gamestate(.clk(clk), .rst(rst), .game_over_signal(game_over_signal), .state(state));
    always @(posedge clk)begin
        state_r <= state;
    end
    //
    initial begin
        // Row 0
        shape[0][0][0] = 0; shape[0][0][1] = -1; shape[0][0][2] = 1; shape[0][0][3] = 2;
        shape[0][1][0] = 0; shape[0][1][1] = 10; shape[0][1][2] = -10; shape[0][1][3] = -20;
        shape[0][2][0] = 0; shape[0][2][1] = -1; shape[0][2][2] = 1; shape[0][2][3] = 2;
        shape[0][3][0] = 0; shape[0][3][1] = 10; shape[0][3][2] = -10; shape[0][3][3] = -20;

        // Row 1
        shape[1][0][0] = 0; shape[1][0][1] = 1; shape[1][0][2] = 2; shape[1][0][3] = 12;
        shape[1][1][0] = 0; shape[1][1][1] = -1; shape[1][1][2] = -10; shape[1][1][3] = -20;
        shape[1][2][0] = 0; shape[1][2][1] = 1; shape[1][2][2] = 2; shape[1][2][3] = -10;
        shape[1][3][0] = 0; shape[1][3][1] = 1; shape[1][3][2] = 10; shape[1][3][3] = 20;

        // Row 2
        shape[2][0][0] = 0; shape[2][0][1] = 1; shape[2][0][2] = 2; shape[2][0][3] = 10;
        shape[2][1][0] = 0; shape[2][1][1] = -1; shape[2][1][2] = 10; shape[2][1][3] = 20;
        shape[2][2][0] = 0; shape[2][2][1] = -1; shape[2][2][2] = -2; shape[2][2][3] = -10;
        shape[2][3][0] = 0; shape[2][3][1] = 1; shape[2][3][2] = -10; shape[2][3][3] = -20;

        // Row 3
        shape[3][0][0] = 0; shape[3][0][1] = -1; shape[3][0][2] = 10; shape[3][0][3] = 11;
        shape[3][1][0] = 0; shape[3][1][1] = -10; shape[3][1][2] = -1; shape[3][1][3] = 9;
        shape[3][2][0] = 0; shape[3][2][1] = -1; shape[3][2][2] = 10; shape[3][2][3] = 11;
        shape[3][3][0] = 0; shape[3][3][1] = -10; shape[3][3][2] = -1; shape[3][3][3] = 9;

        // Row 4
        shape[4][0][0] = 0; shape[4][0][1] = 1; shape[4][0][2] = 10; shape[4][0][3] = 9;
        shape[4][1][0] = 0; shape[4][1][1] = -10; shape[4][1][2] = 1; shape[4][1][3] = 11;
        shape[4][2][0] = 0; shape[4][2][1] = 1; shape[4][2][2] = 10; shape[4][2][3] = 9;
        shape[4][3][0] = 0; shape[4][3][1] = -10; shape[4][3][2] = 1; shape[4][3][3] = 11;

        // Row 5
        shape[5][0][0] = 0; shape[5][0][1] = 1; shape[5][0][2] = -1; shape[5][0][3] = 10;
        shape[5][1][0] = 0; shape[5][1][1] = -10; shape[5][1][2] = 1; shape[5][1][3] = 11;
        shape[5][2][0] = 0; shape[5][2][1] = 1; shape[5][2][2] = -1; shape[5][2][3] = 10;
        shape[5][3][0] = 0; shape[5][3][1] = -10; shape[5][3][2] = 1; shape[5][3][3] = 11;

        // Row 6
        shape[6][0][0] = 0; shape[6][0][1] = 1; shape[6][0][2] = 10; shape[6][0][3] = 11;
        shape[6][1][0] = 0; shape[6][1][1] = 1; shape[6][1][2] = 10; shape[6][1][3] = 11;
        shape[6][2][0] = 0; shape[6][2][1] = 1; shape[6][2][2] = 10; shape[6][2][3] = 11;
        shape[6][3][0] = 0; shape[6][3][1] = 1; shape[6][3][2] = 10; shape[6][3][3] = 11;
  end


    
    
    //产生方块并赋值给地图
    square_generator _square_generator(.clk(clk), 
                                        .rst(rst), 
                                        .rdn(generate_signal), 
                                        .square_x(square_x), 
                                        .square_y(square_y),
                                        .square_type(square_type));
    reg [3:0] square_x_r,square_y_r;
    always @(negedge generate_signal) begin
        for(i = 0; i < 4; i = i+1) begin
            hash_index = Hash(square_x,square_y) + shape[square_type][0][i];
            slice_12b = White;
            for(j = 0; j < 12; j = j+1)  map[hash_index*12+j] = slice_12b[j];
        end
        rotate_degree <= 2'b00;
        square_x_r <= square_x;
        square_y_r <= square_y;
    end

    
    //下降并顺便检测有没有碰到底，
    always @(posedge clk) begin
        if(rst) begin
            cnt <= 0;
        end
        else if (cnt == 500000) begin   
            if(!generate_signal) begin
                for(i = 0; i < 4; i = i+1) begin
                    in_square = 0;
                    hash_index = Hash(square_x_r, square_y_r) +shape[square_type][rotate_degree][i];
                    next_hash_index = Hash(square_x_r,square_y_r+1) + shape[square_type][rotate_degree][i];
                    for(j = 0; j < 4; j = j+1) begin
                        if(i != j && next_hash_index == Hash(square_x_r, square_y_r) +shape[square_type][rotate_degree][j]) begin
                            in_square = 1;
                        end
                    end    
                    for(j = 0; j < 12; j = j+1) begin
                        slice_12b[j] = map[next_hash_index*12+j];
                    end
                    if(!in_square && next_hash_index >= 200) generate_signal = 1;
                    else if(!in_square && slice_12b != Black)
                        generate_signal = 1;
                end
                if(!generate_signal)
                    square_x_r <= square_x_r;
                    square_y_r <= square_y_r + 1;
            end
            cnt <= 0;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
    reg move_sig,rotate_sig;
    integer next_x,next_y;
    always @(posedge clk) begin
        move_sig = 0;
        if(keyboard_ready && keyboard_data == 8'h1c) begin
            move_sig = 1;
            for(i = 0; i < 4; i = i+1) begin           
                in_square = 0;
                hash_index = Hash(square_x_r, square_y_r) +shape[square_type][rotate_degree][i];
                next_hash_index = Hash(square_x_r-1,square_y_r) + shape[square_type][rotate_degree][i];
                for(j = 0; j < 4; j = j+1) begin
                    if(i != j && next_hash_index == Hash(square_x_r, square_y_r) +shape[square_type][rotate_degree][j]) begin
                        in_square = 1;
                    end
                end

                if(!in_square && next_hash_index / 10 != square_y_r) 
                    move_sig = 0;
                else if(!in_square && slice_12b != Black)
                    move_sig = 0;
                    
            end
            if(move_sig) begin       
                for(i = 0; i < 4; i = i+1)begin
                    hash_index = Hash(square_x_r, square_y_r) +shape[square_type][rotate_degree][i];
                    next_hash_index = Hash(square_x_r-1,square_y_r) + shape[square_type][rotate_degree][i];
                    for(j = 0; j < 12; j = j+1) begin
                        slice_12b[j] = map[hash_index*12+j];
                        map[hash_index*12+j] = 1'b0;
                    end
                    for(j = 0; j < 12; j = j+1) begin
                        map[next_hash_index*12+j] = slice_12b[j];
                    end
                end
                square_x_r <= square_x_r-1;
                square_y_r <= square_y_r;
            end
        end
        else if(keyboard_ready && keyboard_data == 8'h23) begin
            move_sig = 1;
            for(i = 0; i < 4; i = i+1) begin           
                in_square = 0;
                hash_index = Hash(square_x_r, square_y_r) +shape[square_type][rotate_degree][i];
                next_hash_index = Hash(square_x_r+1,square_y_r) + shape[square_type][rotate_degree][i];
                next_x = next_hash_index % 10;
                next_y = next_hash_index / 10;
                for(j = 0; j < 4; j = j+1) begin
                    if(i != j && next_hash_index == Hash(square_x_r, square_y_r) +shape[square_type][rotate_degree][j]) begin
                        in_square = 1;
                    end
                end
                for(j = 0; j < 12; j = j+1) begin
                    slice_12b[j] = map[next_hash_index*12+j];
                end
                if(!in_square && next_hash_index / 10 != square_y_r) 
                    move_sig = 0;
                else if(!in_square && slice_12b != Black)
                    move_sig = 0;   
            end
            if(move_sig) begin       
                for(i = 0; i < 4; i = i+1)begin
                    hash_index = Hash(square_x_r, square_y_r) +shape[square_type][rotate_degree][i];
                    next_hash_index = Hash(square_x_r+1,square_y_r) + shape[square_type][rotate_degree][i];
                    for(j = 0; j < 12; j = j+1) begin
                        slice_12b[j] = map[hash_index*12+j];
                        map[hash_index*12+j] = 1'b0;
                    end
                    for(j = 0; j < 12; j = j+1) begin
                        map[next_hash_index*12+j] = slice_12b[j];
                    end
                end
                square_x_r <= square_x_r+1;
                square_y_r <= square_y_r;
            end
        end
        else if (keyboard_ready && keyboard_data == 8'h1d) begin
            
            
        end
    end
    




    
    
endmodule
