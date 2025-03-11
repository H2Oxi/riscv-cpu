module r8_table (
    input signed [6:0] dividend_index,
    input        [3:0] divisor_index,

    output [1:0] q_table1  //00 ->0;01 ->4;10 ->-4
);




  wire d_1000 = (divisor_index == 4'b1000);
  wire d_1001 = (divisor_index == 4'b1001);
  wire d_1010 = (divisor_index == 4'b1010);
  wire d_1011 = (divisor_index == 4'b1011);
  wire d_1100 = (divisor_index == 4'b1100);
  wire d_1101 = (divisor_index == 4'b1101);
  wire d_1110 = (divisor_index == 4'b1110);
  wire d_1111 = (divisor_index == 4'b1111);




  wire x_ge_20 = (dividend_index >= 20);
  wire x_ge_22 = (dividend_index >= 22);
  wire x_ge_25 = (dividend_index >= 25);
  wire x_ge_27 = (dividend_index >= 27);
  wire x_ge_30 = (dividend_index >= 30);
  wire x_ge_32 = (dividend_index >= 32);
  wire x_ge_35 = (dividend_index >= 35);
  wire x_ge_37 = (dividend_index >= 37);



  wire x_ge_neg20 = (dividend_index >= -20);
  wire x_ge_neg22 = (dividend_index >= -22);
  wire x_ge_neg25 = (dividend_index >= -25);
  wire x_ge_neg27 = (dividend_index >= -27);
  wire x_ge_neg30 = (dividend_index >= -30);
  wire x_ge_neg32 = (dividend_index >= -32);
  wire x_ge_neg35 = (dividend_index >= -35);
  wire x_ge_neg37 = (dividend_index >= -37);
  wire x_ge_neg45 = (dividend_index >= -45);
  wire x_ge_neg40 = (dividend_index >= -40);
  wire x_ge_neg39 = (dividend_index >= -39);
  wire x_ge_neg38 = (dividend_index >= -38);

  wire d_1000_q_4 = (d_1000 & x_ge_20);
  wire d_1000_q_0 = (d_1000 & ~x_ge_20 & x_ge_neg20);
  wire d_1000_q_neg4 = (d_1000 & ~x_ge_neg20);

  wire d_1001_q_4 = (d_1001 & x_ge_22);
  wire d_1001_q_0 = (d_1001 & ~x_ge_22 & x_ge_neg22);
  wire d_1001_q_neg4 = (d_1001 & ~x_ge_neg22);

  wire d_1010_q_4 = (d_1010 & x_ge_25);
  wire d_1010_q_0 = (d_1010 & ~x_ge_25 & x_ge_neg25);
  wire d_1010_q_neg4 = (d_1010 & ~x_ge_neg25);

  wire d_1011_q_4 = (d_1011 & x_ge_27);
  wire d_1011_q_0 = (d_1011 & ~x_ge_27 & x_ge_neg27);
  wire d_1011_q_neg4 = (d_1011 & ~x_ge_neg27);

  wire d_1100_q_4 = (d_1100 & x_ge_30);
  wire d_1100_q_0 = (d_1100 & ~x_ge_30 & x_ge_neg30);
  wire d_1100_q_neg4 = (d_1100 & ~x_ge_neg30);

  wire d_1101_q_4 = (d_1101 & x_ge_32);
  wire d_1101_q_0 = (d_1101 & ~x_ge_32 & x_ge_neg32);
  wire d_1101_q_neg4 = (d_1101 & ~x_ge_neg32);

  wire d_1110_q_4 = (d_1110 & x_ge_35);
  wire d_1110_q_0 = (d_1110 & ~x_ge_35 & x_ge_neg35);
  wire d_1110_q_neg4 = (d_1110 & ~x_ge_neg35);

  wire d_1111_q_4 = (d_1111 & x_ge_37);
  wire d_1111_q_0 = (d_1111 & ~x_ge_37 & x_ge_neg38);
  wire d_1111_q_neg4 = (d_1111 & ~x_ge_neg38);

  wire q_4 = d_1111_q_4 | d_1110_q_4 | d_1101_q_4 | d_1100_q_4
			| d_1011_q_4 | d_1010_q_4 | d_1001_q_4 | d_1000_q_4;

  wire q_0 = d_1111_q_0 | d_1110_q_0 | d_1101_q_0 | d_1100_q_0
			| d_1011_q_0 | d_1010_q_0 | d_1001_q_0 | d_1000_q_0;

  wire q_neg4 = d_1111_q_neg4 | d_1110_q_neg4 | d_1101_q_neg4 | d_1100_q_neg4
			| d_1011_q_neg4 | d_1010_q_neg4 | d_1001_q_neg4 | d_1000_q_neg4;

  assign q_table1 = q_4 ? 2'b01 : q_neg4 ? 2'b10 : q_0 ? 2'b00 : 2'b00;


endmodule
