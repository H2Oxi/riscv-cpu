module FRAG_forward (
    input       [4:0]   mem_Rd              ,
    input       [1:0]   mem_wb_ctrl         ,
    input       [4:0]   wb_Rd               ,
    input       [1:0]   wb_wb_ctrl          ,
    input               ex_MemWrite         ,
    input       [4:0]   ex_Rs1              ,
    input       [4:0]   ex_Rs2              ,
    output  reg [1:0]   forward_Rs1_sel     ,
    output  reg [1:0]   forward_Rs2_sel     ,
    output  reg [1:0]   forward_store_sel 
);

    always @(*) begin
        if((mem_wb_ctrl[1] == 1'b1) & (mem_Rd != 5'b0) & (mem_Rd == ex_Rs1)) begin
            forward_Rs1_sel = 2'b01;
        end else if((wb_wb_ctrl[1] == 1'b1) & (wb_Rd != 5'b0) & (wb_Rd == ex_Rs1)) begin
            forward_Rs1_sel = 2'b10;
        end else begin
            forward_Rs1_sel = 2'b00;
        end
    end

    always @(*) begin
        if((mem_wb_ctrl[1] == 1'b1) & (mem_Rd != 5'b0) & (mem_Rd == ex_Rs2)) begin
            forward_Rs2_sel = 2'b01;
        end else if((wb_wb_ctrl[1] == 1'b1) & (wb_Rd != 5'b0) & (wb_Rd == ex_Rs2)) begin
            forward_Rs2_sel = 2'b10;
        end else begin
            forward_Rs2_sel = 2'b00;
        end
    end

    always @(*) begin
        if((mem_wb_ctrl[1] == 1'b1) & (ex_MemWrite == 1'b1) & (mem_Rd != 5'b0) & (mem_Rd == ex_Rs2)) begin
            forward_store_sel = 2'b01;
        end else if((wb_wb_ctrl[1] == 1'b1) & (ex_MemWrite == 1'b1) & (wb_Rd != 5'b0) & (wb_Rd == ex_Rs2)) begin 
            forward_store_sel = 2'b10;
        end else begin
            forward_store_sel = 2'b00;
        end
    end

endmodule