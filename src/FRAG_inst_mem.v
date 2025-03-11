module FRAG_inst_mem (
    input               sys_clk     ,
    input               sys_arstn   ,
    input               en_addr_inst,
    input       [ 5:0]  addr_inst   ,
    input       [31:0]  data_inst   ,
    input       [31:0]  addr        ,
    output reg  [31:0]  data        
);

    reg [31:0] mem[0:15];

    integer i;
  
    always @(posedge sys_clk, negedge sys_arstn) begin
        if (sys_arstn == 1'b0) begin
            for(i = 0; i <= 15; i = i + 1) begin
                mem[i] <= 32'h0;
            end
        end else if(en_addr_inst == 1'b1) begin
            mem[addr_inst[5:2]] <= data_inst;
        end
    end
    
    always @(posedge sys_clk, negedge sys_arstn) begin
        if (sys_arstn == 1'b0) begin
            data <= 32'h0;
        end else if (addr[31:6] == 26'b0) begin
            data <= mem[addr[5:2]];
        end else begin
            data <= 32'h0;
        end
    end
    
endmodule