`timescale 1ns / 1ps
/*
*   saturating predictor
*   By default is a two bit saturating predictor
*/
module saturating_predictor #(parameter address_width = 1, parameter counter_width = 2)(
    input clk,
    input rst,
    input cs,
    input enable,
    input [address_width-1:0] branch_address,
    input branch_result,
    output reg prediction
    );

reg [counter_width-1:0] branch_counter_table [(2**address_width)-1:0];

wire [counter_width-1:0] current_branch_counter;
assign current_branch_counter = branch_counter_table[branch_address];

integer j;
always@(posedge clk)begin
    if(rst)begin
        for(j = 0; j < (2**address_width); j = j +1) branch_counter_table[j] <= 0;
    end
    else if(cs && enable) begin
        if(branch_result &&  (current_branch_counter != ((2**counter_width)-1)))begin
            branch_counter_table[branch_address] <= current_branch_counter + 1;
        end
        else if((!branch_result) && (current_branch_counter != 0))begin
            branch_counter_table[branch_address] <= current_branch_counter - 1;
        end
    end
end

always@(posedge clk)begin
    if(rst)begin
        prediction <= 0;
    end
    else if(enable)begin
        prediction <= current_branch_counter[counter_width-1];
    end
end


endmodule
