`timescale 10ps/1ps
module TB ();

  wire    tx;

  reg     sys_clk;
  reg     sys_arstn;
  reg     rx;

  integer j;

  initial begin
    sys_clk = 1'b1;
    sys_arstn <= 1'b0;
    rx        <= 1'b1;
    #20;
    sys_arstn <= 1'b1;
  end

  initial begin
    #201;
    rx_byte();
  end

  // initial begin
  //   $vcdpluson;
  //   $vcdplusmemon;
  //   $vcdplusdeltacycleon;
  // end

  always #10 sys_clk = ~sys_clk;

  task rx_byte();
    begin
      rx_bit(8'h00);
      rx_bit(8'h00);
      rx_bit(8'h20);
      rx_bit(8'h83);
      rx_bit(8'h00);
      rx_bit(8'h40);
      rx_bit(8'h21);
      rx_bit(8'h03);
      rx_bit(8'h02);
      rx_bit(8'h11);
      rx_bit(8'h71);
      rx_bit(8'hb3);
      rx_bit(8'h00);
      rx_bit(8'h30);
      rx_bit(8'h24);
      rx_bit(8'h23);
      for (j = 0; j < 48; j = j + 1) rx_bit(8'h00);
      rx_bit(8'h00);
      rx_bit(8'h00);
      rx_bit(8'h00);
      rx_bit(8'h0a);
      rx_bit(8'h00);
      rx_bit(8'h00);
      rx_bit(8'h00);
      rx_bit(8'h45);
      for (j = 0; j < 24; j = j + 1) rx_bit(8'h00);
      #3000000;
      $finish;
    end
  endtask

  task rx_bit(input [7:0] data);
    integer i;
    for (i = 0; i < 10; i = i + 1) begin
      case (i)
        0: rx <= 1'b0;
        1: rx <= data[0];
        2: rx <= data[1];
        3: rx <= data[2];
        4: rx <= data[3];
        5: rx <= data[4];
        6: rx <= data[5];
        7: rx <= data[6];
        8: rx <= data[7];
        9: rx <= 1'b1;
      endcase
      #(434 * 20);
    end
  endtask

  TOP TOP_inst (
      .sys_clk  (sys_clk),
      .sys_arstn(sys_arstn),
      .rx       (rx),
      .tx       (tx)
  );

endmodule
