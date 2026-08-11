
module uart_tx (
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    output reg tx
);

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    always @(posedge clk or posedge rst) begin

        if (rst) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            data_reg  <= 8'd0;
            tx        <= 1'b1;
        end

        else begin

            case (state)

                IDLE: begin
                    tx <= 1'b1;

                    if (tx_start) begin
                        data_reg <= tx_data;
                        state <= START;
                    end
                end

                START: begin
                    tx <= 1'b0;
                    bit_count <= 3'd0;
                    state <= DATA;
                end

                DATA: begin
                    tx <= data_reg[bit_count];

                    if (bit_count == 3'd7) begin
                        state <= STOP;
                    end
                    else begin
                        bit_count <= bit_count + 1'b1;
                    end
                end

                STOP: begin
                    tx <= 1'b1;
                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule


module uart_rx (
    input clk,
    input rst,
    input rx,
    output reg [7:0] rx_data,
    output reg rx_valid
);

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    always @(posedge clk or posedge rst) begin

        if (rst) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            data_reg  <= 8'd0;
            rx_data   <= 8'd0;
            rx_valid  <= 1'b0;
        end

        else begin

            rx_valid <= 1'b0;

            case (state)

                IDLE: begin
                    if (rx == 1'b0) begin
                        state <= START;
                    end
                end

                START: begin
                    bit_count <= 3'd0;
                    state <= DATA;
                end

                DATA: begin
                    data_reg[bit_count] <= rx;

                    if (bit_count == 3'd7) begin
                        state <= STOP;
                    end
                    else begin
                        bit_count <= bit_count + 1'b1;
                    end
                end

                STOP: begin
                    rx_data  <= data_reg;
                    rx_valid <= 1'b1;
                    state    <= IDLE;
                end

                default: begin
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule
