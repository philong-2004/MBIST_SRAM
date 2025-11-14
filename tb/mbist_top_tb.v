`timescale 1ns/1ps

module mbist_top_tb();
    reg CLK;  
    reg nRESET;
    reg MBISTEN;
    wire [7:0] ADDR_top;
    wire [7:0] DATAOUT;
    wire [3:0] gen_Turn;
    wire iWrite;
    wire iRead;
    wire RESULT;

    wire [7:0] DATA_DUT;
    reg [2:0] TESTTYPE;
    
    mbist_top dut (
        .CLK(CLK), 
        .nRESET(nRESET), 
        .MBISTEN(MBISTEN),
        .DATAOUT(DATAOUT), 
        .ADDR_top(ADDR_top), 
        .DATA_DUT(DATA_DUT), 
        .TESTTYPE(TESTTYPE), 
        .iWrite(iWrite), 
        .iRead(iRead),
        .gen_Turn(gen_Turn),
        .RESULT(RESULT)
    );

mem DUT (
        .iClk    (CLK),
        .iAddr   (ADDR_top),
        .iWrite  (iWrite),
        .iWrData (DATAOUT),
        .iRead   (iRead),
        .oRdData (DATA_DUT)
);


always #10 CLK <= ~CLK;

initial begin
  CLK <=0;
  nRESET <= 0;
  MBISTEN <=0;
  TESTTYPE <= 3'd0;
end
initial begin
  #1000;
  nRESET <= 1; #1;
  MBISTEN <= 1; #1;
  // TESTTYPE <= 3'd0; #1;
  // #10000;
  // TESTTYPE <= 3'd1; #1;
  // #10000;
  TESTTYPE <= 3'd2; 
  // #30000;
  MBISTEN <= 0; #1000;
  $finish;
end


endmodule