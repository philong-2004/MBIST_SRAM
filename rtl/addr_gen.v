// `timescale 1ns/1ps
module addr_gen(CLK, nRESET, ADDR_EN, ADDR_RST ,ADDR_MBIST, gen_Turn, PAT_SEL);
    input wire CLK;
    input wire nRESET;
    input wire ADDR_EN;
    input wire [3:0] gen_Turn;
    input wire [2:0] PAT_SEL;
    input wire ADDR_RST;
    output reg [7:0] ADDR_MBIST;

    always @(posedge ADDR_EN or negedge nRESET) begin
        if(!ADDR_RST || !nRESET) begin
          ADDR_MBIST <= 8'h00;
        end
        else begin
                case (PAT_SEL)
                // Addr_MBIST for MSCAN
                3'd0: begin
                    if (ADDR_MBIST >= 8'd127)
                    begin
                      ADDR_MBIST <= 0;
                    end
                    else                            
                    ADDR_MBIST <= ADDR_MBIST + 1;
                end
                
                // Addr_MBIST for Checkerboard
                3'd1: begin
                    if (ADDR_MBIST >= 8'd127)
                    begin
                      ADDR_MBIST <= 0;
                    end
                    else                            
                    ADDR_MBIST <= ADDR_MBIST + 1;
                end

                // Addr_MBIST for MarchC
                3'd2: begin
                    if (gen_Turn <= 4'd3) begin
                        if(ADDR_MBIST >= 8'd127) begin
                            ADDR_MBIST <= 8'd0;
                        end
                        else begin 
                            ADDR_MBIST <= ADDR_MBIST + 8'd1;
                        end
                    end   
                    
                    else if (gen_Turn > 4'd3) begin
                        if(ADDR_MBIST == 0) begin
                            ADDR_MBIST <= 8'd127;
                        end
                        else begin
                            ADDR_MBIST <= ADDR_MBIST - 8'd1;
                        end
                    end
                end

                //Initial Add_Gen
                3'd3: begin 
                    ADDR_MBIST <= 0;
                end

                // default
                default: begin 
                    ADDR_MBIST <= 0;
                end
            endcase
        end
    end


endmodule

