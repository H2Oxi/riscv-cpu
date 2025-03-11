module MODULE_mem_wb (
    input           sys_clk         ,
    input           sys_arstn       ,
    input   [ 2:0]  flag_hold       ,
    input   [ 1:0]  wb_ctrl_i       ,
    input   [31:0]  wb_data_i       ,
    input   [31:0]  data_i          ,
    input   [ 4:0]  wb_Rd_i         ,
    output  [ 1:0]  wb_ctrl_o       ,
    output  [31:0]  wb_data_o       ,
    output  [31:0]  data_o          ,
    output  [ 4:0]  wb_Rd_o         
);

    wire final_hold;
    
    assign final_hold = (flag_hold[2] == 1'b1);
    
    FRAG_pipline #(
        2
    ) pipline_wb_ctrl(
        .sys_clk      (sys_clk      ),
        .sys_arstn    (sys_arstn    ),
        .flag_flush   (1'b0         ),
        .flag_hold    (final_hold   ),
        .default_value(2'b0         ),
        .data_in      (wb_ctrl_i    ),
        .data_out     (wb_ctrl_o    )
    );

    FRAG_pipline #(
        32
    ) pipline_wb_data(
        .sys_clk      (sys_clk          ),
        .sys_arstn    (sys_arstn        ),
        .flag_flush   (1'b0             ),
        .flag_hold    (final_hold       ),
        .default_value(32'b0            ),
        .data_in      (wb_data_i        ),
        .data_out     (wb_data_o        )
    );

    assign data_o = data_i;

    FRAG_pipline #(
        5
    ) pipline_wb_Rd(
        .sys_clk      (sys_clk      ),
        .sys_arstn    (sys_arstn    ),
        .flag_flush   (1'b0         ),
        .flag_hold    (final_hold   ),
        .default_value(5'b0         ),
        .data_in      (wb_Rd_i      ),
        .data_out     (wb_Rd_o      )
    );

endmodule
