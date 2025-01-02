module sequence_detector(
    input clk,
    input reset,
    input w,
    input x,
    input y,
    output reg z
);

    // State registers for each sequence
    reg [1:0] state_w;    // For 1010 sequence (needs fewer states in Mealy)
    reg [1:0] state_x;    // For 111 sequence
    reg [1:0] state_y;    // For 10 sequence
    reg z_w, z_x, z_y;    // Individual outputs

    // State parameters for w (1010) - Needs fewer states in Mealy
    parameter W_S0 = 2'b00;  // Initial
    parameter W_S1 = 2'b01;  // Saw 1
    parameter W_S2 = 2'b10;  // Saw 10
    parameter W_S3 = 2'b11;  // Saw 101

    // State parameters for x (111)
    parameter X_S0 = 2'b00;  // Initial
    parameter X_S1 = 2'b01;  // Saw 1
    parameter X_S2 = 2'b10;  // Saw 11

    // State parameters for y (10)
    parameter Y_S0 = 2'b00;  // Initial
    parameter Y_S1 = 2'b01;  // Saw 1

    // Sequential block for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_w <= W_S0;
            state_x <= X_S0;
            state_y <= Y_S0;
        end
        else begin
            // For sequence 1010
            case (state_w)
                W_S0: state_w <= w ? W_S1 : W_S0;
                W_S1: state_w <= w ? W_S1 : W_S2;
                W_S2: state_w <= w ? W_S3 : W_S0;
                W_S3: state_w <= w ? W_S1 : W_S0;
                default: state_w <= W_S0;
            endcase

            // For sequence 111
            case (state_x)
                X_S0: state_x <= x ? X_S1 : X_S0;
                X_S1: state_x <= x ? X_S2 : X_S0;
                X_S2: state_x <= x ? X_S2 : X_S0;
                default: state_x <= X_S0;
            endcase

            // For sequence 10
            case (state_y)
                Y_S0: state_y <= y ? Y_S1 : Y_S0;
                Y_S1: state_y <= y ? Y_S1 : Y_S0;
                default: state_y <= Y_S0;
            endcase
        end
    end

    // Combinational output logic - Mealy style
    always @(*) begin
        // For 1010 sequence
        z_w = (state_w == W_S3) && !w;  // Output 1 when in state 101 and input is 0

        // For 111 sequence
        z_x = (state_x == X_S2) && x;   // Output 1 when in state 11 and input is 1

        // For 10 sequence
        z_y = (state_y == Y_S1) && !y;  // Output 1 when in state 1 and input is 0
    end

    // Combine all outputs
    always @(negedge clk) begin
        z <= z_w | z_x | z_y;
    end

endmodule