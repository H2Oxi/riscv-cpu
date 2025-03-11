module FRAG_pipline #(
    parameter DataWidth = 32
) (
    input                       sys_clk         ,
    input                       sys_arstn       ,
    input                       flag_flush      ,
    input                       flag_hold       ,
    input   [DataWidth - 1:0]   default_value   ,
    input   [DataWidth - 1:0]   data_in         ,
    output  [DataWidth - 1:0]   data_out
);

    reg [DataWidth - 1:0] data_temp;

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            data_temp <= default_value;
        end else if(flag_flush == 1'b1) begin
            data_temp <= default_value;
        end else if(flag_hold == 1'b1) begin
            data_temp <= data_temp;
        end else begin
            data_temp <= data_in;
        end
    end

    assign data_out = data_temp;

endmodule
