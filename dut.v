module gray_code_counter (
    input  wire       clk,
    input  wire       rst_n,   // Active-low asynchronous reset
    input  wire       en,      // Enable signal to advance counter
    output reg  [2:0] gray_out // 3-bit Gray code output
);

    // State Encoding using 3-bit Gray Code values directly
    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b011;
    localparam S3 = 3'b010;
    localparam S4 = 3'b110;
    localparam S5 = 3'b111;
    localparam S6 = 3'b101;
    localparam S7 = 3'b100;

    reg [2:0] current_state, next_state;

    // State Register (Sequential Logic)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic (Combinational Logic)
    always @(*) begin
        if (en) begin
            case (current_state)
                S0: next_state = S1;
                S1: next_state = S2;
                S2: next_state = S3;
                S3: next_state = S4;
                S4: next_state = S5;
                S5: next_state = S6;
                S6: next_state = S7;
                S7: next_state = S0; // Wrap around
                default: next_state = S0;
            endcase
        end else begin
            next_state = current_state; // Hold state when enable is low
        end
    end

    // Output Logic (Moore Logic: Output equals current state)
    always @(*) begin
        gray_out = current_state;
    end

endmodule
