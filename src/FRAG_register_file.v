module FRAG_register_file (
    input                   sys_clk         ,
    input                   sys_arstn       ,
    input                   RegWrite        ,
    input       [ 4:0]      w_addr          ,
    input       [31:0]      w_data          ,
    input       [ 4:0]      reg1_r_addr     ,
    input       [ 4:0]      reg2_r_addr     ,
    output  reg [31:0]      reg1_r_data     ,
    output  reg [31:0]      reg2_r_data
);

    reg [31: 0] regs[0:31];

    integer i;
    
    always @(posedge sys_clk, negedge sys_arstn) begin
        if (sys_arstn == 1'b0) begin
            for(i = 0; i <= 31; i = i + 1) begin
                regs[i] <= 32'h0;
            end
        end else if ((RegWrite == 1'b1) && (w_addr != 32'h0)) begin
            regs[w_addr] <= w_data;
        end
    end
    
    always @(*) begin
        if (reg1_r_addr == 32'h0) begin
            reg1_r_data = 32'h0;
        end else if ((RegWrite == 1'b1) && (reg1_r_addr == w_addr)) begin
            reg1_r_data = w_data;
        end else begin
            reg1_r_data = regs[reg1_r_addr];
        end
    end
    
    always @(*) begin
        if (reg2_r_addr == 32'h0) begin
            reg2_r_data = 32'h0;
        end else if ((RegWrite == 1'b1) && (reg2_r_addr == w_addr)) begin
            reg2_r_data = w_data;
        end else begin
            reg2_r_data = regs[reg2_r_addr];
        end
    end

endmodule