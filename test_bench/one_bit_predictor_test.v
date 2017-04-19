`timescale 1ns / 1ps

module one_bit_predictor_test;

    // Inputs
    reg clk;
    reg rst;
    reg [0:0] branch_address;
    reg branch_result;

    // Outputs
    wire prediction;

    // Instantiate the Unit Under Test (UUT)
    one_bit_predictor uut (
        .clk(clk),
        .rst(rst),
        .branch_address(branch_address),
        .branch_result(branch_result),
        .prediction(prediction)
    );

    initial begin
        // Reset Circuit
        clk = 0;
        rst = 0;
        branch_address = 0;
        branch_result = 0;
        #5;
        rst = 1;
        #5;
        rst = 0;
        #5;
        
        repeat(10) begin
            clk = 0;
            branch_address = 0;
            branch_result = 1;
            #5;
            clk = 1;
            branch_address = 0;
            branch_result = 1;
            #5;
        end
        // Add stimulus here
    end

endmodule

