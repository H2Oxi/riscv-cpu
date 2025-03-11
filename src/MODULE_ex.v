module MODULE_ex(
    input           sys_clk         ,
    input           sys_arstn       ,
    input           flag_JorB_i     ,
    input           funct7_5_i      ,
    input   [ 2:0]  funct3_i        ,
    input   [ 3:0]  ex_ctrl_i       ,
    input   [31:0]  reg1_r_data_i   ,
    input   [31:0]  reg2_r_data_i   ,
    input   [31:0]  imm_i           ,
    input   [31:0]  mem_data_i      ,
    input   [31:0]  wb_data_i       ,
    input   [ 4:0]  mem_Rd_i        ,
    input   [ 1:0]  mem_wb_ctrl_i   ,
    input   [ 4:0]  wb_Rd_i         ,
    input   [ 1:0]  wb_wb_ctrl_i    ,
    input   [ 4:0]  ex_Rs1_i        ,
    input   [ 4:0]  ex_Rs2_i        ,
    input   [31:0]  inst_addr_i     ,
    input   [14:0]  mem_ctrl_i      ,
    input   [ 1:0]  wb_ctrl_i       ,
    input   [ 4:0]  ex_Rd_i         ,
    output  [ 4:0]  ex_Rd_o         ,
    output  [14:0]  mem_ctrl_o      ,
    output  [ 1:0]  wb_ctrl_o       ,
    output  [31:0]  reg2_r_data_o   ,
    output  [31:0]  inst_addr_o     ,
    output  [31:0]  result_o        ,
    output  [ 1:0]  flag_result_o   ,
    output          hold_o         
);

    wire [ 3:0] ALU_ctrl            ;
    wire [31:0] ALU_data_in_1       ;
    wire [31:0] ALU_data_in_2       ;
    wire [31:0] reg1_r_data         ;
    wire [31:0] reg2_r_data_1       ;
    wire [31:0] reg2_r_data_2       ;
    wire [ 1:0] forward_Rs1_sel     ;
    wire [ 1:0] forward_Rs2_sel     ;
    wire [ 1:0] forward_store_sel   ;
    
    assign ex_Rd_o          = ex_Rd_i       ;
    assign mem_ctrl_o       = mem_ctrl_i    ;
    assign wb_ctrl_o        = wb_ctrl_i     ;
    assign reg2_r_data_o    = reg2_r_data_2 ;
    assign inst_addr_o      = inst_addr_i   ;
    
    FRAG_ALU_ctrl FRAG_ALU_ctrl_ex(
        .ALUOp   (ex_ctrl_i[3:2]),
        .funct7_5(funct7_5_i    ),
        .funct3  (funct3_i      ),
        .ALU_ctrl(ALU_ctrl      )
    );
    
    FRAG_ALU FRAG_ALU_ex(
        .sys_clk    (sys_clk      ),
        .sys_arstn  (sys_arstn    ),
        .flag_JorB  (flag_JorB_i  ),
        .data_in_0  (ALU_data_in_1),
        .data_in_1  (ALU_data_in_2),
        .ALU_ctrl   (ALU_ctrl     ),
        .result     (result_o     ),
        .flag_result(flag_result_o),
        .hold       (hold_o       )
    );
    
    FRAG_mux_2 FRAG_mux_2_Rs1_ex(
        .data_in_0(reg1_r_data  ),
        .data_in_1(32'h0        ),
        .select   (ex_ctrl_i[1] ),
        .data_out (ALU_data_in_1)
    );
    
    FRAG_mux_2 FRAG_mux_2_Rs2_ex(
        .data_in_0(reg2_r_data_1),
        .data_in_1(imm_i        ),
        .select   (ex_ctrl_i[0] ),
        .data_out (ALU_data_in_2)
    );
    
    FRAG_mux_3 FRAG_mux_3_Rs1_ex(
        .data_in_0(reg1_r_data_i    ),
        .data_in_1(mem_data_i       ),
        .data_in_2(wb_data_i        ),
        .select   (forward_Rs1_sel  ),
        .data_out (reg1_r_data      )
    );
    
    FRAG_mux_3 FRAG_mux_3_Rs2_ex(
        .data_in_0(reg2_r_data_i    ),
        .data_in_1(mem_data_i       ),
        .data_in_2(wb_data_i        ),
        .select   (forward_Rs2_sel  ),
        .data_out (reg2_r_data_1    )
    );

    FRAG_mux_3 FRAG_mux_3_store_ex(
        .data_in_0(reg2_r_data_1    ),
        .data_in_1(mem_data_i       ),
        .data_in_2(wb_data_i        ),
        .select   (forward_store_sel),
        .data_out (reg2_r_data_2    )
    );
    
    FRAG_forward FRAG_forward_ex(
        .mem_Rd             (mem_Rd_i           ),
        .mem_wb_ctrl        (mem_wb_ctrl_i      ),
        .wb_Rd              (wb_Rd_i            ),
        .wb_wb_ctrl         (wb_wb_ctrl_i       ),
        .ex_MemWrite        (mem_ctrl_i[5]      ),
        .ex_Rs1             (ex_Rs1_i           ),
        .ex_Rs2             (ex_Rs2_i           ),
        .forward_Rs1_sel    (forward_Rs1_sel    ),
        .forward_Rs2_sel    (forward_Rs2_sel    ),
        .forward_store_sel  (forward_store_sel  )
    );

endmodule
