module FRAG_ALU_ctrl (
    input       [1:0]   ALUOp   ,
    input               funct7_5,
    input       [2:0]   funct3  ,
    output  reg [3:0]   ALU_ctrl
);

    localparam OP_ADD       =   2'b00   ; 
    localparam OP_SUB       =   2'b01   ;
    localparam OP_TBD       =   2'b10   ;
    // localparam OP_CMP       =   2'b11   ;
    localparam OP_DIV       =   2'b11   ;
            
    localparam ADD_SUB      =   3'b000  ;
    localparam SLL          =   3'b001  ;
    // localparam SLT          =   3'b010  ;
    // localparam SLTU         =   3'b011  ;
    localparam XOR          =   3'b100  ;
    // localparam SRL_SRA      =   3'b101  ;
    localparam OR           =   3'b110  ;
    localparam AND          =   3'b111  ;
        
    localparam BEQ          =   3'b000  ;
    localparam BNE          =   3'b001  ;
    // localparam BLT          =   3'b100  ;
    // localparam BGE          =   3'b101  ;
    localparam BLTU         =   3'b110  ;
    localparam BGEU         =   3'b111  ;

    localparam DIV          =   3'b100  ;
    localparam DIVU         =   3'b101  ;
    localparam REM          =   3'b110  ;
    localparam REMU         =   3'b111  ;
            
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

    
    always @(*) begin
        case(ALUOp)
            OP_ADD  : ALU_ctrl = CTRL_ADD;
            OP_SUB  : ALU_ctrl = CTRL_SUB;
            OP_TBD  : case(funct3)
                          ADD_SUB   : ALU_ctrl = (funct7_5 == 1'b0) ? CTRL_ADD : CTRL_SUB   ;
                          SLL       : ALU_ctrl = CTRL_SLL                                   ;
                        //   SLT       : ALU_ctrl = CTRL_SLT                                   ;
                        //   SLTU      : ALU_ctrl = CTRL_SLTU                                  ;
                          XOR       : ALU_ctrl = CTRL_XOR                                   ;
                        //   SRL_SRA   : ALU_ctrl = (funct7_5 == 1'b0) ? CTRL_SRL : CTRL_SRA   ;
                          OR        : ALU_ctrl = CTRL_OR                                    ;
                          AND       : ALU_ctrl = CTRL_AND                                   ;
                          default   : ALU_ctrl = 4'b0000                                    ;
                      endcase
            // OP_CMP  : case(funct3)
            //               BEQ       : ALU_ctrl = CTRL_CMPS  ;
            //               BNE       : ALU_ctrl = CTRL_CMPS  ;
            //               BLT       : ALU_ctrl = CTRL_CMPS  ;
            //               BGE       : ALU_ctrl = CTRL_CMPS  ;
            //               BLTU      : ALU_ctrl = CTRL_CMPU  ;
            //               BGEU      : ALU_ctrl = CTRL_CMPU  ;
            //               default   : ALU_ctrl = 4'b0000    ;
            //           endcase
            OP_DIV  : case(funct3)
                          DIV       : ALU_ctrl = CTRL_DIV                                   ;
                          DIVU      : ALU_ctrl = CTRL_DIVU                                  ;
                          REM       : ALU_ctrl = CTRL_REM                                   ;
                          REMU      : ALU_ctrl = CTRL_REMU                                  ;
                          default   : ALU_ctrl = 4'b0000                                    ;
                      endcase
            default : ALU_ctrl = 4'b0000 ;
        endcase
    end

endmodule