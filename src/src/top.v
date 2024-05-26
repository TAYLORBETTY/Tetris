module top (
	input clk,					//FPGA板上的时钟信号
    input rst,					//重置信号
	input PS2C,					//键盘脉冲信号
	input PS2D,					//键盘数据信号
    output [3:0] R, G, B,		//VGA
    output HS, VS,
	output [7:0] SEG,			//七段数码管
    output [3:0] AN
);

    reg clk25MHZ;
	reg [1:0] clk100HZ;
	clk_div divider(.clk(clk), .clk25MHZ(clk25MHZ), .clk100HZ(clk100HZ));

	wire [8:0] row;
	wire [9:0] col;
	wire rdn;
	wire [11:0] pixel;
	VGA vga0(.clk(clk25MHZ), .rst(rst), .R(R), .G(G), .B(B), .HS(HS), .VS(VS), .row(row), .col(col), .rdn(rdn), .Din(pixel));


	reg [7:0] keyboard_data;
	reg keyboard_ready;
	PS2_Keyboard_Driver pkd(.clk(clk), .rst(rst), .rdn(1'b0), .data(keyboard_data), .ready(keyboard_ready));

	DispNum displaynumber(.clk100HZ(clk100HZ), .rst(rst), .HEXS(16'h1234), .EN(4'b1111), .P(4'b0000), .SEG(SEG), .AN(AN));
	
endmodule	