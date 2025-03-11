module FRAG_imm_gen (
    input       [31: 0]  inst_data,
    output reg  [31: 0]  imm
);
    
    localparam R_M      = 7'b0110011;
    localparam I        = 7'b0010011;
    localparam L        = 7'b0000011;
    localparam S        = 7'b0100011;
    localparam JAL      = 7'b1101111;
    localparam JALR     = 7'b1100111;
    localparam B        = 7'b1100011;
    localparam LUI      = 7'b0110111;
    localparam AUIPC    = 7'b0010111;
    
    
    always @(*) begin
        case(inst_data[6:0])
            R_M    : imm = 32'h0                                                                         ;
            I      : imm = {{20{inst_data[31]}}, inst_data[31:20]}                                       ;
            L      : imm = {{20{inst_data[31]}}, inst_data[31:20]}                                       ;
            S      : imm = {{20{inst_data[31]}}, inst_data[31:25], inst_data[11:7]}                      ;
            JAL    : imm = {{12{inst_data[31]}}, inst_data[19:12], inst_data[20], inst_data[30:21], 1'b0};
            JALR   : imm = {{20{inst_data[31]}}, inst_data[31:20]}                                       ;
            B      : imm = {{20{inst_data[31]}}, inst_data[7], inst_data[30:25], inst_data[11:8], 1'b0}  ;
            LUI    : imm = {inst_data[31:12], 12'h0}                                                     ;
            AUIPC  : imm = {inst_data[31:12], 12'h0}                                                     ;
            default: imm = 32'h0                                                                         ;
        endcase
    end

endmodule