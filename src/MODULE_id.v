module MODULE_id (
    input           sys_clk         ,
    input           sys_arstn       ,
    input           start_i         ,
    input           hold_i          ,
    input   [31:0]  inst_addr_i     ,
    input   [31:0]  inst_data_i     ,
    input           RegWrite_i      ,
    input   [ 4:0]  rd_i            ,
    input   [31:0]  w_data_i        ,
    input   [ 4:0]  ex_Rd_i         ,   
    input           ex_MemRead_i    ,
    input           flag_JorB_i     ,
    output          flag_flush_o    ,
    output  [ 2:0]  flag_hold_o     ,
    output  [20:0]  ctrl_o          ,
    output          funct7_5_o      ,
    output  [ 2:0]  funct3_o        ,
    output  [31:0]  reg1_r_data_o   ,
    output  [31:0]  reg2_r_data_o   ,
    output  [31:0]  imm_o           ,
    output  [ 4:0]  Rs1_o           ,
    output  [ 4:0]  Rs2_o           ,
    output  [31:0]  inst_addr_o     ,
    output  [ 4:0]  Rd_o            
);
    
    assign funct7_5_o   = inst_data_i[   30];
    assign funct3_o     = inst_data_i[14:12];
    assign Rs1_o        = inst_data_i[19:15];
    assign Rs2_o        = inst_data_i[24:20];
    assign Rd_o         = inst_data_i[11: 7];
    assign inst_addr_o  = inst_addr_i       ;

    FRAG_ctrl FRAG_ctrl_id(
        .opcode     (inst_data_i[6:0]    ),
        .funct3     (inst_data_i[14:12]  ),
        .funct7_0   (inst_data_i[25]     ),
        .ctrl       (ctrl_o              )
    );
    
    FRAG_register_file FRAG_register_file_id(
        .sys_clk    (sys_clk             ),
        .sys_arstn  (sys_arstn           ),
        .RegWrite   (RegWrite_i          ),
        .w_addr     (rd_i                ),
        .w_data     (w_data_i            ),
        .reg1_r_addr(inst_data_i[19:15]  ),
        .reg2_r_addr(inst_data_i[24:20]  ),
        .reg1_r_data(reg1_r_data_o       ),
        .reg2_r_data(reg2_r_data_o       )
    );
    
    FRAG_imm_gen FRAG_imm_gen_id(
        .inst_data(inst_data_i  ),
        .imm      (imm_o        )
    );
        
    FRAG_hazard FRAG_hazard_id(
        .sys_clk        (sys_clk             ),
        .sys_arstn      (sys_arstn           ),
        .start          (start_i             ),
        .hold           (hold_i              ),
        .ex_Rd          (ex_Rd_i             ),   
        .ex_MemRead     (ex_MemRead_i        ),
        .id_Rs1         (inst_data_i[19:15]  ),
        .id_Rs2         (inst_data_i[24:20]  ),
        .flag_JorB      (flag_JorB_i         ),
        .flag_flush     (flag_flush_o        ),
        .flag_hold      (flag_hold_o         )
    );

endmodule
