module radix4_table (
    input  signed [6:0] dividend_index,
    input         [3:0] divisor_index,
    input         [2:0] dividend_expand,
    input         [1:0] divisor_expand,
    input         [2:0] dividend_expand_ex,
    input         [1:0] divisor_expand_ex,
    output        [2:0] q_table

);

  wire dividend_index_neg = dividend_index[6];

  wire dividend_index_fix = dividend_index_neg ? ~dividend_index + 1 : dividend_index;


  wire d_1000 = (divisor_index == 4'b1000);
  wire d_1001 = (divisor_index == 4'b1001);
  wire d_1010 = (divisor_index == 4'b1010);
  wire d_1011 = (divisor_index == 4'b1011);
  wire d_1100 = (divisor_index == 4'b1100);
  wire d_1101 = (divisor_index == 4'b1101);
  wire d_1110 = (divisor_index == 4'b1110);
  wire d_1111 = (divisor_index == 4'b1111);



  wire x_ge_12 = (dividend_index >= 12);
  wire x_ge_14 = (dividend_index >= 14);
  wire x_ge_15 = (dividend_index >= 15);
  wire x_ge_16 = (dividend_index >= 16);
  wire x_ge_18 = (dividend_index >= 18);
  wire x_ge_20 = (dividend_index >= 20);
  wire x_ge_24 = (dividend_index >= 24);
  wire x_ge_22 = (dividend_index >= 22);
  wire x_ge_21 = (dividend_index >= 21);
  wire x_ge_23 = (dividend_index >= 23);
  wire x_ge_4 = (dividend_index >= 4);
  wire x_ge_6 = (dividend_index >= 6);
  wire x_ge_8 = (dividend_index >= 8);

  wire x_ge_neg4 = (dividend_index >= -4);
  wire x_ge_neg6 = (dividend_index >= -6);
  wire x_ge_neg8 = (dividend_index >= -8);

  wire x_ge_neg13 = (dividend_index >= -13);
  wire x_ge_neg15 = (dividend_index >= -15);
  wire x_ge_neg16 = (dividend_index >= -16);
  wire x_ge_neg18 = (dividend_index >= -18);
  wire x_ge_neg20 = (dividend_index >= -20);
  wire x_ge_neg22 = (dividend_index >= -22);
  wire x_ge_neg24 = (dividend_index >= -24);
  wire x_ge_neg23 = (dividend_index >= -23);
  wire x_ge_neg25 = (dividend_index >= -25);


  wire d_1000_q_2 = (d_1000 & x_ge_12);
  wire d_1000_q_1 = (d_1000 & x_ge_4 & ~x_ge_12);
  wire d_1000_q_0 = (d_1000 & ~x_ge_4 & x_ge_neg4);
  wire d_1000_q_neg1 = (d_1000 & x_ge_neg13 & ~x_ge_neg4);
  wire d_1000_q_neg2 = (d_1000 & ~x_ge_neg13);


  wire d_1001_q_2 = (d_1001 & x_ge_14);
  wire d_1001_q_1 = (d_1001 & x_ge_4 & ~x_ge_14);
  wire d_1001_q_0 = (d_1001 & x_ge_neg6 & ~x_ge_4);
  wire d_1001_q_neg1 = (d_1001 & x_ge_neg15 & ~x_ge_neg6);
  wire d_1001_q_neg2 = (d_1001 & ~x_ge_neg15);

  wire d_1010_q_2 = (d_1010 & x_ge_15);
  wire d_1010_q_1 = (d_1010 & x_ge_4 & ~x_ge_15);
  wire d_1010_q_0 = (d_1010 & x_ge_neg6 & ~x_ge_4);
  wire d_1010_q_neg1 = (d_1010 & x_ge_neg16 & ~x_ge_neg6);
  wire d_1010_q_neg2 = (d_1010 & ~x_ge_neg16);

  wire d_1011_q_2 = (d_1011 & x_ge_16);
  wire d_1011_q_1 = (d_1011 & x_ge_4 & ~x_ge_16);
  wire d_1011_q_0 = (d_1011 & x_ge_neg6 & ~x_ge_4);
  wire d_1011_q_neg1 = (d_1011 & x_ge_neg18 & ~x_ge_neg6);
  wire d_1011_q_neg2 = (d_1011 & ~x_ge_neg18);

  wire d_1100_q_2 = (d_1100 & x_ge_18);
  wire d_1100_q_1 = (d_1100 & x_ge_6 & ~x_ge_18);
  wire d_1100_q_0 = (d_1100 & x_ge_neg8 & ~x_ge_6);
  wire d_1100_q_neg1 = (d_1100 & x_ge_neg20 & ~x_ge_neg8);
  wire d_1100_q_neg2 = (d_1100 & ~x_ge_neg20);

  wire d_1101_q_2 = (d_1101 & x_ge_20);
  wire d_1101_q_1 = (d_1101 & x_ge_6 & ~x_ge_20);
  wire d_1101_q_0 = (d_1101 & x_ge_neg8 & ~x_ge_6);
  wire d_1101_q_neg1 = (d_1101 & x_ge_neg20 & ~x_ge_neg8);
  wire d_1101_q_neg2 = (d_1101 & ~x_ge_neg20);

  wire d_1110_q_2 = (d_1110 & x_ge_22);
  wire d_1110_q_1 = (d_1110 & x_ge_8 & ~x_ge_22);
  wire d_1110_q_0 = (d_1110 & x_ge_neg8 & ~x_ge_8);
  wire d_1110_q_neg1 = (d_1110 & x_ge_neg22 & ~x_ge_neg8);
  wire d_1110_q_neg2 = (d_1110 & ~x_ge_neg22);
  //23/15-->2
  wire sel1=(divisor_expand==0)|((dividend_expand >= 2)&(divisor_expand==1))|
((dividend_expand >=4)&(divisor_expand==2))|
((divisor_expand==3)&(
((dividend_expand ==7)&(  ((divisor_expand_ex==1))    | ((divisor_expand_ex==3)&(dividend_expand_ex>=4)) |  ((divisor_expand_ex==2))  |((divisor_expand_ex==0))   )  )|
(((dividend_expand ==6))&(  ((divisor_expand_ex==0))   |   ((dividend_expand_ex >=3)&(divisor_expand_ex==1))   )       )      ));//|((dividend_expand ==7)&(divisor_expand==3));


  //-24/15-->-1
  wire sel2=((dividend_expand >= 4)&(divisor_expand==2))|(
(   (   ((divisor_expand_ex==3)&({dividend_expand[0],dividend_expand_ex} >=5)) | ((divisor_expand_ex==2)&({dividend_expand[0],dividend_expand_ex} >=10))  )   |   (dividend_expand>=2)   )   &(divisor_expand==3)
);

  wire d_1111_q_2 = sel1 ? (d_1111 & x_ge_23) : (d_1111 & x_ge_24);  //
  wire d_1111_q_1 = sel1 ? (d_1111 & x_ge_8 & ~x_ge_23) : (d_1111 & x_ge_8 & ~x_ge_24);
  wire d_1111_q_0 = (d_1111 & x_ge_neg8 & ~x_ge_8);
  wire d_1111_q_neg1 = sel2?(d_1111 & x_ge_neg24 & ~x_ge_neg8 ):(d_1111 & x_ge_neg23 & ~x_ge_neg8 ) ;
  wire d_1111_q_neg2 = sel2 ? (d_1111 & ~x_ge_neg24) : (d_1111 & ~x_ge_neg23);


  wire q_2 = d_1111_q_2 | d_1110_q_2 | d_1101_q_2 | d_1100_q_2
			| d_1011_q_2 | d_1010_q_2 | d_1001_q_2 | d_1000_q_2;

  wire q_1 = d_1111_q_1 | d_1110_q_1 | d_1101_q_1 | d_1100_q_1
			| d_1011_q_1 | d_1010_q_1 | d_1001_q_1 | d_1000_q_1;

  wire q_0 = d_1111_q_0 | d_1110_q_0 | d_1101_q_0 | d_1100_q_0
			| d_1011_q_0 | d_1010_q_0 | d_1001_q_0 | d_1000_q_0;

  wire q_neg1 = d_1111_q_neg1 | d_1110_q_neg1 | d_1101_q_neg1 | d_1100_q_neg1
			| d_1011_q_neg1 | d_1010_q_neg1 | d_1001_q_neg1 | d_1000_q_neg1;

  wire q_neg2 = d_1111_q_neg2 | d_1110_q_neg2 | d_1101_q_neg2 | d_1100_q_neg2
			| d_1011_q_neg2 | d_1010_q_neg2 | d_1001_q_neg2 | d_1000_q_neg2;

  assign q_table = {
    (q_neg2 | q_neg1), ((q_2 | q_neg2) ? 2'b10 : (q_1 | q_neg1) ? 2'b01 : q_0 ? 2'b00 : 2'b00)
  };



endmodule
