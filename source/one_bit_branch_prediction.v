`timescale 1ns / 1ps
/*
    One bit branch prediction
*/
module one_bit_branch_prediction(
    input clk,
    input rst,
    input branch_result,
    output reg prediction
    );

always@(posedge clk)begin
    if(rst)
        prediction <= 0;
    else
        prediction <= branch_result;
end

endmodule
