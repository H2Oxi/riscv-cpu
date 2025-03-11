module FRAG_mux_2 #(
    parameter DATAWIDTH = 32
)(
    input  [DATAWIDTH - 1 : 0]  data_in_0   ,
    input  [DATAWIDTH - 1 : 0]  data_in_1   ,
    input                       select      ,
    output [DATAWIDTH - 1 : 0]  data_out
);

    assign data_out = (select == 1'b0) ? data_in_0 : data_in_1;

endmodule