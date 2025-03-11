module FRAG_JorB_ctrl (
    input       [4:0]   ctrl_JorB   ,
    input       [1:0]   flag_result ,
    output  reg         flag_JorB
);
    
    localparam BEQ      =   3'b000  ;
    localparam BNE      =   3'b001  ;
    // localparam BLT      =   3'b100  ;
    // localparam BGE      =   3'b101  ;
    localparam BLTU     =   3'b110  ;
    localparam BGEU     =   3'b111  ;
    
    always @(*) begin
        if(ctrl_JorB[4] == 1'b1) begin
            flag_JorB = 1'b1;
        end else if(ctrl_JorB[3] == 1'b1) begin
            case(ctrl_JorB[2:0])
                BEQ    : flag_JorB =  flag_result[1];
                BNE    : flag_JorB = ~flag_result[1];
        //         BLT    : flag_JorB =  flag_result[0];
        //         BGE    : flag_JorB = ~flag_result[0];
                BLTU   : flag_JorB =  flag_result[0];
                BGEU   : flag_JorB = ~flag_result[0];
                default: flag_JorB =  flag_result[0];
            endcase
        end else begin
            flag_JorB = 1'b0;
        end  
    end

endmodule