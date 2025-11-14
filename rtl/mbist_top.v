`timescale 1ns/1ps
module mbist_top (CLK, nRESET, MBISTEN, DATAOUT, ADDR_top, DATA_DUT, TESTTYPE, iWrite, iRead, gen_Turn, RESULT);
    input wire CLK;  
    input wire nRESET;
    input wire MBISTEN;
    output reg [7:0] ADDR_top;
    output reg [7:0] DATAOUT;
    output reg [3:0] gen_Turn;

    input wire [7:0] DATA_DUT;
    reg [7:0] DATA_comp;
    reg [7:0] ExpDATA;
    reg ADDR_done;
    reg DATA_EN;
    reg ADDR_EN;

    input wire [2:0] TESTTYPE;
    // 3'd0: MSCAN
    // 3'd1: CheckerBoard
    // 3'd2: March-C 

    //Mode Controll SRAM
    output reg iWrite;
    output reg iRead;

    
    wire [7:0] ADDR_MBIST;
    wire [7:0] DATA_MBIST;

    output reg RESULT;

    reg [3:0] state;
    
    comparator comparator (
            .CLK(CLK),
            .nRESET(nRESET),
            .DATA_comp(DATA_comp),
            .ExpDATA(ExpDATA),
            .RESULT(RESULT)
    );


    addr_gen addr_gen(
        .CLK(CLK), 
        .nRESET(nRESET), 
        .ADDR_EN(ADDR_EN), 
        .ADDR(ADDR_MBIST), 
        .ADDR_done(ADDR_done),
        .gen_Turn(gen_Turn),
        .PAT_SEL(TESTTYPE));

    data_gen data_gen(
        .CLK(CLK), 
        .nRESET(nRESET), 
        .DATA_EN(DATA_EN), 
        .gen_Turn(gen_Turn),
        .PAT_SEL(TESTTYPE), 
        .DATAOUT(DATA_MBIST)
    );

    initial begin
        state <= 4'd0;
    end

    always @(posedge CLK or negedge nRESET) begin
        if(MBISTEN) begin
          case (TESTTYPE)
            3'd0: begin //mscan_mode();
                    case (state)
                        4'd0: begin //idle state
                            //wait to be selected
                            gen_Turn <= 4'd1;
                            ADDR_EN <= 1'b1;
                            DATA_EN <= 1'b1;
                            state <= state + 4'd1; #1;
                        end

                        4'd1: begin //Write process
                            if(~ADDR_done)begin
                                iWrite <= 1;#1;
                                iRead <= 0; #1;
                                ADDR_top <= ADDR_MBIST; #1
                                DATAOUT <= DATA_MBIST; #1;
                            end
                            else if(ADDR_done) begin
                                gen_Turn <= gen_Turn +4'd1;
                                state <= state + 4'd1;
                            end
                        end
                        
                        4'd2: begin //Read Process
                            if(~ADDR_done) begin
                                iWrite <= 0; #1;
                                iRead <= 1; #1;
                                ADDR_top <= ADDR_MBIST; #1
                                DATA_comp <= DATA_DUT; #1
                                ExpDATA <= DATA_MBIST;#1;
                                
                            end
                            else if(ADDR_done)begin
                                gen_Turn <= gen_Turn + 4'd1;
                                state <= state + 4'd1;
                            end
                        end

                        4'd3: begin
                        if(~ADDR_done)begin
                            iRead <= 0; #1;
                            iWrite <= 1; #1;
                            ADDR_top <= ADDR_MBIST; #1;
                            DATAOUT <= DATA_MBIST;  #1;
                            end
                            else if(ADDR_done) begin
                                gen_Turn <= gen_Turn +4'd1;
                                state <= state + 4'd1;
                            end
                        end

                        4'd4: begin
                            if(~ADDR_done) begin
                                iWrite <= 0; #1;
                                iRead <= 1; #1;
                                ADDR_top <= ADDR_MBIST; #1
                                DATA_comp <= DATA_DUT; #1
                                ExpDATA <= DATA_MBIST; #1; 
                            end
                            else if(ADDR_done)begin
                                state <= state + 4'd1;
                            end
                        end

                        4'd5: begin //stop CheckerBoard test, back to Idle 
                            DATA_EN <= 1'b0;
                            ADDR_EN <= 1'b0;
                            state <= 4'd0;
                        end

                        default: state <= 4'd0; 
                    endcase
                
                end 
            3'd1: begin //checkerboard_mode();
                // state = 4'd0; //Initial Idle state
                
                case (state)
                    4'd0: begin //idle state
                        //wait to be selected 
                        gen_Turn <= 4'd1;
                        DATA_EN <= 1'b1;
                        ADDR_EN <= 1'b1;
                        state <= state + 4'd1;
                    end
                    3'd1:  begin //Write 0 process
                        if(~ADDR_done) begin
                            iWrite <= 1; #1;
                            iRead <= 0; #1;
                            ADDR_top <= ADDR_MBIST; #1
                            DATAOUT <= DATA_MBIST; #1;
                        end
                        else if(ADDR_done)begin
                            gen_Turn <= gen_Turn +4'd1;
                            state <= state + 4'd1;
                        end
                    end
                    4'd2: begin //Read 0 Process
                        if(~ADDR_done) begin
                            iWrite <=0; #1
                            iRead <= 1; #1
                            ADDR_top <= ADDR_MBIST; #1
                            DATA_comp <= DATA_DUT; #1;
                            ExpDATA <= DATA_MBIST; #1;

                        end
                        else if(ADDR_done)begin
                            gen_Turn <= gen_Turn + 4'd1;
                            state <= state + 4'd1;
                        end
                    end
                    4'd3: begin //Write 1 Process
                    if(~ADDR_done) begin
                            iRead <= 0; #1;
                            iWrite <= 1; #1;
                            ADDR_top <= ADDR_MBIST; #1
                            DATAOUT <= DATA_MBIST; #1;
                        end
                        else if(ADDR_done)begin
                            gen_Turn <= gen_Turn + 4'd1;
                            state <= state + 4'd1;
                        end
                    end
                    4'd4: begin //Read 1 Process
                        if(~ADDR_done) begin
                            iWrite <= 0; #1;
                            iRead <= 1; #1;
                            ADDR_top <= ADDR_MBIST; #1
                            DATA_comp <= DATA_DUT; #1
                            ExpDATA <= DATA_MBIST;#1;
                        end
                        else if(ADDR_done)begin
                            state <= state + 4'd1;
                        end
                    end
                    4'd5: begin //stop MSCAN test, back to Idle 
                        DATA_EN <= 1'b0;
                        ADDR_EN <= 1'b0;
                        state <= 4'd0;
                    end
                    default: begin
                        state <= 4'd0;
                    end 
                    endcase
                
            end
            3'd2: begin // marchC_mode();
            // state = 4'd0;
            
            case (state)
                4'd0: begin
                    //wait to be selected
                    gen_Turn <= 4'd1;
                    DATA_EN <= 1'b1;
                    ADDR_EN <= 1'b1;
                    state <= state + 3'd1;
                end 

                // Phase 1: W0 from low addr_ADDR_top to high addr
                4'd1:begin 
                    if (~ADDR_done) begin
                        iWrite <= 1; #1;
                        iRead <= 0; #1;
                        ADDR_top <= ADDR_MBIST; #1
                        DATAOUT <= DATA_MBIST; #1;
                    end
                    else if (ADDR_done) begin
                        gen_Turn <= gen_Turn + 4'd1;
                        state <= state + 3'd1;
                    end    
                end
                
                // Phase 2: R0 then W1 from low addr_ADDR_top to high addr
                4'd2: begin
                    if (~ADDR_done) begin
                        iRead <= 1; #1;
                        iWrite <= 0; #1;
                        ADDR_top <= ADDR_MBIST; #1
                        DATA_comp <= DATA_DUT; #1
                        ExpDATA <= 8'h00; #1;
                        if (RESULT == 1) begin
                            iRead <= 0; #1;
                            iWrite <= 1; #1;
                            DATAOUT <= DATA_MBIST;  #1;
                        end
                        // else state <= 4'd7; //break if DATA read isn't equal 0;
                    end
                    else if (ADDR_done) begin
                    gen_Turn <= gen_Turn +4'd1;
                    state <= state + 3'd1;
                    end
                end

                // Phase 3: R1 then W0 from low Addr to high Addr
                4'd3: begin
                    if (~ADDR_done) begin
                        iRead <= 1;#1;
                        iWrite <= 0; #1;
                        ADDR_top <= ADDR_MBIST; #1
                        DATA_comp <= DATA_DUT; #1
                        ExpDATA <= 8'h01; #1;
                        if (RESULT == 1) begin
                        iRead <= 0; #1;
                        iWrite <= 1; #1;
                        DATAOUT <= DATA_MBIST;#1; 
                        end
                        // else state <= 4'd7; //break if DATA read isn't equal 1;
                    end
                    else if (ADDR_done) begin
                    gen_Turn <= gen_Turn + 4'd1; 
                    state <= state + 4'd1;
                    end
                end

                // Phase 4 R0 then W1 from high addr_ADDR_top to low addr
                4'd4: begin
                    if (~ADDR_done) begin
                        iWrite <= 0; #1;
                        iRead <= 1; #1;
                        ADDR_top <= ADDR_MBIST; #1
                        DATA_comp <= DATA_DUT; #1
                        ExpDATA <= 8'h00; #1;
                        if (RESULT == 1) begin
                            iRead <= 0; #1;
                            iWrite <= 1; #1;
                            DATAOUT <= DATA_MBIST; #1;
                        end
                        // else state <= 4'd7; //break if DATA read isn't equal 0;
                    end
                    else if (ADDR_done) begin
                    gen_Turn <= gen_Turn + 4'd1; 
                    state <= state + 4'd1;
                    end
                end

                // Phase 5: R1 then W0 from high addr_ADDR_top to lo addr
                4'd5: begin
                    if (~ADDR_done) begin
                        iWrite <= 0; #1;
                        iRead <= 1; #1;
                        ADDR_top <= ADDR_MBIST; #1
                        DATA_comp <= DATA_DUT; #1
                        ExpDATA <= 8'h01; #1;
                        if (RESULT == 1) begin
                        iRead <= 0; #1;
                        iWrite <= 1; #1
                        DATAOUT <= DATA_MBIST;#1;
                        end
                        // else state <= 4'd7; //break if DATA read isn't equal 1;
                    end
                    else if (ADDR_done) begin
                    gen_Turn <= gen_Turn + 4'd1; 
                    state <= state + 4'd1;
                    end
                end

                // Phase 6: Read 0 from high addr_ADDR_top to low addr
                4'd6: begin
                    if (~ADDR_done) begin
                    iRead <= 1; #1;
                    ADDR_top <= ADDR_MBIST; #1
                    DATA_comp <= DATA_DUT; #1;
                    end
                    else if (ADDR_done) begin
                    gen_Turn <= gen_Turn + 4'd1; 
                    state <= state + 4'd1;
                    end
                end

                4'd7: begin
                    ADDR_EN <= 1'b0;
                    DATA_EN <= 1'b0;
                    state <= 4'd0;
                end
                
                default: state <= 4'd0;
                endcase
                end
            
          endcase
        end
    end


    // task checkerboard_mode ();
        
    // endtask


    // task mscan_mode(); //MSCAN Algorithm
        
    // endtask

    // task marchC_mode ();
        

    // endtask


endmodule