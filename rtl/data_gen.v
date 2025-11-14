module data_gen (CLK, nRESET, DATA_EN, gen_Turn, PAT_SEL, DATAOUT);
    input wire CLK;
    input wire nRESET;
    input wire DATA_EN;
    input wire [3:0] gen_Turn;
    input wire [2:0] PAT_SEL;
    output reg [7:0] DATAOUT;

    reg [7:0] data_rand;

    always @(posedge CLK or negedge nRESET) begin
      if (!nRESET) begin
            DATAOUT <= 0; //Default Value
      end
      else if(DATA_EN) begin
        case (PAT_SEL)
          3'd0: begin //MSCAN mode
              if(gen_Turn == 4'd1) begin
                DATAOUT <= 8'h00;
              end 
              else if(gen_Turn == 4'd3) begin
                DATAOUT <= 8'h01;
              end
          end 
          3'd1: begin // checker board
            if (gen_Turn < 4'd3) begin
              DATAOUT <= 8'b10101010;
              @(posedge CLK);
              DATAOUT <= ~DATAOUT;
            end
            else if (gen_Turn >= 4'd3)begin
              DATAOUT <= 8'b01010101;
              @(posedge CLK);
              DATAOUT <= ~DATAOUT;
            end
          end

          3'd2: begin // march C
            if (gen_Turn == 4'd1 || gen_Turn == 4'd3 || gen_Turn == 4'd5) begin
              DATAOUT <= 8'b00000000;
            end 
            else if (gen_Turn == 4'd2 || gen_Turn == 4'd4)begin
              DATAOUT <= 8'b00000001;
            end
          end

          3'd3: DATAOUT <= 8'hz;

          default: DATAOUT <= 8'hz;
        endcase
      end
    end


endmodule