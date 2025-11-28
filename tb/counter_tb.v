module counter_tb ();
    reg CLK;
    reg nRESET;
    wire [3:0] state;
    counter dut(
        .CLK(CLK),
        .nRESET(nRESET),
        .state(state)
    );

    initial begin
        CLK = 0;
        nRESET = 0;
    end

    always #10 CLK = ~ CLK;
    initial begin
        #1000;
        nRESET = 1;
        #10000;
        nRESET = 0;
        $finish;
    end

endmodule