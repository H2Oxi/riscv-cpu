module on_the_fly_conversion (
    input clk,
    input rst_n,

    input [3:0] q_in,
    input [1:0] state_in,

    output [31:0] q_out

);

  reg [31:0] qm_reg;
  reg [31:0] q_reg;

  wire q_in_0110 = (q_in == 4'b0110);
  wire q_in_0101 = (q_in == 4'b0101);
  wire q_in_0100 = (q_in == 4'b0100);
  wire q_in_0011 = (q_in == 4'b0011);
  wire q_in_0010 = (q_in == 4'b0010);
  wire q_in_0001 = (q_in == 4'b0001);
  wire q_in_0000 = (q_in[2:0] == 3'b000);
  wire q_in_1110 = (q_in == 4'b1110);
  wire q_in_1101 = (q_in == 4'b1101);
  wire q_in_1100 = (q_in == 4'b1100);
  wire q_in_1011 = (q_in == 4'b1011);
  wire q_in_1010 = (q_in == 4'b1010);
  wire q_in_1001 = (q_in == 4'b1001);

  wire active = (state_in == 2'b01);

  wire[31:0] q_next  =(active & q_in_0110) ? {q_reg[28:0] , 3'b110 } :
 (active & q_in_0101) ? {q_reg[28:0] , 3'b101 } :
(active & q_in_0100) ? {q_reg[28:0] , 3'b100 } :
(active & q_in_0011) ? {q_reg[28:0] , 3'b011 } :
                    (active & q_in_0010) ? {q_reg[28:0] , 3'b010 } :
						(active & q_in_0001) ? {q_reg[28:0] , 3'b001 } :
							(active & q_in_0000) ? {q_reg[28:0] , 3'b000 } :
								(active & q_in_1001) ? {qm_reg[28:0] , 3'b111 } :
									(active & q_in_1010) ? {qm_reg[28:0] , 3'b110 } :
									(active & q_in_1011) ? {qm_reg[28:0] , 3'b101 } :
									(active & q_in_1100) ? {qm_reg[28:0] , 3'b100 } :
									(active & q_in_1101) ? {qm_reg[28:0] , 3'b011 } :
									(active & q_in_1110) ? {qm_reg[28:0] , 3'b010 } : 32'b0;
  wire[31:0] qm_next  =(active & q_in_0110) ? {q_reg[28:0] , 3'b101 } :
 (active & q_in_0101) ? {q_reg[28:0] , 3'b100 } :
(active & q_in_0100) ? {q_reg[28:0] , 3'b011 } :
(active & q_in_0011) ? {q_reg[28:0] , 3'b010 } :
                    (active & q_in_0010) ? {q_reg[28:0] , 3'b001 } :
						(active & q_in_0001) ? {q_reg[28:0] , 3'b000 } :
							(active & q_in_0000) ? {qm_reg[28:0] , 3'b111 } :
								(active & q_in_1001) ? {qm_reg[28:0] , 3'b110 } :
									(active & q_in_1010) ? {qm_reg[28:0] , 3'b101 } :
									(active & q_in_1011) ? {qm_reg[28:0] , 3'b100 } :
									(active & q_in_1100) ? {qm_reg[28:0] , 3'b011 } :
									(active & q_in_1101) ? {qm_reg[28:0] , 3'b010 } :
									(active & q_in_1110) ? {qm_reg[28:0] , 3'b001 } : 32'b0;


  //2bit shift reg
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      qm_reg <= 0;
      q_reg  <= 0;

    end else begin
      qm_reg <= qm_next;
      q_reg  <= q_next;

    end
  end

  assign q_out = q_reg;
endmodule
