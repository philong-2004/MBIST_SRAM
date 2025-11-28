module counter (CLK, nRESET, CNT_EN, state);
    input wire CLK;
    input wire nRESET;
    input wire CNT_EN; 
    output reg [3:0]state;
    
    always @(posedge CLK or negedge nRESET) begin
        if(!nRESET || !CNT_EN) begin
            state <= 4'b0;
        end
        else begin
            state <= state + 4'b1;
        end
    end
endmodule