module comparator (CLK, nRESET, DATA_comp, ExpDATA, RESULT);
    input wire CLK;
    input wire nRESET;
    input wire [7:0] DATA_comp;
    input wire [7:0] ExpDATA;
    
    output reg RESULT;


    always @(posedge CLK or negedge nRESET) begin
      if (DATA_comp == ExpDATA) begin
            RESULT <= 1'b1;
      end
      else if (DATA_comp != ExpDATA) begin
            RESULT <= 1'b0;
      end
    end

endmodule