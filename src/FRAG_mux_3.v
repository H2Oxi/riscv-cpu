module FRAG_mux_3 #(
    parameter DATAWIDTH = 32
)(
    input  [DATAWIDTH - 1 : 0]  data_in_0   ,
    input  [DATAWIDTH - 1 : 0]  data_in_1   ,
    input  [DATAWIDTH - 1 : 0]  data_in_2   ,
    input  [            1 : 0]  select      ,
    output [DATAWIDTH - 1 : 0]  data_out
);

    assign data_out = (select[1] == 1'b0) ? 
                        ((select[0] == 1'b0) ? data_in_0 : data_in_1) :
                        data_in_2;

endmodule