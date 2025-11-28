`timescale 1ns/1ps
module mbist_top (CLK, nRESET, MBISTEN, DATA_MBIST, ADDR_MBIST, DATA_DUT, TESTTYPE, iWrite, iRead, RESULT);
    input wire CLK;  
    input wire nRESET;
    input wire MBISTEN;
    output wire [7:0] DATA_MBIST;

    output wire [7:0] ADDR_MBIST;
    wire [3:0] gen_Turn;

    wire [7:0] ExpDATA;
    input wire [7:0] DATA_DUT;
    wire DATA_EN;
    wire ADDR_EN;

    input wire [2:0] TESTTYPE;
    // 3'd0: MSCAN
    // 3'd1: CheckerBoard
    // 3'd2: March-C 

    //Mode Controll SRAM
    output wire iWrite;
    output wire iRead;

    wire ADDR_RST;
    output wire RESULT;


    comparator comparator (
            .CLK(CLK), 
            .nRESET(nRESET), 
            .DATA_comp(DATA_DUT),
            .ExpDATA(ExpDATA),
            .RESULT(RESULT)
    );

    addr_gen addr_gen(
        .CLK(CLK),
        .nRESET(nRESET),
        .ADDR_EN(ADDR_EN),
        .ADDR_RST(ADDR_RST),
        .ADDR_MBIST(ADDR_MBIST), 
        .gen_Turn(gen_Turn),
        .PAT_SEL(TESTTYPE)
        );

    data_gen data_gen(
        .CLK(CLK),
        .nRESET(nRESET),
        .DATA_EN(DATA_EN),
        .gen_Turn(gen_Turn),
        .PAT_SEL(TESTTYPE), 
        .DATA_MBIST(DATA_MBIST),
        .DATA_comp(ExpDATA)
    );   

    control control_unit(
        .CLK(CLK), 
        .nRESET(nRESET), 
        .MBISTEN(MBISTEN),
        .TESTTYPE(TESTTYPE), 
        .iWrite(iWrite),
        .iRead(iRead), 
        .gen_Turn(gen_Turn), 
        .RESULT(RESULT),
        .ADDR_MBIST(ADDR_MBIST),
        .ADDR_EN(ADDR_EN),
        .DATA_EN(DATA_EN),
        .ADDR_RST(ADDR_RST)
        );

endmodule