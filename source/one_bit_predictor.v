`timescale 1ns / 1ps
/*
    One bit branch prediction
*/
module one_bit_predictor #(parameter address_width = 1)(
    input clk,
    input rst,
    input [address_width-1:0] branch_address,
    input branch_result,
    output reg prediction
    );

reg branch_history_table [(2**address_width)-1:0];

integer i;
always@(posedge clk or posedge rst)begin
    if(rst)begin
        prediction <= 0;
        for(i = 0; i < (2**address_width); i = i +1) branch_history_table[i] <= 0;
    end
    else begin
        branch_history_table[branch_address] <= branch_result;
        prediction <= branch_history_table[branch_address];
    end
end

endmodule
