module sequence(
    input clk,
    input reset,
    input x,
    input y,
    input z,
    output reg z_out
);

    reg [2:0] state_x;
    reg [1:0] state_y;
    reg [1:0] state_z;
    reg z_x, z_y, z_z;

    parameter X_S0 = 3'b000;
    parameter X_S1 = 3'b001;
    parameter X_S2 = 3'b010;
    parameter X_S3 = 3'b011;
    parameter X_S4 = 3'b100;

    parameter Y_S0 = 2'b00;
    parameter Y_S1 = 2'b01;
    parameter Y_S2 = 2'b10;
    parameter Y_S3 = 2'b11;

    parameter Z_S0 = 2'b00;
    parameter Z_S1 = 2'b01;
    parameter Z_S2 = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_x <= X_S0;
            state_y <= Y_S0;
            state_z <= Z_S0;
            z_x <= 0;
            z_y <= 0;
            z_z <= 0;
        end
        else begin
            case (state_x)
                X_S0: state_x <= x ? X_S1 : X_S0;
                X_S1: state_x <= x ? X_S1 : X_S2;
                X_S2: state_x <= x ? X_S3 : X_S0;
                X_S3: state_x <= x ? X_S1 : X_S4;
                X_S4: state_x <= x ? X_S1 : X_S0;
                default: state_x <= X_S0;
            endcase

            case (state_y)
                Y_S0: state_y <= y ? Y_S1 : Y_S0;
                Y_S1: state_y <= y ? Y_S2 : Y_S0;
                Y_S2: state_y <= y ? Y_S3 : Y_S0;
                Y_S3: state_y <= y ? Y_S3 : Y_S0;
                default: state_y <= Y_S0;
            endcase

            case (state_z)
                Z_S0: state_z <= z ? Z_S1 : Z_S0;
                Z_S1: state_z <= z ? Z_S1 : Z_S2;
                Z_S2: state_z <= z ? Z_S1 : Z_S0;
                default: state_z <= Z_S0;
            endcase

            z_x <= (state_x == X_S4);
            z_y <= (state_y == Y_S3);
            z_z <= (state_z == Z_S2);
        end
    end

    always @(negedge clk) begin
        z_out <= z_x | z_y | z_z;
    end

endmodule
