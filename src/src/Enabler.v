module Enabler(
    input [1:0] S,
    input D0,
    input D1,
    input D2,
    input D3,
    output [3:0] AN
    );
    Mux4to1b4 m1(
            .S(S),
            .D0(4'b1110),
            .D1(4'b1101),
            .D2(4'b1011),
            .D3(4'b0111),
            .Y(AN)
    );
    endmodule