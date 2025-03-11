module FRAG_adder #(
    parameter DATAWIDTH = 32
)(
    input  [DATAWIDTH - 1 : 0]  data_in_0   ,
    input  [DATAWIDTH - 1 : 0]  data_in_1   ,
    output [DATAWIDTH - 1 : 0]  data_out
);

    assign data_out = data_in_0 + data_in_1;

endmodule