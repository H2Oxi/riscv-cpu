module MODULE_if (
    input           sys_clk             ,
    input           sys_arstn           ,
    input           flag_JorB_i         ,
    input  [31:0]   inst_addr_JorB_i    ,
    input  [ 2:0]   flag_hold_i         ,
    input           rx_i                ,
    output [31:0]   inst_addr_o         ,
    output [31:0]   inst_data_o         ,
    output          en_addr_data_o      ,
    output [ 4:0]   addr_data_o         ,
    output [31:0]   data_o              ,
    output          start_o            
);

    wire    [31:0]  inst_addr_in        ;
    reg     [31:0]  inst_addr_temp      ;
    wire    [31:0]  inst_addr_out       ;
    wire    [31:0]  inst_addr_add4      ;
    wire    [31:0]  inst_addr_add4_judge;
    wire            final_hold          ;
    reg             start_delay1        ;
    wire            flag_start          ;
    wire            en_addr_inst        ;
    wire    [ 5:0]  addr_inst           ;
    wire    [31:0]  data_out            ;
    
    assign inst_addr_o          = inst_addr_out             ;
    assign inst_addr_out        = inst_addr_temp            ;
    assign final_hold           = |flag_hold_i              ;
    assign flag_start           = start_o & (~start_delay1) ;
    assign data_o               = data_out                  ;
    
    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            inst_addr_temp <= 32'hffffffff;
        end else if(flag_start == 1'b1) begin
            inst_addr_temp <= 32'h0;
        end else if(final_hold == 1'b1) begin
            inst_addr_temp <= inst_addr_temp;
        end else begin
            inst_addr_temp <= inst_addr_in;
        end
    end

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            start_delay1 <= 1'b0;
        end else begin
            start_delay1 <= start_o;
        end 
    end

    FRAG_mux_2 FRAG_mux_2_0_if(
        .data_in_0(inst_addr_add4       ),
        .data_in_1(32'h40               ),
        .select   (inst_addr_add4[6]    ),
        .data_out (inst_addr_add4_judge )
    );
    
    FRAG_mux_2 FRAG_mux_2_1_if(
        .data_in_0(inst_addr_add4_judge ),
        .data_in_1(inst_addr_JorB_i     ),
        .select   (flag_JorB_i          ),
        .data_out (inst_addr_in         )
    );
    
    FRAG_adder FRAG_adder_if(
        .data_in_0(inst_addr_out    ),
        .data_in_1(32'h4            ),
        .data_out (inst_addr_add4   )
    );

    FRAG_inst_mem FRAG_inst_mem_if(
        .sys_clk        (sys_clk            ),
        .sys_arstn      (sys_arstn          ),
        .en_addr_inst   (en_addr_inst       ),
        .addr_inst      (addr_inst          ),
        .data_inst      (data_out           ),
        .addr           (inst_addr_out      ),
        .data           (inst_data_o        )
    );

    FRAG_UART FRAG_UART_if(
        .sys_clk     (sys_clk       ),
        .sys_arstn   (sys_arstn     ),
        .rx          (rx_i          ),
        .en_addr_inst(en_addr_inst  ),
        .en_addr_data(en_addr_data_o),
        .addr_inst   (addr_inst     ),
        .addr_data   (addr_data_o   ),
        .data        (data_out      ),
        .start       (start_o       )
    );

endmodule