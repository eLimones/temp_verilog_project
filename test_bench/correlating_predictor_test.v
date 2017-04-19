`timescale 1ns / 1ps

module correlating_predictor_test;

    // Inputs
    reg clk;
    reg rst;
    reg enable;
    reg [0:0] branch_address;
    reg branch_result;

    // Outputs
    wire prediction;

    // Instantiate the Unit Under Test (UUT)
    correlating_predictor uut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .branch_address(branch_address),
        .branch_result(branch_result),
        .prediction(prediction)
    );

    integer total_branches = 0;
    integer total_hits = 0;
    integer total_misses = 0;
    integer f;
    initial begin
        f = $fopen("results_correlatin_predictor.csv","w");
        // Reset Circuit
        clk = 0;
        rst = 0;
        enable = 1;
        branch_address = 0;
        branch_result = 0;
        #5;
        rst = 1;
        #5;
        rst = 0;
        #5;

        repeat(40)begin
            clk = 0;
            branch_address = 0;
            branch_result = 1;
            #5;
            clk = 1;
            #5;
            $fwrite(f,"B,%b,Predicted,%b,Taken,%b\n",branch_address,prediction,branch_result);
            total_branches = total_branches + 1;
            total_hits = total_hits + $unsigned(prediction~^branch_result);
            total_misses = total_misses + $unsigned(prediction^branch_result);

            repeat(1000) begin
                clk = 0;
                branch_address = 1;
                branch_result = 1;
                #5;
                clk = 1;
                #5;
                $fwrite(f,"B,%b,Predicted,%b,Taken,%b\n",branch_address,prediction,branch_result);
                total_branches = total_branches + 1;
                total_hits = total_hits + $unsigned(prediction~^branch_result);
                total_misses = total_misses + $unsigned(prediction^branch_result);
            end

            clk = 0;
            branch_address = 1;
            branch_result = 0;
            #5;
            clk = 1;
            #5;
            $fwrite(f,"B,%b,Predicted,%b,Taken,%b\n",branch_address,prediction,branch_result);
            total_branches = total_branches + 1;
            total_hits = total_hits + $unsigned(prediction~^branch_result);
            total_misses = total_misses + $unsigned(prediction^branch_result);
        end

        clk = 0;
        branch_address = 0;
        branch_result = 0;
        #5;
        clk = 1;
        #5;
        $fwrite(f,"B,%b,Predicted,%b,Taken,%b\n",branch_address,prediction,branch_result);
        total_branches = total_branches + 1;
        total_hits = total_hits + $unsigned(prediction~^branch_result);
        total_misses = total_misses + $unsigned(prediction^branch_result);

        //Display resltus
        $display("Total branches: %d", total_branches);
        $display("Total hits: %d", total_hits);
        $display("Total misses: %d", total_misses);
        $fclose(f);
        $finish;
    end

endmodule

