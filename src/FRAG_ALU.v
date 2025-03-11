module FRAG_ALU (
    input              sys_clk      ,
    input              sys_arstn    ,
    input              flag_JorB    ,
    input       [31:0] data_in_0    ,
    input       [31:0] data_in_1    ,
    input       [ 3:0] ALU_ctrl     ,
    output      [31:0] result       ,
    output      [ 1:0] flag_result  ,
    output             hold
);

    wire        eq          ;
    wire        lg          ;
    reg  [31:0] result_temp ;
    wire        start       ;
    reg         start_delay1;
    wire        sign        ;
    reg         hold_temp   ;
    wire        finish      ;
    reg  [31:0] result_div  ;
    wire        sys_rst_n   ;
    wire        div_flag    ;
    wire        start_div   ;
    wire [31:0] q           ;
    wire [31:0] r           ;

    localparam CTRL_AND     =   4'b0000 ;
    localparam CTRL_OR      =   4'b0001 ;
    localparam CTRL_ADD     =   4'b0010 ;
    localparam CTRL_SUB     =   4'b0110 ;
    localparam CTRL_XOR     =   4'b0011 ;
    localparam CTRL_SLL     =   4'b0100 ;
    // localparam CTRL_SRL     =   4'b0101 ;
    // localparam CTRL_SRA     =   4'b0111 ;
    // localparam CTRL_CMPS    =   4'b1000 ;
    // localparam CTRL_CMPU    =   4'b1001 ;
    // localparam CTRL_SLT     =   4'b1010 ;
    // localparam CTRL_SLTU    =   4'b1011 ;
    localparam CTRL_DIV     =   4'b1100 ;   
    localparam CTRL_DIVU    =   4'b1101 ;
    localparam CTRL_REM     =   4'b1110 ;
    localparam CTRL_REMU    =   4'b1111 ;

    assign sys_rst_n = (~flag_JorB) & sys_arstn;
    assign div_flag  = (data_in_1 != 32'h0) & ((ALU_ctrl == CTRL_DIV) | (ALU_ctrl == CTRL_DIVU) | (ALU_ctrl == CTRL_REM) | (ALU_ctrl == CTRL_REMU));

    always @(*) begin
        case(ALU_ctrl)
            CTRL_AND    :   result_temp = data_in_0 & data_in_1                  ;
            CTRL_OR     :   result_temp = data_in_0 | data_in_1                  ;
            CTRL_ADD    :   result_temp = data_in_0 + data_in_1                  ;
            CTRL_SUB    :   result_temp = data_in_0 - data_in_1                  ;
            CTRL_XOR    :   result_temp = data_in_0 ^ data_in_1                  ;
            CTRL_SLL    :   result_temp = data_in_0 << data_in_1[4:0]            ;
            // CTRL_SRL    :   result_temp = $signed(data_in_0) << data_in_1[4:0]   ;
            // CTRL_SRA    :   result_temp = $signed(data_in_0) >> data_in_1[4:0]   ;
            // CTRL_CMPS   :   result_temp = $signed(data_in_0) - $signed(data_in_1);
            // CTRL_CMPU   :   result_temp = data_in_0 - data_in_1                  ;
            // CTRL_SLT    :   result_temp = $signed(data_in_0) - $signed(data_in_1);
            // CTRL_SLTU   :   result_temp = data_in_0 - data_in_1                  ;
            CTRL_DIV    :   result_temp = 32'hffffffff                           ;
            CTRL_DIVU   :   result_temp = 32'hffffffff                           ;
            CTRL_REM    :   result_temp = data_in_0                              ;
            CTRL_REMU   :   result_temp = data_in_0                              ;
            default     :   result_temp = data_in_0 + data_in_1                  ;
        endcase
    end

    always @(*) begin
        if(finish == 1'b1) begin
            case(ALU_ctrl)
                CTRL_DIV    :   result_div = q  ;
                CTRL_DIVU   :   result_div = q  ;
                CTRL_REM    :   result_div = r  ;
                CTRL_REMU   :   result_div = r  ;
            endcase
        end
    end
    
    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            hold_temp <= 1'b0;
        end else if(sys_rst_n == 1'b0) begin
            hold_temp <= 1'b0;
        end else if(start_div == 1'b1) begin
            hold_temp <= 1'b1;
        end else if(finish == 1'b1) begin
            hold_temp <= 1'b0;
        end
    end

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            start_delay1 <= 1'b0;
        end else begin
            start_delay1 <= start;
        end
    end

    assign start_div    = start & (~start_delay1)                                       ;
    assign hold         = (hold_temp | start) & (~finish)                               ;
    assign start        = (div_flag == 1'b1) ? 1'b1 : 1'b0                              ;
    assign sign         = ~ALU_ctrl[0]                                                  ;
    assign eq           = (result_temp == 32'h0)                                        ;
    assign lg           = result_temp[31]                                               ;   
    assign flag_result  = {eq, lg}                                                      ;
    assign result       = (finish == 1'b1) ? result_div : result_temp                   ;
    // assign result = ((ALU_ctrl == CTRL_SLT) || (ALU_ctrl == CTRL_SLTU)) ? {31'b0, lg} : result_temp;
    
    srt_8_div srt_8_div_inst(
        .clk            (sys_clk    )    ,
        .rst_n          (sys_rst_n  )    ,
        .start          (start_div  )    ,
        .dividend_i     (data_in_0  )    ,
        .divisor_i      (data_in_1  )    ,
        .sign_define    (sign       )    ,	
        .quotient_o     (q          )    ,
        .reminder_o     (r          )    ,
        .mulfinish      (finish     )
    );
        
endmodule