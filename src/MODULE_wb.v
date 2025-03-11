module MODULE_wb(
    input   [ 1:0]  wb_ctrl_i       ,
    input   [31:0]  wb_data_i       ,
    input   [31:0]  data_i          ,
    input   [ 4:0]  wb_Rd_i         ,
    output  [ 4:0]  wb_Rd_o         ,
    output          RegWrite_o      ,
    output  [31:0]  w_data_o
);
    assign wb_Rd_o = wb_Rd_i;
    assign RegWrite_o = wb_ctrl_i[1];
    assign w_data_o = (wb_ctrl_i[0] == 1'b0) ? wb_data_i : data_i;
    
endmodule
