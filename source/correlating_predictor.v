`timescale 1ns / 1ps
/*
*   saturating predictor
*   By default is a two bit saturating predictor
*/
module correlating_predictor #(parameter address_width = 1, parameter n = 2, parameter m = 4)(
    input clk,
    input rst,
    input enable,
    input [address_width-1:0] branch_address,
    input branch_result,
    output prediction
    );

reg [m-1:0] global_branch_history;

//globa branch register shirt register
always@(posedge clk or posedge rst)begin
    if(rst)begin
        global_branch_history <= 0;
    end
    else if(enable)begin
        global_branch_history <= {global_branch_history[m-2:0], branch_result};
    end
end

reg [(2**m)-1: 0] bank_selector;
integer j;
always @(*)begin
    bank_selector = 1;
    for(j = 0; j < (2**m); j = j + 1)begin
        if(global_branch_history == j)begin
            bank_selector = 1 << j;
        end
    end
end

wire [(2**m)-1: 0] prediction_vector;

genvar i;
generate
    for (i = 0; i < (2**m); i = i+1) begin : bank_generator
    saturating_predictor predictor_bank (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .cs(bank_selector[i]),
        .branch_address(branch_address),
        .branch_result(branch_result),
        .prediction(prediction_vector[i])
    );
end
endgenerate

assign prediction = prediction_vector[global_branch_history];

endmodule
