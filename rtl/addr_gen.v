// `timescale 1ns/1ps
module addr_gen(CLK, nRESET, ADDR_EN, ADDR, ADDR_done, gen_Turn, PAT_SEL);
    input wire CLK;
    input wire nRESET;
    input wire ADDR_EN;
    input wire [3:0] gen_Turn;
    input wire [2:0] PAT_SEL;
    output reg [7:0] ADDR;
    output reg ADDR_done;


    always @(posedge CLK or negedge nRESET) begin
        if (!nRESET) begin
            ADDR <= 0;
            ADDR_done <= 0;
        end 
        // ---- Dang viet khuc nay-------
        //Dang set mode sinh dia chi
        else if (ADDR_EN) begin
            case (PAT_SEL)
                // Addr for MSCAN
                3'd0: begin 
                    if (ADDR == 8'd127) begin
                        ADDR_done <= 1; //done 
                        ADDR <= 8'd0; 
                        @(posedge CLK);
                        ADDR_done <= 0;
                    end
                    else begin
                        ADDR <= ADDR + 8'd1;
                    end
                end
                
                // Addr for Checkerboard
                3'd1: begin 
                    if (ADDR == 8'd127) begin
                        ADDR_done <= 1; //done 
                        ADDR <= 8'd0;
                        @(posedge CLK);
                        ADDR_done <= 0;
                    end
                    else begin
                        ADDR <= ADDR + 8'd1;
                    end
                end 

                // Addr for MarchC
                3'd2: begin
                    if (gen_Turn < 4'd3) begin
                        if(ADDR == 8'd127) begin
                            ADDR_done <= 1;
                            ADDR <= 8'd0;
                            @(posedge CLK);
                            ADDR_done <= 0;
                        end
                        else begin 
                            ADDR <= ADDR + 1;
                            @(posedge CLK);
                        end
                    end

                    if (gen_Turn == 4'd3) begin
                        if(ADDR == 8'd127) begin
                            ADDR_done <= 1;
                            @(posedge CLK);
                            ADDR_done <= 0;
                        end
                        else begin 
                            ADDR <= ADDR + 1;
                        end
                    end

                    else if (gen_Turn > 4'd3) begin
                        if(ADDR == 0) begin
                            ADDR_done <= 1;
                            ADDR <= 8'd127;
                            @(posedge CLK);
                            ADDR_done <= 0;
                        end
                        else begin
                            ADDR <= ADDR - 7'd1;
                            @(posedge CLK);
                        end
                    end
                end

                //Initial Add_Gen
                3'd3: begin 
                    ADDR <= 0;
                    ADDR_done <= 0;
                end

                // default
                default: begin 
                    ADDR <= 0;
                    ADDR_done <= 0;
                end
            endcase
        end
        else begin
          ADDR <= 0;
          ADDR_done <= 0;
        end
    end

endmodule

