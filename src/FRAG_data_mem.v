module FRAG_data_mem #(
    parameter   UART_BPS    =   115200,     
    parameter   CLK_FREQ    =   50000000
)(
    input               sys_clk     ,
    input               sys_arstn   ,
    input       [ 7:0]  ctrl        ,
    input               en_addr_data,
    input       [ 4:0]  addr_data   ,
    input       [31:0]  data_data   ,
    input       [31:0]  addr        ,
    input       [31:0]  data_in     ,
    input               flag        ,
    output  reg [31:0]  data_out    ,
    output  reg         tx
);
    
    localparam LB  = 3'b000;
    localparam LH  = 3'b001;
    localparam LW  = 3'b010;
    localparam LBU = 3'b100;
    localparam LHU = 3'b101;

    localparam SB  = 3'b000;
    localparam SH  = 3'b001;
    localparam SW  = 3'b010;

    localparam  BAUD_CNT_MAX    =   CLK_FREQ / UART_BPS ;
    
    reg     [ 0:3]  cs                      ;
    reg     [ 7:0]  ctrl_delay1             ;
    reg     [31:0]  data_in_temp            ;
    reg     [ 7:0]  mem_0            [0:7]  ;
    reg     [ 7:0]  mem_1            [0:7]  ;
    reg     [ 7:0]  mem_2            [0:7]  ;
    reg     [ 7:0]  mem_3            [0:7]  ;
    reg     [ 7:0]  data_out_temp_0         ;
    reg     [ 7:0]  data_out_temp_1         ;
    reg     [ 7:0]  data_out_temp_2         ;
    reg     [ 7:0]  data_out_temp_3         ;
    
    reg     [ 8:0]  baud_cnt                ;
    reg             bit_flag                ;
    reg     [ 3:0]  bit_cnt                 ;
    reg             work_en                 ;

    wire            pi_flag                 ;
    reg     [ 7:0]  pi_data                 ;

    reg     [ 4:0]  byte_cnt                ;
    reg             byte_cnt_delay1         ;
    reg             byte_cnt_delay0         ;
    reg             stop                    ;

    integer i_0;
    integer i_1;
    integer i_2;
    integer i_3;

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            stop <= 1'b0;
        end else if((bit_flag == 1'b1) & (bit_cnt == 4'd9) & (byte_cnt == 5'b11111)) begin
            stop <= 1'b1;
        end
    end

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            byte_cnt <= 5'b11111;
        end else if(stop == 1'b1) begin
            byte_cnt <= byte_cnt;
        end else if((work_en == 1'b1) | (pi_flag == 1'b1)) begin
            byte_cnt <= byte_cnt; 
        end else if((flag == 1'b1) | (byte_cnt != 5'b11111)) begin
            byte_cnt <= byte_cnt + 8'b1; 
        end 
    end

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            byte_cnt_delay0 <= 1'b0;
        end else begin
            byte_cnt_delay0 <= byte_cnt[0]; 
        end
    end

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            byte_cnt_delay1 <= 1'b0;
        end else begin
            byte_cnt_delay1 <= byte_cnt[1]; 
        end
    end

    assign pi_flag = ((byte_cnt == 5'b11111) & (byte_cnt_delay1 == 1'b0) & (byte_cnt_delay0 == 1'b0)) ? 1'b0 : (byte_cnt_delay0 ^ byte_cnt[0]);
    
    always @(*) begin
        case(byte_cnt[1:0])
            2'b00   :   pi_data <= mem_0[byte_cnt[4:2]] ;
            2'b01   :   pi_data <= mem_1[byte_cnt[4:2]] ;
            2'b10   :   pi_data <= mem_2[byte_cnt[4:2]] ;
            2'b11   :   pi_data <= mem_3[byte_cnt[4:2]] ;
            default :   pi_data <= 8'b0                 ;
        endcase
    end

    always@(posedge sys_clk or negedge sys_arstn)
        if(sys_arstn == 1'b0)
            work_en <= 1'b0;
        else    if(pi_flag == 1'b1)
            work_en <= 1'b1;
        else    if((bit_flag == 1'b1) && (bit_cnt == 4'd9))
            work_en <= 1'b0;

    always@(posedge sys_clk or negedge sys_arstn)
        if(sys_arstn == 1'b0)
            baud_cnt <= 9'b0;
        else    if((baud_cnt == BAUD_CNT_MAX - 1) || (work_en == 1'b0))
            baud_cnt <= 9'b0;
        else    if(work_en == 1'b1)
            baud_cnt <= baud_cnt + 1'b1;

    always@(posedge sys_clk or negedge sys_arstn)
        if(sys_arstn == 1'b0)
            bit_flag <= 1'b0;
        else    if(baud_cnt == 9'd1)
            bit_flag <= 1'b1;
        else
            bit_flag <= 1'b0;

    always@(posedge sys_clk or negedge sys_arstn)
        if(sys_arstn == 1'b0)
            bit_cnt <= 4'b0;
        else    if((bit_flag == 1'b1) && (bit_cnt == 4'd10))
            bit_cnt <= 4'b0;
        else    if((bit_flag == 1'b1) && (work_en == 1'b1))
            bit_cnt <= bit_cnt + 1'b1;

    always@(posedge sys_clk or negedge sys_arstn)
        if(sys_arstn == 1'b0)
            tx <= 1'b1;
        else    if(bit_flag == 1'b1)
            case(bit_cnt)
                0       : tx <= 1'b0;
                1       : tx <= pi_data[0];
                2       : tx <= pi_data[1];
                3       : tx <= pi_data[2];
                4       : tx <= pi_data[3];
                5       : tx <= pi_data[4];
                6       : tx <= pi_data[5];
                7       : tx <= pi_data[6];
                8       : tx <= pi_data[7];
                9       : tx <= 1'b1;
                10      : tx <= 1'b1;
                default : tx <= 1'b1;
            endcase

    // assign cs = (ctrl[7] & ctrl[3] == 1'b1) ? 4'b1111 : 4'b0000;
    always @(*) begin
        if(ctrl[7] == 1'b1) begin
            case(ctrl[6:4])
                LB      :   case(addr[1:0])
                                2'b00   :   cs = 4'b1000;
                                2'b01   :   cs = 4'b0100;
                                2'b10   :   cs = 4'b0010;
                                2'b11   :   cs = 4'b0001;
                                default :   cs = 4'b0000;
                            endcase
                LH      :   case(addr[1])
                                1'b0    :   cs = 4'b1100;
                                1'b1    :   cs = 4'b0011;
                                default :   cs = 4'b0000;
                            endcase
                LW      :                   cs = 4'b1111;
                LBU     :   case(addr[1:0])
                                2'b00   :   cs = 4'b1000;
                                2'b01   :   cs = 4'b0100;
                                2'b10   :   cs = 4'b0010;
                                2'b11   :   cs = 4'b0001;
                                default :   cs = 4'b0000;
                            endcase
                LHU     :   case(addr[1])
                                1'b0    :   cs = 4'b1100;
                                1'b1    :   cs = 4'b0011;
                                default :   cs = 4'b0000;
                            endcase
                default :                   cs = 4'b0000;
            endcase
        end else if(ctrl[3] == 1'b1) begin
            case(ctrl[2:0])
                SB      :   case(addr[1:0])
                                2'b00   :   cs = 4'b1000;
                                2'b01   :   cs = 4'b0100;
                                2'b10   :   cs = 4'b0010;
                                2'b11   :   cs = 4'b0001;
                                default :   cs = 4'b0000;
                            endcase
                SH      :   case(addr[1])
                                1'b0    :   cs = 4'b1100;
                                1'b1    :   cs = 4'b0011;
                                default :   cs = 4'b0000;
                            endcase
                SW      :                   cs = 4'b1111;
                default :                   cs = 4'b0000;
            endcase
        end else begin
            cs = 4'b0000;
        end
    end

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            ctrl_delay1 <= 8'b0;
        end else begin
            ctrl_delay1 <= ctrl;
        end
    end
    
    // assign data_in_temp = data_in;
    always @(*) begin
        if(ctrl[3] == 1'b1) begin
            case(ctrl[2:0])
                SB      :   case(addr[1:0])
                                2'b00   :   data_in_temp = {data_in[7:0], 24'b0}        ;
                                2'b01   :   data_in_temp = {8'b0, data_in[7:0], 16'b0}  ;
                                2'b10   :   data_in_temp = {16'b0, data_in[7:0], 8'b0}  ;
                                2'b11   :   data_in_temp = {24'b0, data_in[7:0]}        ;
                                default :   data_in_temp = 32'h0                        ;
                            endcase
                SH      :   case(addr[1])
                                1'b0    :   data_in_temp = {data_in[15:0], 16'b0}       ;
                                1'b1    :   data_in_temp = {16'b0, data_in[15:0]}       ;
                                default :   data_in_temp = 32'h0                        ;
                            endcase
                SW      :                   data_in_temp = data_in                      ;
                default :                   data_in_temp = 32'h0                        ;
            endcase
        end else begin
            data_in_temp = 32'h0;
        end
    end
    
    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            for(i_0 = 0; i_0 <= 7; i_0 = i_0 + 1) begin
                mem_0[i_0] <= 8'h0;
            end
        // end else if(ctrl[3] == 1'b1) begin
        end else if(en_addr_data == 1'b1) begin
            mem_0[addr_data[4:2]] <= data_data[31:24];
        end else if((cs[0] == 1'b1) && (ctrl[3] == 1'b1))begin
            mem_0[addr[4:2]] <= data_in_temp[31:24];
        end
    end
    
    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            for(i_1 = 0; i_1 <= 7; i_1 = i_1 + 1) begin
                mem_1[i_1] <= 8'h0;
            end
        // end else if(ctrl[3] == 1'b1) begin
        end else if(en_addr_data == 1'b1) begin
            mem_1[addr_data[4:2]] <= data_data[23:16];
        end else if((cs[1] == 1'b1) && (ctrl[3] == 1'b1))begin
            mem_1[addr[4:2]] <= data_in_temp[23:16];
        end
    end
    
    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            for(i_2 = 0; i_2 <= 7; i_2 = i_2 + 1) begin
                mem_2[i_2] <= 8'h0;
            end
        // end else if(ctrl[3] == 1'b1) begin
        end else if(en_addr_data == 1'b1) begin
            mem_2[addr_data[4:2]] <= data_data[15:8];
        end else if((cs[2] == 1'b1) && (ctrl[3] == 1'b1))begin
            mem_2[addr[4:2]] <= data_in_temp[15:8];
        end
    end
    
    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            for(i_3 = 0; i_3 <= 7; i_3 = i_3 + 1) begin
                mem_3[i_3] <= 8'h0;
            end
        // end else if(ctrl[3] == 1'b1) begin
        end else if(en_addr_data == 1'b1) begin
            mem_3[addr_data[4:2]] <= data_data[7:0];
        end else if((cs[3] == 1'b1) && (ctrl[3] == 1'b1))begin
            mem_3[addr[4:2]] <= data_in_temp[7:0];
        end
    end
    
    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            data_out_temp_0 <= 8'h0;
        // end else if(ctrl[7] == 1'b1) begin
        end else if((cs[0] == 1'b1) & (ctrl[7] == 1'b1))begin
            data_out_temp_0 <= mem_0[addr[4:2]];
        end
    end
    
    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            data_out_temp_1 <= 8'h0;
        // end else if(ctrl[7] == 1'b1) begin
        end else if((cs[1] == 1'b1) & (ctrl[7] == 1'b1))begin
            data_out_temp_1 <= mem_1[addr[4:2]];
        end
    end
    
    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            data_out_temp_2 <= 8'h0;
        // end else if(ctrl[7] == 1'b1) begin
        end else if((cs[2] == 1'b1)  & (ctrl[7] == 1'b1))begin
            data_out_temp_2 <= mem_2[addr[4:2]];
        end
    end
    
    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            data_out_temp_3 <= 8'h0;
        // end else if(ctrl[7] == 1'b1) begin
        end else if((cs[3] == 1'b1) & (ctrl[7] == 1'b1))begin
            data_out_temp_3 <= mem_3[addr[4:2]];
        end
    end

    // assign data_out = (ctrl[7] == 1'b1) ? {data_out_temp_0, data_out_temp_1, data_out_temp_2, data_out_temp_3} : 32'h0;
    always @(*) begin
        if(ctrl_delay1[7] == 1'b1) begin
            case(ctrl_delay1[6:4])
                LB      :   case(addr[1:0])
                                2'b00   :   data_out = {{24{data_out_temp_0[7]}}, data_out_temp_0}                          ;
                                2'b01   :   data_out = {{24{data_out_temp_1[7]}}, data_out_temp_1}                          ;
                                2'b10   :   data_out = {{24{data_out_temp_2[7]}}, data_out_temp_2}                          ;
                                2'b11   :   data_out = {{24{data_out_temp_3[7]}}, data_out_temp_3}                          ;
                                default :   data_out = 32'h0                                                                ;
                            endcase
                LH      :   case(addr[1])
                                1'b0    :   data_out = {{16{data_out_temp_0[7]}}, data_out_temp_0, data_out_temp_1}         ;
                                1'b1    :   data_out = {{16{data_out_temp_2[7]}}, data_out_temp_2, data_out_temp_3}         ;
                                default :   data_out = 32'h0                                                                ;
                            endcase
                LW      :                   data_out = {data_out_temp_0, data_out_temp_1, data_out_temp_2, data_out_temp_3} ;
                LBU     :   case(addr[1:0])                         
                                2'b00   :   data_out = {{24{1'b0}}, data_out_temp_0}                                        ;
                                2'b01   :   data_out = {{24{1'b0}}, data_out_temp_1}                                        ;
                                2'b10   :   data_out = {{24{1'b0}}, data_out_temp_2}                                        ;
                                2'b11   :   data_out = {{24{1'b0}}, data_out_temp_3}                                        ;
                                default :   data_out = 32'h0                                                                ;
                            endcase
                LHU     :   case(addr[1])
                                1'b0    :   data_out = {{24{1'b0}}, data_out_temp_0, data_out_temp_1}                       ;
                                1'b1    :   data_out = {{24{1'b0}}, data_out_temp_2, data_out_temp_3}                       ;
                                default :   data_out = 32'h0                                                                ;
                            endcase
                default :                   data_out = 32'h0                                                                ;
            endcase
        end else begin
            data_out = 32'h0;
        end
    end
    
endmodule