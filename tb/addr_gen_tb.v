`timescale 10ns/1ps

module addr_gen_tb ();
    reg CLK;
    reg nRESET;
    reg MBISTEN;
    wire [6:0] ADDR_top;
    wire ADDR_done;

    addr_gen dut (
        .CLK(CLK),
        .nRESET(nRESET),
        .MBISTEN(MBISTEN),
        .ADDR(ADDR),
        .ADDR_done(ADDR_done)
    );

    always #20 CLK <= ~CLK;

    initial begin
        CLK = 0;
        MBISTEN = 0;
        nRESET = 0;
    end

    initial begin
        #100; 
        nRESET = 1; #5;
        MBISTEN = 1;
        @(posedge ADDR_done);
        #100;
        $display ("Simulation done!");
        $finish;

    end



endmodule

