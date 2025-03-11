module r8_qds (
    input  [32+5:0] divisor_real,
    input  [   3:0] divisor_index,
    input  [32+5:0] w_reg,
    output [   2:0] q_table2,
    output [32+5:0] w_reg2,
    output [   3:0] q_table,
    output [   3:0] q_2_0,
    output [   3:0] q_1_0,
    output [   3:0] q_table_com_0
);

  parameter DW = 32;
  wire [1:0] q_table1;
  wire [3:0] q_table2_temp = q_table2[2] ? {q_table2[2], (~q_table2[1:0] + 1)} : q_table2;
  //wire [2:0] q_table2;
  wire [3:0] q_2 = {q_table2_temp[2], q_table2_temp};
  wire [3:0] q_1=(q_table1==2'b01)?4'd4:(q_table1==2'b10)?4'b1100:(q_table1==2'b00)?4'd0:4'd0;

  wire [3:0] q_table_com = q_2 + q_1;
  assign q_table = q_table_com[3] ? {q_table_com[3], (~q_table_com[2:0] + 1)} : q_table_com;

  wire        [DW+5:0] divisor_4_real = divisor_real << 2;
  wire        [DW+5:0] divisor_4_neg = (~divisor_real + 1'b1) << 2;

  wire signed [   6:0] dividend_index1 = w_reg[DW+5:DW-1];  //

  assign  w_reg2 = (q_table1==2'b01)? divisor_4_neg + w_reg:
 (q_table1==2'b10)? divisor_4_real + w_reg:
 (q_table1==2'b00)?w_reg:
 w_reg;

  wire signed [6:0] dividend_index2 = w_reg2[DW+5:DW-1];
  wire        [2:0] dividend_expand = w_reg2[DW-2:DW-4];
  wire        [1:0] divisor_expand = divisor_real[DW-2:DW-3];

  //to tst
  wire        [2:0] dividend_expand_ex = w_reg2[DW-5:DW-7];
  wire        [1:0] divisor_expand2_ex = divisor_real[DW-4:DW-5];

  r8_table u1 (
      .dividend_index(dividend_index1),
      .divisor_index (divisor_index),

      .q_table1(q_table1)

  );

  radix4_table u2 (
      .dividend_index    (dividend_index2),
      .divisor_index     (divisor_index),
      .dividend_expand   (dividend_expand),
      .divisor_expand    (divisor_expand),
      .dividend_expand_ex(dividend_expand_ex),
      .divisor_expand_ex (divisor_expand2_ex),
      .q_table           (q_table2)

  );
  assign q_2_0         = q_2;
  assign q_1_0         = q_1;
  assign q_table_com_0 = q_table_com;


endmodule
