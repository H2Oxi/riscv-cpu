module FRAG_UART #(
    parameter   UART_BPS    =   115200,     
    parameter   CLK_FREQ    =   50000000
)(
    input               sys_clk     ,
    input               sys_arstn   ,
    input               rx          ,
    output              en_addr_inst,
    output              en_addr_data,
    output reg  [ 5:0]  addr_inst   ,
    output reg  [ 4:0]  addr_data   ,
    output      [31:0]  data        ,
    output reg          start       

);
    
    localparam  BAUD_CNT_MAX    =   CLK_FREQ / UART_BPS ;
    
    reg         rx_reg1             ;
    reg         rx_reg2             ;
    reg         rx_reg3             ;
    reg         start_nedge         ;
    reg         work_en             ;
    reg [ 9:0]  baud_cnt            ;
    reg         bit_flag            ;
    reg [ 3:0]  bit_cnt             ;
    reg [ 7:0]  rx_data             ;
    reg         rx_flag             ;
        
    reg [ 7:0]  po_data             ;
    reg         po_flag             ;
        
    reg [31:0]  data_temp           ;
    reg         po_flag_delay1      ;
    reg         po_flag_delay2      ;
    reg         en_addr_inst_temp1  ;
    reg         en_addr_inst_temp2  ;
    reg         en_addr_data_temp1  ;
    reg         en_addr_data_temp2  ;

    assign data         = ((en_addr_inst == 1'b1) | (en_addr_data == 1'b1)) ? data_temp : 32'h0;
    assign en_addr_inst = en_addr_inst_temp1 & en_addr_inst_temp2;
    assign en_addr_data = en_addr_data_temp1 & en_addr_data_temp2;

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            en_addr_inst_temp1 <= 1'b0;
        end else if((addr_inst[1:0] == 2'b10) & (po_flag == 1'b1)) begin
            en_addr_inst_temp1 <= 1'b1;
        end else begin
            en_addr_inst_temp1 <= 1'b0;
        end
    end

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            en_addr_data_temp1 <= 1'b0;
        end else if((addr_data[1:0] == 2'b10) & (po_flag == 1'b1)) begin
            en_addr_data_temp1 <= 1'b1; 
        end else begin
            en_addr_data_temp1 <= 1'b0;
        end
    end    
        
    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            en_addr_inst_temp2 <= 1'b1;
        end else if((addr_inst == 6'b111111) & (po_flag_delay2 == 1'b1)) begin
            en_addr_inst_temp2 <= 1'b0; 
        end
    end

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            en_addr_data_temp2 <= 1'b0;
        end else if(start == 1'b1) begin
            en_addr_data_temp2 <= 1'b0; 
        end else if((addr_data == 5'b11111) & (po_flag_delay2 == 1'b1)) begin
            en_addr_data_temp2 <= 1'b0; 
        end else if(en_addr_inst_temp2 == 1'b0) begin
            en_addr_data_temp2 <= 1'b1; 
        end
    end

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            start <= 1'b0;
        end else if((addr_inst == 6'b111111) & (addr_data == 5'b11111) & (en_addr_inst_temp2 == 1'b0) & (en_addr_data_temp2 == 1'b1) & (po_flag_delay2 == 1'b1))begin
            start <= 1'b1;
        end
    end

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            addr_inst <= 6'b111111;
        end else if((en_addr_inst_temp2 == 1'b1) & (po_flag == 1'b1)) begin
            addr_inst <= addr_inst + 6'b1; 
        end
    end

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            addr_data <= 5'b11111;
        end else if((en_addr_data_temp2 == 1'b1) & (po_flag == 1'b1)) begin
            addr_data <= addr_data + 5'b1; 
        end
    end

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            data_temp <= 32'b0;
        end else if(po_flag == 1'b1) begin
            data_temp <= {data_temp[23:0], po_data}; 
        end
    end
    
    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            po_flag_delay1 <= 1'b0;
        end else begin
            po_flag_delay1 <= po_flag; 
        end
    end

    always @(posedge sys_clk, negedge sys_arstn) begin
        if(sys_arstn == 1'b0) begin
            po_flag_delay2 <= 1'b0;
        end else begin
            po_flag_delay2 <= po_flag_delay1; 
        end
    end
    
    always@(posedge sys_clk or negedge sys_arstn)
        if(sys_arstn == 1'b0)
            rx_reg1 <= 1'b1;
        else
            rx_reg1 <= rx;
    
    always@(posedge sys_clk or negedge sys_arstn)
        if(sys_arstn == 1'b0)
            rx_reg2 <= 1'b1;
        else
            rx_reg2 <= rx_reg1;

    always@(posedge sys_clk or negedge sys_arstn)
        if(sys_arstn == 1'b0)
            rx_reg3 <= 1'b1;
        else
            rx_reg3 <= rx_reg2;
    
    always@(posedge sys_clk or negedge sys_arstn)
        if(sys_arstn == 1'b0)
            start_nedge <= 1'b0;
        else    if((~rx_reg2) && (rx_reg3))
            start_nedge <= 1'b1;
        else
            start_nedge <= 1'b0;
    
    always@(posedge sys_clk or negedge sys_arstn)
        if(sys_arstn == 1'b0)
            work_en <= 1'b0;
        else    if(start_nedge == 1'b1)
            work_en <= 1'b1;
        else    if((bit_cnt == 4'd8) && (bit_flag == 1'b1))
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
        else    if(baud_cnt == BAUD_CNT_MAX/2 - 1)
            bit_flag <= 1'b1;
        else
            bit_flag <= 1'b0;
    
    always@(posedge sys_clk or negedge sys_arstn)
        if(sys_arstn == 1'b0)
            bit_cnt <= 4'b0;
        else    if((bit_cnt == 4'd8) && (bit_flag == 1'b1))
            bit_cnt <= 4'b0;
        else    if(bit_flag ==1'b1)
            bit_cnt <= bit_cnt + 1'b1;
    
    always@(posedge sys_clk or negedge sys_arstn)
        if(sys_arstn == 1'b0)
            rx_data <= 8'b0;
        else    if((bit_cnt >= 4'd1)&&(bit_cnt <= 4'd8)&&(bit_flag == 1'b1))
            rx_data <= {rx_reg3, rx_data[7:1]};

    always@(posedge sys_clk or negedge sys_arstn)
        if(sys_arstn == 1'b0)
            rx_flag <= 1'b0;
        else    if((bit_cnt == 4'd8) && (bit_flag == 1'b1))
            rx_flag <= 1'b1;
        else
            rx_flag <= 1'b0;
    
    always@(posedge sys_clk or negedge sys_arstn)
        if(sys_arstn == 1'b0)
            po_data <= 8'b0;
        else    if(rx_flag == 1'b1)
            po_data <= rx_data;
    
    always@(posedge sys_clk or negedge sys_arstn)
        if(sys_arstn == 1'b0)
            po_flag <= 1'b0;
        else
            po_flag <= rx_flag;
    
endmodule