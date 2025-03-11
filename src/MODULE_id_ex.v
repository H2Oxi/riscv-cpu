module MODULE_id_ex (
    input           sys_clk         ,
    input           sys_arstn       ,
    input           flag_flush      ,
    input   [ 2:0]  flag_hold       ,
    input           funct7_5_i      ,
    input   [ 2:0]  funct3_i        ,
    input   [ 3:0]  ex_ctrl_i       ,
    input   [31:0]  reg1_r_data_i   ,
    input   [31:0]  reg2_r_data_i   ,
    input   [31:0]  imm_i           ,
    input   [ 4:0]  ex_Rs1_i        ,
    input   [ 4:0]  ex_Rs2_i        ,
    input   [31:0]  inst_addr_i     ,
    input   [14:0]  mem_ctrl_i      ,
    input   [ 1:0]  wb_ctrl_i       ,
    input   [ 4:0]  ex_Rd_i         ,
    output          funct7_5_o      ,
    output  [ 2:0]  funct3_o        ,
    output  [ 3:0]  ex_ctrl_o       ,
    output  [31:0]  reg1_r_data_o   ,
    output  [31:0]  reg2_r_data_o   ,
    output  [31:0]  imm_o           ,
    output  [ 4:0]  ex_Rs1_o        ,
    output  [ 4:0]  ex_Rs2_o        ,
    output  [31:0]  inst_addr_o     ,
    output  [14:0]  mem_ctrl_o      ,
    output  [ 1:0]  wb_ctrl_o       ,
    output  [ 4:0]  ex_Rd_o         
);

    wire final_flush;
    wire final_hold;

    assign final_flush = (flag_hold[0] == 1'b1) | (flag_flush == 1'b1);
    assign final_hold = (flag_hold[2] == 1'b1) | (flag_hold[1] == 1'b1);
    
    FRAG_pipline #(
        1
    ) pipline_funct7_5(
        .sys_clk      (sys_clk      ),
        .sys_arstn    (sys_arstn    ),
        .flag_flush   (final_flush  ),
        .flag_hold    (final_hold   ),
        .default_value(1'b0         ),
        .data_in      (funct7_5_i   ),
        .data_out     (funct7_5_o   ) 
    );

    FRAG_pipline #(
        3
    ) pipline_funct3(
        .sys_clk      (sys_clk      ),
        .sys_arstn    (sys_arstn    ),
        .flag_flush   (final_flush  ),
        .flag_hold    (final_hold   ),
        .default_value(3'b0         ),
        .data_in      (funct3_i     ),
        .data_out     (funct3_o     )
    );

    FRAG_pipline #(
        4
    ) pipline_ex_ctrl(
        .sys_clk      (sys_clk      ),
        .sys_arstn    (sys_arstn    ),
        .flag_flush   (final_flush  ),
        .flag_hold    (final_hold   ),
        .default_value(4'b0001      ),
        .data_in      (ex_ctrl_i    ),
        .data_out     (ex_ctrl_o    )
    );

    FRAG_pipline #(
        32
    ) pipline_reg1_r_data(
        .sys_clk      (sys_clk          ),
        .sys_arstn    (sys_arstn        ),
        .flag_flush   (final_flush      ),
        .flag_hold    (final_hold       ),
        .default_value(32'b0            ),
        .data_in      (reg1_r_data_i    ),
        .data_out     (reg1_r_data_o    )
    );

    FRAG_pipline #(
        32
    ) pipline_reg2_r_data(
        .sys_clk      (sys_clk          ),
        .sys_arstn    (sys_arstn        ),
        .flag_flush   (final_flush      ),
        .flag_hold    (final_hold       ),
        .default_value(32'b0            ),
        .data_in      (reg2_r_data_i    ),
        .data_out     (reg2_r_data_o    )
    );

    FRAG_pipline #(
        32
    ) pipline_imm(
        .sys_clk      (sys_clk          ),
        .sys_arstn    (sys_arstn        ),
        .flag_flush   (final_flush      ),
        .flag_hold    (final_hold       ),
        .default_value(32'b0            ),
        .data_in      (imm_i            ),
        .data_out     (imm_o            )
    );

    FRAG_pipline #(
        5
    ) pipline_ex_Rs1(
        .sys_clk      (sys_clk      ),
        .sys_arstn    (sys_arstn    ),
        .flag_flush   (final_flush  ),
        .flag_hold    (final_hold   ),
        .default_value(5'b0         ),
        .data_in      (ex_Rs1_i     ),
        .data_out     (ex_Rs1_o     )
    );

    FRAG_pipline #(
        5
    ) pipline_ex_Rs2(
        .sys_clk      (sys_clk      ),
        .sys_arstn    (sys_arstn    ),
        .flag_flush   (final_flush  ),
        .flag_hold    (final_hold   ),
        .default_value(5'b0         ),
        .data_in      (ex_Rs2_i     ),
        .data_out     (ex_Rs2_o     )
    );

    FRAG_pipline #(
        32
    ) pipline_inst_addr(
        .sys_clk      (sys_clk          ),
        .sys_arstn    (sys_arstn        ),
        .flag_flush   (final_flush      ),
        .flag_hold    (final_hold       ),
        .default_value(32'b0            ),
        .data_in      (inst_addr_i      ),
        .data_out     (inst_addr_o      )
    );

    FRAG_pipline #(
        15
    ) pipline_mem_ctrl(
        .sys_clk      (sys_clk          ),
        .sys_arstn    (sys_arstn        ),
        .flag_flush   (final_flush      ),
        .flag_hold    (final_hold       ),
        .default_value(15'b0            ),
        .data_in      (mem_ctrl_i       ),
        .data_out     (mem_ctrl_o       )
    );

    FRAG_pipline #(
        2
    ) pipline_wb_ctrl(
        .sys_clk      (sys_clk      ),
        .sys_arstn    (sys_arstn    ),
        .flag_flush   (final_flush  ),
        .flag_hold    (final_hold   ),
        .default_value(2'b10        ),
        .data_in      (wb_ctrl_i    ),
        .data_out     (wb_ctrl_o    )
    );

    FRAG_pipline #(
        5
    ) pipline_ex_Rd(
        .sys_clk      (sys_clk      ),
        .sys_arstn    (sys_arstn    ),
        .flag_flush   (final_flush  ),
        .flag_hold    (final_hold   ),
        .default_value(5'b0         ),
        .data_in      (ex_Rd_i      ),
        .data_out     (ex_Rd_o      )
    );

endmodule
