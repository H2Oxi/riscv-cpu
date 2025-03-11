module MODULE_if_id (
    input           sys_clk     ,
    input           sys_arstn   ,
    input           flag_flush  ,
    input   [ 2:0]  flag_hold   ,
    input   [31:0]  inst_data_i ,
    input   [31:0]  inst_addr_i ,
    output  [31:0]  inst_data_o ,
    output  [31:0]  inst_addr_o
);

    wire        final_hold          ;
    reg         final_hold_delay1   ;
    reg [31:0]  inst_data_temp      ;

    localparam NOP = 32'b00000000000000000000000000010011;

    assign final_hold = (flag_hold != 3'b000);
    
    FRAG_pipline pipline_inst_addr(
        .sys_clk      (sys_clk      )  ,
        .sys_arstn    (sys_arstn    )  ,
        .flag_flush   (flag_flush   )  ,
        .flag_hold    (final_hold   )  ,
        .default_value(32'b0        )  ,
        .data_in      (inst_addr_i  )  ,
        .data_out     (inst_addr_o  )
    );

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            final_hold_delay1 <= 32'h0;
        end else begin
            final_hold_delay1 <= final_hold;
        end
    end

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            inst_data_temp <= 32'h0;
        end else if(final_hold_delay1 == 1'b1) begin
            inst_data_temp <= inst_data_temp;
        end else begin
            inst_data_temp <= inst_data_i;
        end
    end

    assign inst_data_o  =   (sys_arstn == 1'b0) ? 32'h0 :
                            (flag_flush == 1'b1) ? NOP :
                            ((final_hold == 1'b1) & (final_hold_delay1 == 1'b0)) ? inst_data_i :
                            (final_hold_delay1 == 1'b1) ? inst_data_temp :
                            inst_data_i;

    // always @(*) begin
    //     if(sys_arstn == 1'b0) begin
    //         inst_data_temp = 32'h0;
    //     end else if(flag_flush == 1'b1) begin
    //         inst_data_temp = NOP;
    //     end else if(final_hold == 1'b1) begin
    //         inst_data_temp = inst_data_temp;
    //     end else begin
    //         inst_data_temp = inst_data_i;
    //     end
    // end

    // assign inst_data_o  = inst_data_temp;

endmodule
