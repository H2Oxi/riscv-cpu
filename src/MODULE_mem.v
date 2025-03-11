module MODULE_mem(
    input           sys_clk         ,
    input           sys_arstn       ,
    input   [14:0]  mem_ctrl_i      ,
    input   [ 1:0]  flag_result_i   ,
    input   [31:0]  inst_addr_i     ,
    input   [31:0]  result_i        ,
    input   [31:0]  reg2_r_data_i   ,
    input   [ 1:0]  wb_ctrl_i       ,
    input   [ 4:0]  mem_Rd_i        ,
    input           en_addr_data_i  ,
    input   [ 4:0]  addr_data_i     ,
    input   [31:0]  data_data_i     ,
    output  [ 4:0]  mem_Rd_o        ,
    output  [ 1:0]  wb_ctrl_o       ,
    output          flag_JorB_o     ,
    output  [31:0]  inst_addr_JorB_o,
    output  [31:0]  data_o          ,
    output  [31:0]  mem_data_o      ,
    output          tx_o  
);

    wire [31:0] inst_addr_addimm    ;
    wire [31:0] inst_addr_add4      ;
    wire [31:0] inst_addr_JorB      ;
    wire [ 1:0] sel                 ;
    wire        flag                ;

    assign mem_Rd_o         = mem_Rd_i                                                              ;
    assign wb_ctrl_o        = wb_ctrl_i                                                             ;
    assign inst_addr_JorB_o = inst_addr_JorB                                                        ;
    assign inst_addr_JorB   = (mem_ctrl_i[1:0] == 2'b11) ? {result_i[31:1], 1'b0} : inst_addr_addimm;
    assign sel              = (mem_ctrl_i[1:0] == 2'b11) ? 2'b10 : mem_ctrl_i                       ;
    assign flag             = (inst_addr_i == 32'h40)                                               ;

    FRAG_adder FRAG_adder_addimm_mem(
        .data_in_0(inst_addr_i       ),
        .data_in_1(result_i          ),
        .data_out (inst_addr_addimm  )
    );

    FRAG_adder FRAG_adder_add4_mem(
        .data_in_0(inst_addr_JorB    ),
        .data_in_1(32'h4             ),
        .data_out (inst_addr_add4    )
    );

    FRAG_mux_3 FRAG_mux_3_mem(
        .data_in_0(result_i        ),
        .data_in_1(inst_addr_addimm),
        .data_in_2(inst_addr_add4  ),
        .select   (sel             ),
        .data_out (mem_data_o      )
    );
    
    FRAG_JorB_ctrl FRAG_JorB_ctrl_mem(
        .ctrl_JorB  (mem_ctrl_i[14:10]  ),
        .flag_result(flag_result_i      ),
        .flag_JorB  (flag_JorB_o        )
    );
    
    FRAG_data_mem FRAG_data_mem_mem(
        .sys_clk        (sys_clk        ),
        .sys_arstn      (sys_arstn      ),
        .ctrl           (mem_ctrl_i[9:2]),
        .en_addr_data   (en_addr_data_i ),
        .addr_data      (addr_data_i    ),
        .data_data      (data_data_i    ),
        .addr           (result_i       ),
        .data_in        (reg2_r_data_i  ),
        .flag           (flag           ),
        .data_out       (data_o         ),
        .tx             (tx_o           )
    );    
    
endmodule
