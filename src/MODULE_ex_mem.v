module MODULE_ex_mem (
    input           sys_clk         ,
    input           sys_arstn       ,
    input           flag_flush      ,
    input   [ 2:0]  flag_hold       ,
    input   [14:0]  mem_ctrl_i      ,
    input   [ 1:0]  flag_result_i   ,
    input   [31:0]  inst_addr_i     ,
    input   [31:0]  result_i        ,
    input   [31:0]  reg2_r_data_i   ,
    input   [ 1:0]  wb_ctrl_i       ,
    input   [ 4:0]  mem_Rd_i        ,
    output  [14:0]  mem_ctrl_o      ,
    output  [ 1:0]  flag_result_o   ,
    output  [31:0]  inst_addr_o     ,
    output  [31:0]  result_o        ,
    output  [31:0]  reg2_r_data_o   ,
    output  [ 1:0]  wb_ctrl_o       ,
    output  [ 4:0]  mem_Rd_o        
);

    wire final_flush;
    wire final_hold;

    assign final_flush = (flag_hold[1] == 1'b1) | (flag_flush == 1'b1);
    assign final_hold = (flag_hold[2] == 1'b1);

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
    ) pipline_flag_result(
        .sys_clk      (sys_clk          ), 
        .sys_arstn    (sys_arstn        ), 
        .flag_flush   (final_flush      ), 
        .flag_hold    (final_hold       ), 
        .default_value(2'b0             ),
        .data_in      (flag_result_i    ),
        .data_out     (flag_result_o    )
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
        32
    ) pipline_result(
        .sys_clk      (sys_clk          ),
        .sys_arstn    (sys_arstn        ),
        .flag_flush   (final_flush      ),
        .flag_hold    (final_hold       ),
        .default_value(32'b0            ),
        .data_in      (result_i         ),
        .data_out     (result_o         )
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
        2
    ) pipline_wb_ctrl(
        .sys_clk      (sys_clk      ),
        .sys_arstn    (sys_arstn    ),
        .flag_flush   (final_flush  ),
        .flag_hold    (final_hold   ),
        .default_value(2'b0         ),
        .data_in      (wb_ctrl_i    ),
        .data_out     (wb_ctrl_o    )
    );

    FRAG_pipline #(
        5
    ) pipline_mem_Rd(
        .sys_clk      (sys_clk      ),
        .sys_arstn    (sys_arstn    ),
        .flag_flush   (final_flush  ),
        .flag_hold    (final_hold   ),
        .default_value(5'b0         ),
        .data_in      (mem_Rd_i     ),
        .data_out     (mem_Rd_o     )
    );

endmodule
