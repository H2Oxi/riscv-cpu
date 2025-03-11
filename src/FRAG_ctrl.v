module FRAG_ctrl (
    input       [ 6:0]  opcode  ,
    input       [ 2:0]  funct3  ,
    input               funct7_0,
    output  reg [20:0]  ctrl
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

    // reg [1:0]   ALUOp       ;
    // reg [1:0]   ALUSrc      ;
    // reg [1:0]   JumpBranch  ;
    // reg [2:0]   BranchType  ;
    // reg         MemRead     ;
    // reg [2:0]   LoadType    ;
    // reg         MemWrite    ;
    // reg [2:0]   StoreType   ;
    // reg [1:0]   Inst        ;
    // reg         RegWrite    ;
    // reg         MemtoReg    ;
    
    always @(*) begin
        case(opcode)
            // R_M      : ctrl = (funct7_0 == 1'b0) ? {2'b00, 2'b00, 2'b00, 3'b000, 1'b0, 3'b000, 1'b0, 3'b000, 2'b00, 2'b10} : 
            //                                         {2'b11, 2'b00, 2'b00, 3'b000, 1'b0, 3'b000, 1'b0, 3'b000, 2'b00, 2'b10}; 
            R_M      : ctrl = (funct7_0 == 1'b0) ? {2'b10, 2'b00, 2'b00, 3'b000, 1'b0, 3'b000, 1'b0, 3'b000, 2'b00, 2'b10} : 
                                                    {2'b11, 2'b00, 2'b00, 3'b000, 1'b0, 3'b000, 1'b0, 3'b000, 2'b00, 2'b10}; 
            // I      : ctrl = {2'b00, 2'b01, 2'b00, 3'b000, 1'b0, 3'b000, 1'b0, 3'b000, 2'b00, 2'b10}; 
            I      : ctrl = {2'b10, 2'b01, 2'b00, 3'b000, 1'b0, 3'b000, 1'b0, 3'b000, 2'b00, 2'b10}; 
            L      : ctrl = {2'b00, 2'b01, 2'b00, 3'b000, 1'b1, funct3, 1'b0, 3'b000, 2'b00, 2'b11}; 
            S      : ctrl = {2'b00, 2'b01, 2'b00, 3'b000, 1'b0, 3'b000, 1'b1, funct3, 2'b00, 2'b00}; 
            JAL    : ctrl = {2'b00, 2'b11, 2'b10, 3'b000, 1'b0, 3'b000, 1'b0, 3'b000, 2'b10, 2'b10}; 
            JALR   : ctrl = {2'b00, 2'b01, 2'b10, 3'b000, 1'b0, 3'b000, 1'b0, 3'b000, 2'b11, 2'b10}; 
            B      : ctrl = {2'b01, 2'b00, 2'b01, funct3, 1'b0, 3'b000, 1'b0, 3'b000, 2'b00, 2'b00}; 
            // B      : ctrl = {2'b11, 2'b00, 2'b01, funct3, 1'b0, 3'b000, 1'b0, 3'b000, 2'b00, 2'b00}; 
            LUI    : ctrl = {2'b00, 2'b11, 2'b00, 3'b000, 1'b0, 3'b000, 1'b0, 3'b000, 2'b00, 2'b10}; 
            AUIPC  : ctrl = {2'b00, 2'b11, 2'b00, 3'b000, 1'b0, 3'b000, 1'b0, 3'b000, 2'b01, 2'b10}; 
            default: ctrl = {2'b00, 2'b00, 2'b00, 3'b000, 1'b0, 3'b000, 1'b0, 3'b000, 2'b00, 2'b00}; 
        endcase
    end
    
endmodule