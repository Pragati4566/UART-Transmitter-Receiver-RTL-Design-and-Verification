module testbench;

    reg clk;
    reg rst;

    reg tx_start;
    reg [7:0] tx_data;

    wire tx_line;

    wire [7:0] rx_data;
    wire rx_valid;


    uart_tx transmitter (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx_line)
    );


    uart_rx receiver (
        .clk(clk),
        .rst(rst),
        .rx(tx_line),
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );


    always #5 clk = ~clk;


    initial begin

        $dumpfile("uart_waveform.vcd");
        $dumpvars(0, testbench);

        clk      = 1'b0;
        rst      = 1'b1;
        tx_start = 1'b0;
        tx_data  = 8'b00000000;

        #10;
        rst = 1'b0;

        tx_data = 8'b10101010;

        tx_start = 1'b1;

        #10;

        tx_start = 1'b0;

        #150;

        $display("Transmitted Data = %b", tx_data);
        $display("Received Data    = %b", rx_data);

        $finish;

    end

endmodule
