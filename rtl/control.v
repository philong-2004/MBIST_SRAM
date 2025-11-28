module control(CLK, 
    nRESET, 
    MBISTEN, 
    TESTTYPE, 
    iWrite, 
    iRead, 
    gen_Turn, 
    RESULT,
    ADDR_MBIST,
    ADDR_EN,
    DATA_EN,
    ADDR_RST);


    input wire CLK;
    input wire nRESET;
    input wire MBISTEN;
    input wire [2:0] TESTTYPE;
    
    output reg [3:0] gen_Turn;
    input wire RESULT;

    output reg iWrite;
    output reg iRead;


    reg [5:0] state;
    reg TEST_DONE;
    output reg ADDR_RST;

    output reg ADDR_EN;
    output reg DATA_EN;
    //bit 0 = DATA_EN;
    //bit 1 = ADDR_EN;
    input wire [7:0] ADDR_MBIST; 


    always @(posedge CLK or negedge nRESET) begin
    if (!nRESET || TEST_DONE) begin
        ADDR_RST <= 0;
        ADDR_EN <= 0;
        DATA_EN <= 0;
        state <= 0;
    end

    else if(MBISTEN) begin
        case (TESTTYPE)
        3'd0: begin //mscan_mode();
            case (state)
                6'd0: begin //idle state;
                    DATA_EN <= 0;
                    ADDR_EN <= 0;
                    TEST_DONE <= 0;
                    DATA_EN <= ~DATA_EN;
                    iWrite <= 1;
                    iRead <= 0; 
                    gen_Turn <= 1;
                    state <= state + 1; 
                   
                end
                        
                6'd1: begin // Write 0 Process
                    if(ADDR_MBIST >= 8'd127) begin
                        iWrite <= 0;
                        iRead <= 0;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        gen_Turn <= gen_Turn + 4'd1;    
                        state <= state + 1;  
                    end       
                    else begin                          
                        ADDR_RST <= 1;  
                        iWrite <= 1;
                        iRead <= 0; 
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN; 
                    end
                end
                6'd2: begin
                        iWrite <= 0;
                        iRead <= 1;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        state <= state + 1;
                
                end
                6'd3: begin
                    if(ADDR_MBIST >= 8'd127) begin
                        iWrite <= 0;
                        iRead <= 0;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        gen_Turn <= gen_Turn + 4'd1;                          
                        state <= state + 1;
                    end
                    else begin
                        iWrite <= 0;
                        iRead <= 1;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN; 

                    end
                end

                6'd4: begin
                        iWrite <= 1;
                        iRead <= 0;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        state <= state + 1;
                
                end                

                6'd5: begin  //Write 1 Process
                    if(ADDR_MBIST >= 8'd127) begin
                        ADDR_EN <= 0;
                        DATA_EN <= 0;
                        iWrite <= 0;
                        iRead <= 0;
                        gen_Turn <= gen_Turn + 4'd1;                        
                        state <= state + 1;
                    end
                    else begin
                        iWrite <= 1;
                        iRead <= 0;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN; 
                    end
                end

                6'd6: begin
                        iWrite <= 0;
                        iRead <= 1;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        state <= state + 1;
                end
                6'd7: begin
                    if(ADDR_MBIST >= 8'd127) begin
                        iWrite <= 0;
                        iRead <= 0;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN; 
                        state <= state + 1;
                    end
                    else begin
                        iWrite <= 0;
                        iRead <= 1;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN; 
                    end
                end

                6'd8: begin
                  TEST_DONE <= 1;
                end

                default: state <= 6'd8; 
            endcase
        end 
        3'd1: begin //checkerboard_mode();
            // state = 4'd0; //Initial Idle state
            case (state)
                6'd0: begin //idle state;
                    DATA_EN <= 1;
                    ADDR_EN <= 0;
                    TEST_DONE <= 0;
                    iWrite <= 1;
                    iRead <= 0; 
                    gen_Turn <= 4'h0;
                    state <= state + 1; 
                   
                end

                6'd1: begin
                        ADDR_RST <= 1;  
                        iWrite <= 1;
                        iRead <= 0;
                        DATA_EN <= ~DATA_EN;
                        gen_Turn <= ~gen_Turn;
                        state <= state + 1;    
                end

                6'd2: begin // Write Process
                    if(ADDR_MBIST >= 8'd127) begin
                        iWrite <= 0;
                        iRead <= 1;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        gen_Turn <= 4'h0;  
                        state <= state + 2;  
                    end       
                    else begin                          
                        ADDR_RST <= 1;  
                        iWrite <= 1;
                        iRead <= 0;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        state <= state + 1;                     
                    end
                end


                6'd3: begin
                    gen_Turn <= ~gen_Turn;
                    ADDR_EN <= ~ADDR_EN;  
                    DATA_EN <= ~DATA_EN;   
                    state <= state - 1;
                end
                
                6'd4: begin // set up read process
                        iWrite <= 0;
                        iRead <= 1;
                        gen_Turn <= ~gen_Turn;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        state <= state + 1;
                end
                6'd5: begin // read process
                    if(ADDR_MBIST >= 8'd127) begin
                        iWrite <= 1;
                        iRead <= 0;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        gen_Turn <= 4'h0;                          
                        state <= state + 2;
                    end
                    else begin
                        iWrite <= 0;
                        iRead <= 1;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        state <= state + 1; 
                    end
                end

                6'd6: begin
                  gen_Turn <= ~gen_Turn;
                  ADDR_EN <= ~ADDR_EN;  
                  DATA_EN <= ~DATA_EN;                     
                  state <= state - 1;
                end

                6'd7: begin //Read 0 Process
                    if(ADDR_MBIST >= 8'd127) begin
                        iWrite <= 0;
                        iRead <= 0;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        gen_Turn <= 4'hf;  
                        state <= state + 2;  
                    end
                    else begin
                        iWrite <= 1;
                        iRead <= 0;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        state <= state + 1;  
                    end
                end

                6'd8: begin
                    gen_Turn <= ~gen_Turn;
                    ADDR_EN <= ~ADDR_EN;  
                    DATA_EN <= ~DATA_EN;   
                    state <= state - 1;
                end

                6'd9: begin
                        iWrite <= 0;
                        iRead <= 1;
                        gen_Turn <= 4'h0;  
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        state <= state + 1;
                end                

                6'd10: begin // Write 0 Process
                    if(ADDR_MBIST >= 8'd127) begin
                        iWrite <= 0;
                        iRead <= 0;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        gen_Turn <= 4'h0;                          
                        state <= state + 2;
                    end
                    else begin
                        iWrite <= 0;
                        iRead <= 1;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        state <= state + 1; 
                    end
                end

                6'd11: begin
                  gen_Turn <= ~gen_Turn;
                  ADDR_EN <= ~ADDR_EN;  
                  DATA_EN <= ~DATA_EN;                     
                  state <= state - 1;
                end                

                6'd12: begin
                    TEST_DONE <= 1;
                end
                default: begin
                    state <= 6'd12;
                end 
                endcase
        end


        3'd2: begin // marchC_mode();
        // state = 4'd0;
            case (state)
                6'd0: begin //idle state;
                    ADDR_EN <= ~ADDR_EN;  
                    DATA_EN <= ~DATA_EN;
                    TEST_DONE <= 0;
                    iWrite <= 1;
                    iRead <= 0; 
                    gen_Turn <= 4'h0;
                    state <= state + 4'd1; 
                end

            // Phase 1: W0 to all addr
                6'd1: begin // Write Process
                    if(ADDR_MBIST >= 8'd127) begin
                        iWrite <= 0;
                        iRead <= 0;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        gen_Turn <= gen_Turn + 1; 
                        state <= state + 4'd1;  
                    end       
                    else begin                          
                        ADDR_RST <= 1;  
                        iWrite <= 1;
                        iRead <= 0;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;                    
                    end
                end



            // Phase 2: R0 if true, W1 in this addr
                6'd2: begin // set up read process
                        iWrite <= 0;
                        iRead <= 1;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        state <= state + 4'd1;
                end

                6'd3: begin // read process
                    if(ADDR_MBIST >= 8'd127) begin
                        iWrite <= 0;
                        iRead <= 0;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        gen_Turn <=gen_Turn + 4'd1;                          
                        state <= state + 4'd3;
                    end
                    else begin
                        // ADDR_EN <= ~ADDR_EN;
                        iWrite <= 0;
                        iRead <= 1;                                                     
                        state <= state + 1;  
                        DATA_EN <= ~DATA_EN; 
                        ADDR_EN <= ~ADDR_EN;                              
                    end
                end


                6'd4: begin //if data = 0, w1 in this addr
                    if (RESULT) begin
                        iWrite <= 1;
                        iRead <= 0; 
                        state <= state + 1;
                        
                    end     
                end
                           
                6'd5: begin //r0 in nxt addr
                        DATA_EN <= ~DATA_EN; 
                        ADDR_EN <= ~ADDR_EN;
                        iWrite <= 0;
                        iRead <= 1;                         
                        state <= state - 2;   
                end

                // phase 3 r1 if true, w0 in this addr
                6'd6: begin // set up read process
                        iWrite <= 1;
                        iRead <= 0;
                        state <= state + 4'd1;
                end

                6'd7: begin // set up read process
                        iWrite <= 0;
                        iRead <= 1;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        state <= state + 4'd1;
                end

                6'd8: begin // read process
                    if(ADDR_MBIST >= 8'd127) begin
                        iWrite <= 0;
                        iRead <= 0;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        gen_Turn <=gen_Turn + 4'd1;                          
                        state <= state + 4'd3;
                    end
                    else begin
                        // ADDR_EN <= ~ADDR_EN;
                        iWrite <= 0;
                        iRead <= 1;                                                     
                        state <= state + 1;  
                        DATA_EN <= ~DATA_EN; 
                        ADDR_EN <= ~ADDR_EN;                                                  
                    end
                end

                6'd9: begin //if data = 1, w0 in this addr
                    if (RESULT) begin
                        iWrite <= 1;
                        iRead <= 0; 
                        state <= state + 1;
                    end                                       
                end
                
                6'd10: begin //r1 in nxt addr
                        DATA_EN <= ~DATA_EN; 
                        ADDR_EN <= ~ADDR_EN;
                        iWrite <= 0;
                        iRead <= 1;                         
                        state <= state - 2;   
                end

                //phase 4: r0 all addr
                6'd11: begin // set up read process
                        iWrite <= 0;
                        iRead <= 1;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        state <= state + 4'd1;
                end

                6'd12: begin // read process
                    if(ADDR_MBIST >= 8'd127) begin
                        iWrite <= 0;
                        iRead <= 0;
                        ADDR_EN <= ~ADDR_EN;  
                        DATA_EN <= ~DATA_EN;
                        gen_Turn <=gen_Turn + 4'd1;                          
                        state <= state + 4'd2;
                    end
                    else begin
                        // ADDR_EN <= ~ADDR_EN;
                        iWrite <= 0;
                        iRead <= 1;                                                     
                        state <= state + 1; 
                        DATA_EN <= ~DATA_EN; 
                        ADDR_EN <= ~ADDR_EN;                                                   
                    end
                end
                
                6'd13: begin
                        DATA_EN <= ~DATA_EN; 
                        ADDR_EN <= ~ADDR_EN;
                        iWrite <= 0;
                        iRead <= 1;                         
                        state <= state - 1;   
                end

                6'd14: begin
                    TEST_DONE <= 1;
                end
                    default: state <= 6'd14;
                endcase
            end
        
        endcase
    end
end


endmodule