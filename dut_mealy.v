module gray_code_counter_mealy (
    input  wire       clk,
    input  wire       rst_n,        // Active-low asynchronous reset
    input  wire       en,           // Control input
    output reg  [2:0] gray_out      // Output depends on current_state AND en
);

    // State Encodings (Gray Code values)
    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b011;
    localparam S3 = 3'b010;
    localparam S4 = 3'b110;
    localparam S5 = 3'b111;
    localparam S6 = 3'b101;
    localparam S7 = 3'b100;

    reg [2:0] current_state, next_state;

    // 1. Sequential State Register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    // 2. Combinational Next-State Logic
    always @(current_state or en) begin
        if (en) begin
            case (current_state)
                S0: next_state = S1;
                S1: next_state = S2;
                S2: next_state = S3;
                S3: next_state = S4;
                S4: next_state = S5;
                S5: next_state = S6;
                S6: next_state = S7;
                S7: next_state = S0;
                default: next_state = S0;
            endcase
        end else begin
            next_state = current_state;
        end
    end

    // 3. Mealy Output Logic (Sensitive to current_state AND en)
    always @(current_state or en) begin
        if (en) begin
            case (current_state)
                S0: gray_out = S1;
                S1: gray_out = S2;
                S2: gray_out = S3;
                S3: gray_out = S4;
                S4: gray_out = S5;
                S5: gray_out = S6;
                S6: gray_out = S7;
                S7: gray_out = S0;
                default: gray_out = S0;
            endcase
        end else begin
            gray_out = current_state;
        end
    end

endmodule
