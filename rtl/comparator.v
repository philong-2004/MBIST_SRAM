module comparator (CLK, nRESET, DATA_comp, ExpDATA, RESULT);
    input wire CLK;
    input wire nRESET;
    input wire [7:0] DATA_comp;
    input wire [7:0] ExpDATA;
    
    output reg RESULT;

    wire compare;  
    

    reg [7:0] d0;

    always @(posedge CLK or negedge nRESET) begin
      if (!nRESET) begin 
        d0 <= 8'hzz;
      end
      else begin
        d0 <= ExpDATA;
      end
    end

    assign compare = (DATA_comp == d0) ? 1'b1 : 1'b0;
    always @(posedge CLK or negedge nRESET) begin
            RESULT <= compare;
    end
    
endmodule