`timescale 1ns / 1ps

module tb_gray_code_counter;

    // Testbench Signals
    reg        clk;
    reg        rst_n;
    reg        en;
    wire [2:0] gray_out;

    // Instantiate Unit Under Test (UUT)
    gray_code_counter uut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .gray_out(gray_out)
    );

    // Clock Generation: 100 MHz (10ns period)
    always #5 clk = ~clk;

    // Real-Time Console Output Monitor
    initial begin
        $display("\n==============================================");
        $display(" TIME(ns) | RST_N | EN | GRAY_OUT (Bin) | DEC ");
        $display("==============================================");
        $monitor("%8t |   %b   | %b  |      %b       |  %d  ", 
                 $time, rst_n, en, gray_out, gray_out);
    end

    // Test Sequence
    initial begin
        // Waveform Dumping Setup
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_gray_code_counter);

        // 1. Initialize Inputs
        clk   = 0;
        rst_n = 0;
        en    = 0;

        // 2. Apply Reset
        #15;
        rst_n = 1; // Release reset
        #10;

        // ---------------------------------------------------------------------
        // TEST CASE 1: Enable Counter and Cycle Through Full Sequence
        // ---------------------------------------------------------------------
        $display("\n---> TEST CASE 1: Enabling Counter (Cycling through full sequence)");
        @(posedge clk);
        en <= 1;

        // Run for 10 clock cycles (covers 000 -> 100 -> 000 wrap-around)
        repeat (10) @(posedge clk);

        // ---------------------------------------------------------------------
        // TEST CASE 2: Disable Counter (Verify State Hold)
        // ---------------------------------------------------------------------
        $display("\n---> TEST CASE 2: Disabling Counter (Testing Enable Hold)");
        en <= 0;
        repeat (3) @(posedge clk);

        // ---------------------------------------------------------------------
        // TEST CASE 3: Re-enable Counter
        // ---------------------------------------------------------------------
        $display("\n---> TEST CASE 3: Re-enabling Counter");
        en <= 1;
        repeat (3) @(posedge clk);

        // ---------------------------------------------------------------------
        // TEST CASE 4: Asynchronous Reset During Operation
        // ---------------------------------------------------------------------
        $display("\n---> TEST CASE 4: Triggering Mid-Operation Reset");
        #2; // Trigger reset off-edge
        rst_n <= 0;
        #10;
        rst_n <= 1;
        repeat (2) @(posedge clk);

        // Finish Simulation
        #20;
        $display("\n==============================================");
        $display("SIMULATION COMPLETE");
        $display("==============================================\n");
        $finish;
    end

endmodule
