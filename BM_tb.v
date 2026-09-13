`timescale 1ns / 1ps

module Booth_multi_tb;

    reg clk;
    reg rst;
    reg signed [15:0] data_in;

    wire signed [31:0] data_out;
    wire done;

    Booth_multi DUT (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_out(data_out),
        .done(done)
    );

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test
    initial begin
        rst = 1;
        data_in = 16'd0;

        // Reset
        #12;
        rst = 0;

        // First input = multiplicand
        @(negedge clk);
        data_in = -16'd9;

        // Second input = multiplier
        @(negedge clk);
        data_in = 16'd9;

        // Wait for completion
        wait(done == 1);

        #2;

        $display("--------------------------------");
        $display("A       = %d", -9);
        $display("B       = %d", 9);
        $display("Product = %d", $signed(data_out));
        $display("--------------------------------");

        #10;
        $finish;
    end

    // Waveform
    initial begin
        $dumpfile("booth.vcd");
        $dumpvars(0, Booth_multi_tb);
    end

endmodule