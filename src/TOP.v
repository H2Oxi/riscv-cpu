module TOP (
    input   sys_clk  ,
    input   sys_arstn,
    input   rx       ,
    output  tx
);

    wire        if_flag_JorB_i          ;
    wire [31:0] if_inst_addr_JorB_i     ;
    wire [ 2:0] if_flag_hold_i          ;
    wire [31:0] if_inst_addr_o          ;
    wire [31:0] if_inst_data_o          ;
    wire        if_en_addr_data_o       ;
    wire [ 4:0] if_addr_data_o          ;
    wire [31:0] if_data_o               ;
    wire        if_start_o              ;

    wire        if_id_flag_flush        ;
    wire [ 2:0] if_id_flag_hold         ;
    wire [31:0] if_id_inst_data_i       ;
    wire [31:0] if_id_inst_addr_i       ;
    wire [31:0] if_id_inst_data_o       ;
    wire [31:0] if_id_inst_addr_o       ;

    wire        id_start_i              ;
    wire        id_hold_i               ;
    wire [31:0] id_inst_addr_i          ;
    wire [31:0] id_inst_data_i          ;
    wire        id_RegWrite_i           ;
    wire [ 4:0] id_rd_i                 ;
    wire [31:0] id_w_data_i             ;
    wire [ 4:0] id_ex_Rd_i              ;
    wire        id_ex_MemRead_i         ;
    wire        id_flag_JorB_i          ;
    wire        id_flag_flush_o         ;
    wire [ 2:0] id_flag_hold_o          ;
    wire [20:0] id_ctrl_o               ;
    wire        id_funct7_5_o           ;
    wire [ 2:0] id_funct3_o             ;
    wire [31:0] id_reg1_r_data_o        ;
    wire [31:0] id_reg2_r_data_o        ;
    wire [31:0] id_imm_o                ;
    wire [ 4:0] id_Rs1_o                ;
    wire [ 4:0] id_Rs2_o                ;
    wire [31:0] id_inst_addr_o          ;
    wire [ 4:0] id_Rd_o                 ;

    wire        id_ex_flag_flush        ;
    wire [ 2:0] id_ex_flag_hold         ;
    wire        id_ex_funct7_5_i        ;
    wire [ 2:0] id_ex_funct3_i          ;
    wire [ 3:0] id_ex_ex_ctrl_i         ;
    wire [31:0] id_ex_reg1_r_data_i     ;
    wire [31:0] id_ex_reg2_r_data_i     ;
    wire [31:0] id_ex_imm_i             ;
    wire [ 4:0] id_ex_ex_Rs1_i          ;
    wire [ 4:0] id_ex_ex_Rs2_i          ;
    wire [31:0] id_ex_inst_addr_i       ;
    wire [14:0] id_ex_mem_ctrl_i        ;
    wire [ 1:0] id_ex_wb_ctrl_i         ;
    wire [ 4:0] id_ex_ex_Rd_i           ;
    wire        id_ex_funct7_5_o        ;
    wire [ 2:0] id_ex_funct3_o          ;
    wire [ 3:0] id_ex_ex_ctrl_o         ;
    wire [31:0] id_ex_reg1_r_data_o     ;
    wire [31:0] id_ex_reg2_r_data_o     ;
    wire [31:0] id_ex_imm_o             ;
    wire [ 4:0] id_ex_ex_Rs1_o          ;
    wire [ 4:0] id_ex_ex_Rs2_o          ;
    wire [31:0] id_ex_inst_addr_o       ;
    wire [14:0] id_ex_mem_ctrl_o        ;
    wire [ 1:0] id_ex_wb_ctrl_o         ;
    wire [ 4:0] id_ex_ex_Rd_o           ;

    wire        ex_flag_JorB_i          ;
    wire        ex_funct7_5_i           ;
    wire [ 2:0] ex_funct3_i             ;
    wire [ 3:0] ex_ex_ctrl_i            ;
    wire [31:0] ex_reg1_r_data_i        ;
    wire [31:0] ex_reg2_r_data_i        ;
    wire [31:0] ex_imm_i                ;
    wire [31:0] ex_mem_data_i           ;
    wire [31:0] ex_wb_data_i            ;
    wire [ 4:0] ex_mem_Rd_i             ;
    wire [ 1:0] ex_mem_wb_ctrl_i_ex     ;
    wire [ 4:0] ex_wb_Rd_i              ;
    wire [ 1:0] ex_wb_wb_ctrl_i         ;
    wire [ 4:0] ex_ex_Rs1_i             ;
    wire [ 4:0] ex_ex_Rs2_i             ;
    wire [31:0] ex_inst_addr_i          ;
    wire [14:0] ex_mem_ctrl_i           ;
    wire [ 1:0] ex_wb_ctrl_i            ;
    wire [ 4:0] ex_ex_Rd_i              ;
    wire [ 4:0] ex_ex_Rd_o              ;
    wire [14:0] ex_mem_ctrl_o           ;
    wire [ 1:0] ex_wb_ctrl_o            ;
    wire [31:0] ex_reg2_r_data_o        ;
    wire [31:0] ex_inst_addr_o          ;
    wire [31:0] ex_result_o             ;
    wire [ 1:0] ex_flag_result_o        ;
    wire        ex_hold_o               ;

    wire        ex_mem_flag_flush       ;
    wire [ 2:0] ex_mem_flag_hold        ;
    wire [14:0] ex_mem_mem_ctrl_i       ;
    wire [ 1:0] ex_mem_flag_result_i    ;
    wire [31:0] ex_mem_inst_addr_i      ;
    wire [31:0] ex_mem_result_i         ;
    wire [31:0] ex_mem_reg2_r_data_i    ;
    wire [ 1:0] ex_mem_wb_ctrl_i_ex_mem ;
    wire [ 4:0] ex_mem_mem_Rd_i         ;
    wire [14:0] ex_mem_mem_ctrl_o       ;
    wire [ 1:0] ex_mem_flag_result_o    ;
    wire [31:0] ex_mem_inst_addr_o      ;
    wire [31:0] ex_mem_result_o         ;
    wire [31:0] ex_mem_reg2_r_data_o    ;
    wire [ 1:0] ex_mem_wb_ctrl_o        ;
    wire [ 4:0] ex_mem_mem_Rd_o         ;

    wire [14:0] mem_mem_ctrl_i          ;
    wire [ 1:0] mem_flag_result_i       ;
    wire [31:0] mem_inst_addr_i         ;
    wire [31:0] mem_result_i            ;
    wire [31:0] mem_reg2_r_data_i       ;
    wire [ 1:0] mem_wb_ctrl_i           ;
    wire [ 4:0] mem_mem_Rd_i            ;
    wire        mem_en_addr_data_i      ;
    wire [ 4:0] mem_addr_data_i         ;
    wire [31:0] mem_data_data_i         ;
    wire [ 4:0] mem_mem_Rd_o            ;
    wire [ 1:0] mem_wb_ctrl_o           ;
    wire        mem_flag_JorB_o         ;
    wire [31:0] mem_inst_addr_JorB_o    ;
    wire [31:0] mem_data_o              ;
    wire [31:0] mem_mem_data_o          ;

    wire [ 2:0] mem_wb_flag_hold        ;
    wire [ 1:0] mem_wb_wb_ctrl_i        ;
    wire [31:0] mem_wb_wb_data_i        ;
    wire [31:0] mem_wb_data_i           ;
    wire [ 4:0] mem_wb_wb_Rd_i          ;
    wire [ 1:0] mem_wb_wb_ctrl_o        ;
    wire [31:0] mem_wb_wb_data_o        ;
    wire [31:0] mem_wb_data_o           ;
    wire [ 4:0] mem_wb_wb_Rd_o          ;

    wire [ 1:0] wb_wb_ctrl_i            ;
    wire [31:0] wb_wb_data_i            ;
    wire [31:0] wb_data_i               ;
    wire [ 4:0] wb_wb_Rd_i              ;
    wire [ 4:0] wb_wb_Rd_o              ;
    wire        wb_RegWrite_o           ;
    wire [31:0] wb_w_data_o             ;
    
    assign if_flag_JorB_i          = mem_flag_JorB_o         ;
    assign if_inst_addr_JorB_i     = mem_inst_addr_JorB_o    ;
    assign if_flag_hold_i          = id_flag_hold_o          ;

    assign if_id_flag_flush        = id_flag_flush_o         ;
    assign if_id_flag_hold         = id_flag_hold_o          ;
    assign if_id_inst_data_i       = if_inst_data_o          ;
    assign if_id_inst_addr_i       = if_inst_addr_o          ;

    assign id_start_i              = if_start_o              ;
    assign id_hold_i               = ex_hold_o               ;
    assign id_inst_addr_i          = if_id_inst_addr_o       ;
    assign id_inst_data_i          = if_id_inst_data_o       ;
    assign id_RegWrite_i           = wb_RegWrite_o           ;
    assign id_rd_i                 = wb_wb_Rd_o              ;
    assign id_w_data_i             = wb_w_data_o             ;
    assign id_ex_Rd_i              = ex_ex_Rd_o              ;
    assign id_ex_MemRead_i         = ex_mem_ctrl_o[9]        ;
    assign id_flag_JorB_i          = mem_flag_JorB_o         ;

    assign id_ex_flag_flush        = id_flag_flush_o         ;
    assign id_ex_flag_hold         = id_flag_hold_o          ;
    assign id_ex_funct7_5_i        = id_funct7_5_o           ;
    assign id_ex_funct3_i          = id_funct3_o             ;
    assign id_ex_ex_ctrl_i         = id_ctrl_o[20:17]        ;
    assign id_ex_reg1_r_data_i     = id_reg1_r_data_o        ;
    assign id_ex_reg2_r_data_i     = id_reg2_r_data_o        ;
    assign id_ex_imm_i             = id_imm_o                ;
    assign id_ex_ex_Rs1_i          = id_Rs1_o                ;
    assign id_ex_ex_Rs2_i          = id_Rs2_o                ;
    assign id_ex_inst_addr_i       = id_inst_addr_o          ;
    assign id_ex_mem_ctrl_i        = id_ctrl_o[16:2]         ;
    assign id_ex_wb_ctrl_i         = id_ctrl_o[1:0]          ;
    assign id_ex_ex_Rd_i           = id_Rd_o                 ;

    assign ex_flag_JorB_i          = mem_flag_JorB_o         ;
    assign ex_funct7_5_i           = id_ex_funct7_5_o        ;
    assign ex_funct3_i             = id_ex_funct3_o          ;
    assign ex_ex_ctrl_i            = id_ex_ex_ctrl_o         ;
    assign ex_reg1_r_data_i        = id_ex_reg1_r_data_o     ;
    assign ex_reg2_r_data_i        = id_ex_reg2_r_data_o     ;
    assign ex_imm_i                = id_ex_imm_o             ;
    assign ex_mem_data_i           = mem_mem_data_o          ;
    assign ex_wb_data_i            = wb_w_data_o             ;
    assign ex_mem_Rd_i             = ex_mem_mem_Rd_o         ;
    assign ex_mem_wb_ctrl_i_ex     = ex_mem_wb_ctrl_o        ;
    assign ex_wb_Rd_i              = mem_wb_wb_Rd_o          ;
    assign ex_wb_wb_ctrl_i         = mem_wb_wb_ctrl_o        ;
    assign ex_ex_Rs1_i             = id_ex_ex_Rs1_o          ;
    assign ex_ex_Rs2_i             = id_ex_ex_Rs2_o          ;
    assign ex_inst_addr_i          = id_ex_inst_addr_o       ;
    assign ex_mem_ctrl_i           = id_ex_mem_ctrl_o        ;
    assign ex_wb_ctrl_i            = id_ex_wb_ctrl_o         ;
    assign ex_ex_Rd_i              = id_ex_ex_Rd_o           ;

    assign ex_mem_flag_flush       = id_flag_flush_o         ;
    assign ex_mem_flag_hold        = id_flag_hold_o          ;
    assign ex_mem_mem_ctrl_i       = ex_mem_ctrl_o           ;
    assign ex_mem_flag_result_i    = ex_flag_result_o        ;
    assign ex_mem_inst_addr_i      = ex_inst_addr_o          ;
    assign ex_mem_result_i         = ex_result_o             ;
    assign ex_mem_reg2_r_data_i    = ex_reg2_r_data_o        ;
    assign ex_mem_wb_ctrl_i_ex_mem = ex_wb_ctrl_o            ;
    assign ex_mem_mem_Rd_i         = ex_ex_Rd_o              ;

    assign mem_mem_ctrl_i          = ex_mem_mem_ctrl_o       ;
    assign mem_flag_result_i       = ex_mem_flag_result_o    ;
    assign mem_inst_addr_i         = ex_mem_inst_addr_o      ;
    assign mem_result_i            = ex_mem_result_o         ;
    assign mem_reg2_r_data_i       = ex_mem_reg2_r_data_o    ;
    assign mem_wb_ctrl_i           = ex_mem_wb_ctrl_o        ;
    assign mem_mem_Rd_i            = ex_mem_mem_Rd_o         ;
    assign mem_en_addr_data_i      = if_en_addr_data_o       ;
    assign mem_addr_data_i         = if_addr_data_o          ;
    assign mem_data_data_i         = if_data_o               ;

    assign mem_wb_flag_hold        = id_flag_hold_o          ;
    assign mem_wb_wb_ctrl_i        = mem_wb_ctrl_o           ;
    assign mem_wb_wb_data_i        = mem_mem_data_o          ;
    assign mem_wb_data_i           = mem_data_o              ;
    assign mem_wb_wb_Rd_i          = mem_mem_Rd_o            ;

    assign wb_wb_ctrl_i            = mem_wb_wb_ctrl_o        ;
    assign wb_wb_data_i            = mem_wb_wb_data_o        ;
    assign wb_data_i               = mem_wb_data_o           ;
    assign wb_wb_Rd_i              = mem_wb_wb_Rd_o          ;
    
    MODULE_if if_inst(
        .sys_clk         (sys_clk               ),
        .sys_arstn       (sys_arstn             ),
        .flag_JorB_i     (if_flag_JorB_i        ),
        .inst_addr_JorB_i(if_inst_addr_JorB_i   ),
        .flag_hold_i     (if_flag_hold_i        ),
        .rx_i            (rx                    ),
        .inst_addr_o     (if_inst_addr_o        ),
        .inst_data_o     (if_inst_data_o        ),
        .en_addr_data_o  (if_en_addr_data_o     ),
        .addr_data_o     (if_addr_data_o        ),
        .data_o          (if_data_o             ),
        .start_o         (if_start_o            )
    );  
    
    MODULE_if_id if_id_inst(
        .sys_clk    (sys_clk            ),
        .sys_arstn  (sys_arstn          ),
        .flag_flush (if_id_flag_flush   ),
        .flag_hold  (if_id_flag_hold    ),
        .inst_data_i(if_id_inst_data_i  ),
        .inst_addr_i(if_id_inst_addr_i  ),
        .inst_data_o(if_id_inst_data_o  ),
        .inst_addr_o(if_id_inst_addr_o  )
    ); 
    
    MODULE_id id_inst(
        .sys_clk      (sys_clk          ),
        .sys_arstn    (sys_arstn        ),
        .start_i      (id_start_i       ),
        .hold_i       (id_hold_i        ),
        .inst_addr_i  (id_inst_addr_i   ),
        .inst_data_i  (id_inst_data_i   ),
        .RegWrite_i   (id_RegWrite_i    ),
        .rd_i         (id_rd_i          ),
        .w_data_i     (id_w_data_i      ),
        .ex_Rd_i      (id_ex_Rd_i       ),   
        .ex_MemRead_i (id_ex_MemRead_i  ),
        .flag_JorB_i  (id_flag_JorB_i   ),
        .flag_flush_o (id_flag_flush_o  ),
        .flag_hold_o  (id_flag_hold_o   ),
        .ctrl_o       (id_ctrl_o        ),
        .funct7_5_o   (id_funct7_5_o    ),
        .funct3_o     (id_funct3_o      ),
        .reg1_r_data_o(id_reg1_r_data_o ),
        .reg2_r_data_o(id_reg2_r_data_o ),
        .imm_o        (id_imm_o         ),
        .Rs1_o        (id_Rs1_o         ),
        .Rs2_o        (id_Rs2_o         ),
        .inst_addr_o  (id_inst_addr_o   ),
        .Rd_o         (id_Rd_o          )   
    ); 
    
    MODULE_id_ex id_ex_inst(
        .sys_clk      (sys_clk              ),
        .sys_arstn    (sys_arstn            ),
        .flag_flush   (id_ex_flag_flush     ),
        .flag_hold    (id_ex_flag_hold      ),
        .funct7_5_i   (id_ex_funct7_5_i     ),
        .funct3_i     (id_ex_funct3_i       ),
        .ex_ctrl_i    (id_ex_ex_ctrl_i      ),
        .reg1_r_data_i(id_ex_reg1_r_data_i  ),
        .reg2_r_data_i(id_ex_reg2_r_data_i  ),
        .imm_i        (id_ex_imm_i          ),
        .ex_Rs1_i     (id_ex_ex_Rs1_i       ),
        .ex_Rs2_i     (id_ex_ex_Rs2_i       ),
        .inst_addr_i  (id_ex_inst_addr_i    ),
        .mem_ctrl_i   (id_ex_mem_ctrl_i     ),
        .wb_ctrl_i    (id_ex_wb_ctrl_i      ),
        .ex_Rd_i      (id_ex_ex_Rd_i        ),
        .funct7_5_o   (id_ex_funct7_5_o     ),
        .funct3_o     (id_ex_funct3_o       ),
        .ex_ctrl_o    (id_ex_ex_ctrl_o      ),
        .reg1_r_data_o(id_ex_reg1_r_data_o  ),
        .reg2_r_data_o(id_ex_reg2_r_data_o  ),
        .imm_o        (id_ex_imm_o          ),
        .ex_Rs1_o     (id_ex_ex_Rs1_o       ),
        .ex_Rs2_o     (id_ex_ex_Rs2_o       ),
        .inst_addr_o  (id_ex_inst_addr_o    ),
        .mem_ctrl_o   (id_ex_mem_ctrl_o     ),
        .wb_ctrl_o    (id_ex_wb_ctrl_o      ),
        .ex_Rd_o      (id_ex_ex_Rd_o        )   
    );
    
    MODULE_ex ex_inst(
        .sys_clk       (sys_clk             ),
        .sys_arstn     (sys_arstn           ),
        .flag_JorB_i   (ex_flag_JorB_i      ),
        .funct7_5_i    (ex_funct7_5_i       ),
        .funct3_i      (ex_funct3_i         ),
        .ex_ctrl_i     (ex_ex_ctrl_i        ),
        .reg1_r_data_i (ex_reg1_r_data_i    ),
        .reg2_r_data_i (ex_reg2_r_data_i    ),
        .imm_i         (ex_imm_i            ),
        .mem_data_i    (ex_mem_data_i       ),
        .wb_data_i     (ex_wb_data_i        ),
        .mem_Rd_i      (ex_mem_Rd_i         ),
        .mem_wb_ctrl_i (ex_mem_wb_ctrl_i_ex ),
        .wb_Rd_i       (ex_wb_Rd_i          ),
        .wb_wb_ctrl_i  (ex_wb_wb_ctrl_i     ),
        .ex_Rs1_i      (ex_ex_Rs1_i         ),
        .ex_Rs2_i      (ex_ex_Rs2_i         ),
        .inst_addr_i   (ex_inst_addr_i      ),
        .mem_ctrl_i    (ex_mem_ctrl_i       ),
        .wb_ctrl_i     (ex_wb_ctrl_i        ),
        .ex_Rd_i       (ex_ex_Rd_i          ),
        .ex_Rd_o       (ex_ex_Rd_o          ),
        .mem_ctrl_o    (ex_mem_ctrl_o       ),
        .wb_ctrl_o     (ex_wb_ctrl_o        ),
        .reg2_r_data_o (ex_reg2_r_data_o    ),
        .inst_addr_o   (ex_inst_addr_o      ),
        .result_o      (ex_result_o         ),
        .flag_result_o (ex_flag_result_o    ),
        .hold_o        (ex_hold_o           )       
    );
    
    MODULE_ex_mem ex_mem_inst(
        .sys_clk      (sys_clk                      ),
        .sys_arstn    (sys_arstn                    ),
        .flag_flush   (ex_mem_flag_flush            ),
        .flag_hold    (ex_mem_flag_hold             ),
        .mem_ctrl_i   (ex_mem_mem_ctrl_i            ),
        .flag_result_i(ex_mem_flag_result_i         ),
        .inst_addr_i  (ex_mem_inst_addr_i           ),
        .result_i     (ex_mem_result_i              ),
        .reg2_r_data_i(ex_mem_reg2_r_data_i         ),
        .wb_ctrl_i    (ex_mem_wb_ctrl_i_ex_mem      ),
        .mem_Rd_i     (ex_mem_mem_Rd_i              ),
        .mem_ctrl_o   (ex_mem_mem_ctrl_o            ),
        .flag_result_o(ex_mem_flag_result_o         ),
        .inst_addr_o  (ex_mem_inst_addr_o           ),
        .result_o     (ex_mem_result_o              ),
        .reg2_r_data_o(ex_mem_reg2_r_data_o         ),
        .wb_ctrl_o    (ex_mem_wb_ctrl_o             ),
        .mem_Rd_o     (ex_mem_mem_Rd_o              )
    );
    
    MODULE_mem mem_inst(
        .sys_clk         (sys_clk               ),
        .sys_arstn       (sys_arstn             ),
        .mem_ctrl_i      (mem_mem_ctrl_i        ),
        .flag_result_i   (mem_flag_result_i     ),
        .inst_addr_i     (mem_inst_addr_i       ),
        .result_i        (mem_result_i          ),
        .reg2_r_data_i   (mem_reg2_r_data_i     ),
        .wb_ctrl_i       (mem_wb_ctrl_i         ),
        .mem_Rd_i        (mem_mem_Rd_i          ),
        .en_addr_data_i  (mem_en_addr_data_i    ),
        .addr_data_i     (mem_addr_data_i       ),
        .data_data_i     (mem_data_data_i       ),
        .mem_Rd_o        (mem_mem_Rd_o          ),
        .wb_ctrl_o       (mem_wb_ctrl_o         ),
        .flag_JorB_o     (mem_flag_JorB_o       ),
        .inst_addr_JorB_o(mem_inst_addr_JorB_o  ),
        .data_o          (mem_data_o            ),
        .mem_data_o      (mem_mem_data_o        ),
        .tx_o            (tx                    )      
    );
    
    MODULE_mem_wb mem_wb_inst(
        .sys_clk         (sys_clk                   ),
        .sys_arstn       (sys_arstn                 ),
        .flag_hold       (mem_wb_flag_hold          ),
        .wb_ctrl_i       (mem_wb_wb_ctrl_i          ),
        .wb_data_i       (mem_wb_wb_data_i          ),
        .data_i          (mem_wb_data_i             ),
        .wb_Rd_i         (mem_wb_wb_Rd_i            ),
        .wb_ctrl_o       (mem_wb_wb_ctrl_o          ),
        .wb_data_o       (mem_wb_wb_data_o          ),
        .data_o          (mem_wb_data_o             ),
        .wb_Rd_o         (mem_wb_wb_Rd_o            )
    );
    
    MODULE_wb wb_inst(
        .wb_ctrl_i       (wb_wb_ctrl_i       ),
        .wb_data_i       (wb_wb_data_i       ),
        .data_i          (wb_data_i          ),
        .wb_Rd_i         (wb_wb_Rd_i         ),
        .wb_Rd_o         (wb_wb_Rd_o         ),
        .RegWrite_o      (wb_RegWrite_o      ),
        .w_data_o        (wb_w_data_o        )
    );

endmodule

