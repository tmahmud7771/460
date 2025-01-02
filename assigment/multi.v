module sequence_detector(
    input clk,
    input reset,
    input w,
    input x,
    input y,
    output reg z
);

    reg [2:0] state_w;
    reg [1:0] state_x;
    reg [1:0] state_y;
    reg z_w, z_x, z_y;

    parameter W_S0 = 3'b000;
    parameter W_S1 = 3'b001;
    parameter W_S2 = 3'b010;
    parameter W_S3 = 3'b011;
    parameter W_S4 = 3'b100;

    parameter X_S0 = 2'b00;
    parameter X_S1 = 2'b01;
    parameter X_S2 = 2'b10;
    parameter X_S3 = 2'b11;

    parameter Y_S0 = 2'b00;
    parameter Y_S1 = 2'b01;
    parameter Y_S2 = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_w <= W_S0;
            state_x <= X_S0;
            state_y <= Y_S0;
            z_w <= 0;
            z_x <= 0;
            z_y <= 0;
        end
        else begin
            case (state_w)
                W_S0: state_w <= w ? W_S1 : W_S0;
                W_S1: state_w <= w ? W_S1 : W_S2;
                W_S2: state_w <= w ? W_S3 : W_S0;
                W_S3: state_w <= w ? W_S1 : W_S4;
                W_S4: state_w <= w ? W_S1 : W_S0;
                default: state_w <= W_S0;
            endcase

            case (state_x)
                X_S0: state_x <= x ? X_S1 : X_S0;
                X_S1: state_x <= x ? X_S2 : X_S0;
                X_S2: state_x <= x ? X_S3 : X_S0;
                X_S3: state_x <= x ? X_S3 : X_S0;
                default: state_x <= X_S0;
            endcase

            case (state_y)
                Y_S0: state_y <= y ? Y_S1 : Y_S0;
                Y_S1: state_y <= y ? Y_S1 : Y_S2;
                Y_S2: state_y <= y ? Y_S1 : Y_S0;
                default: state_y <= Y_S0;
            endcase

            z_w <= (state_w == W_S4);
            z_x <= (state_x == X_S3);
            z_y <= (state_y == Y_S2);
        end
    end

    always @(negedge clk) begin
        z <= z_w | z_x | z_y;
    end

endmodule
