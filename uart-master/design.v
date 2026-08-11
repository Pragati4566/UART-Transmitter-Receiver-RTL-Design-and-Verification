module uart_tx #(
    parameter DATA_WIDTH = 8,
    parameter CLK_FREQ_HZ = 1000000,
    parameter BAUD_RATE = 100000
)(
    input clk,
    input rst,
    input tx_start,
    input [DATA_WIDTH-1:0] tx_data,
    output reg tx
);

    localparam integer CLKS_PER_BIT = CLK_FREQ_HZ / BAUD_RATE;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [DATA_WIDTH-1:0] data_reg;

    integer bit_count;
    integer baud_count;

    always @(posedge clk or posedge rst) begin

        if (rst) begin
            state      <= IDLE;
            data_reg   <= 0;
            bit_count  <= 0;
            baud_count <= 0;
            tx         <= 1'b1;
        end

        else begin

            case (state)

                IDLE: begin
                    tx         <= 1'b1;
                    baud_count <= 0;
                    bit_count  <= 0;

                    if (tx_start) begin
                        data_reg <= tx_data;
                        state    <= START;
                    end
                end

                START: begin
                    tx <= 1'b0;

                    if (baud_count == CLKS_PER_BIT-1) begin
                        baud_count <= 0;
                        state      <= DATA;
                    end
                    else begin
                        baud_count <= baud_count + 1;
                    end
                end

                DATA: begin
                    tx <= data_reg[bit_count];

                    if (baud_count == CLKS_PER_BIT-1) begin
                        baud_count <= 0;

                        if (bit_count == DATA_WIDTH-1) begin
                            bit_count <= 0;
                            state     <= STOP;
                        end
                        else begin
                            bit_count <= bit_count + 1;
                        end
                    end
                    else begin
                        baud_count <= baud_count + 1;
                    end
                end

                STOP: begin
                    tx <= 1'b1;

                    if (baud_count == CLKS_PER_BIT-1) begin
                        baud_count <= 0;
                        state      <= IDLE;
                    end
                    else begin
                        baud_count <= baud_count + 1;
                    end
                end

                default: begin
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule


module uart_rx #(
    parameter DATA_WIDTH = 8,
    parameter CLK_FREQ_HZ = 1000000,
    parameter BAUD_RATE = 100000
)(
    input clk,
    input rst,
    input rx,
    output reg [DATA_WIDTH-1:0] rx_data,
    output reg rx_valid
);

    localparam integer CLKS_PER_BIT = CLK_FREQ_HZ / BAUD_RATE;
    localparam integer HALF_BIT = CLKS_PER_BIT / 2;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [DATA_WIDTH-1:0] data_reg;

    integer bit_count;
    integer baud_count;

    always @(posedge clk or posedge rst) begin

        if (rst) begin
            state      <= IDLE;
            data_reg   <= 0;
            rx_data    <= 0;
            rx_valid   <= 1'b0;
            bit_count  <= 0;
            baud_count <= 0;
        end

        else begin

            rx_valid <= 1'b0;

            case (state)

                IDLE: begin
                    baud_count <= 0;
                    bit_count  <= 0;

                    if (rx == 1'b0) begin
                        state <= START;
                    end
                end

                START: begin

                    if (baud_count == HALF_BIT-1) begin
                        baud_count <= 0;

                        if (rx == 1'b0) begin
                            state <= DATA;
                        end
                        else begin
                            state <= IDLE;
                        end
                    end
                    else begin
                        baud_count <= baud_count + 1;
                    end
                end

                DATA: begin

                    if (baud_count == CLKS_PER_BIT-1) begin
                        baud_count <= 0;

                        data_reg[bit_count] <= rx;

                        if (bit_count == DATA_WIDTH-1) begin
                            bit_count <= 0;
                            state     <= STOP;
                        end
                        else begin
                            bit_count <= bit_count + 1;
                        end
                    end
                    else begin
                        baud_count <= baud_count + 1;
                    end
                end

                STOP: begin

                    if (baud_count == CLKS_PER_BIT-1) begin
                        baud_count <= 0;

                        rx_data  <= data_reg;
                        rx_valid <= 1'b1;
                        state    <= IDLE;
                    end
                    else begin
                        baud_count <= baud_count + 1;
                    end
                end

                default: begin
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule
