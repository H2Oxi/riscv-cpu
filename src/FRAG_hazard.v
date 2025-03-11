module FRAG_hazard (
    input               sys_clk      ,
    input               sys_arstn    ,
    input               start        ,
    input               hold         ,
    input       [4:0]   ex_Rd        ,   
    input               ex_MemRead   ,
    input       [4:0]   id_Rs1       ,
    input       [4:0]   id_Rs2       ,
    input               flag_JorB    ,
    output              flag_flush   ,
    output      [2:0]   flag_hold    
);
    
    assign flag_flush = flag_JorB;

    reg  hold_0_temp        ;
    reg  hold_0_temp_delay1 ;
    wire hold_0             ;
    wire hold_1             ;
    wire hold_2             ;
    
    always @(*) begin
        if((ex_MemRead == 1'b1) & (ex_Rd != 5'b0) & ((ex_Rd == id_Rs1) | (ex_Rd == id_Rs2))) begin
            hold_0_temp = 1'b1;
        end else begin
            hold_0_temp = 1'b0;
        end
    end

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            hold_0_temp_delay1 <= 1'b0;
        end else begin
            hold_0_temp_delay1 <= hold_0_temp;
        end 
    end

    assign hold_0 = hold_0_temp & (~hold_0_temp_delay1);

    assign hold_1 = hold;

    assign hold_2 = ~start;

    assign flag_hold = {hold_2, hold_1, hold_0};

endmodule