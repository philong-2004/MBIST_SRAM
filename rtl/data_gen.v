module data_gen (CLK, nRESET, DATA_EN, gen_Turn, PAT_SEL, DATA_MBIST, DATA_comp);
    input wire CLK;
    input wire nRESET;
    input wire DATA_EN;
    input wire [3:0] gen_Turn;
    input wire [2:0] PAT_SEL;
    output reg [7:0] DATA_MBIST;
    output reg [7:0] DATA_comp;


    always @(posedge DATA_EN or negedge nRESET) begin
      if(!nRESET) begin
          DATA_MBIST <= 8'hzz;
      end
      else begin
      case (PAT_SEL)
          3'd0: begin //MSCAN mode
              if(gen_Turn == 4'd1) begin
                DATA_MBIST <= 8'h00;
                DATA_comp <= 8'h00;
              end 
              else if(gen_Turn == 4'd3) begin
                DATA_MBIST <= 8'hff;
                DATA_comp <= 8'hff;
              end
          end 

          3'd1: begin // checker board
            case (gen_Turn)
              4'h0: begin
                DATA_MBIST <= 8'b01010101;
                DATA_comp <= 8'b01010101;
              end
              4'hf: begin
                DATA_MBIST <= 8'b10101010;
                DATA_comp <= 8'b10101010;
              end
            endcase
          end

          3'd2: begin // march C
            if (gen_Turn == 4'd0 || gen_Turn == 4'd2 || gen_Turn == 4'd4) begin
              DATA_MBIST <= 8'h00;
              DATA_comp <= 8'hff;              
            end 
            else if (gen_Turn == 4'd1 || gen_Turn == 4'd3 || gen_Turn == 4'd5)begin
              DATA_MBIST <= 8'hff;
              DATA_comp <= 8'h00;
            end
          end

          3'd3: DATA_MBIST <= 8'hz;

              default: DATA_MBIST <= 8'hz;
          endcase     
      end 
    end
     
endmodule