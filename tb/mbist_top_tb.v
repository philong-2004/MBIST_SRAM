`timescale 1ns/100fs

module mbist_top_tb();
    reg CLK;  
    reg nRESET;
    reg MBISTEN;
    wire iWrite;
    wire iRead;
    wire [7:0] DATA_MBIST;
    wire [7:0] ADDR_MBIST;
    wire [7:0] DATA_DUT;
    reg [2:0] TESTTYPE;
    
mbist_top mbist_top(
  .CLK(CLK), 
  .nRESET(nRESET), 
  .MBISTEN(MBISTEN), 
  .DATA_MBIST(DATA_MBIST), 
  .ADDR_MBIST(ADDR_MBIST), 
  .DATA_DUT(DATA_DUT), 
  .TESTTYPE(TESTTYPE), 
  .iWrite(iWrite), 
  .iRead(iRead), 
  .RESULT(RESULT));

mem DUT (
        .iClk    (CLK),
        .iAddr   (ADDR_MBIST),
        .iWrite  (iWrite),
        .iWrData (DATA_MBIST),
        .iRead   (iRead),
        .oRdData (DATA_DUT)
);


always #5 CLK <= ~CLK;

initial begin
  CLK <=0;
  nRESET <= 0;
  MBISTEN <=0;
end
initial begin
  #1000;
  @(posedge CLK);
  nRESET <= 1; #1;
  MBISTEN <= 1; #1;
  TESTTYPE <= 3'd0; #1; //Mscan
  #30000;
  // TESTTYPE <= 3'd1; #1; //Checkerboard
  // #25000;
  // TESTTYPE <= 3'd2; //MarchC
  // #30000;
  MBISTEN <= 0; #1000;
  $finish;
end


endmodule