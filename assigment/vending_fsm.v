module vending(
    input clk,
    input reset,
    input [1:0] cash_in,
    output reg purchase,
    output reg [1:0] cash_return
);

    parameter S0 = 2'b00;
    parameter S1 = 2'b01;

    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
            purchase <= 0;
            cash_return <= 2'b00;
        end
        else begin
            case (state)
                S0: begin
                    if (cash_in == 2'b01) begin
                        state <= S1;
                        purchase <= 0;
                        cash_return <= 2'b00;
                    end
                    else if (cash_in == 2'b10) begin
                        state <= S0;
                        purchase <= 1;
                        cash_return <= 2'b00;
                    end
                    else begin
                        state <= S0;
                        purchase <= 0;
                        cash_return <= 2'b00;
                    end
                end

                S1: begin
                    if (cash_in == 2'b01) begin
                        state <= S0;
                        purchase <= 1;
                        cash_return <= 2'b00;
                    end
                    else if (cash_in == 2'b10) begin
                        state <= S0;
                        purchase <= 1;
                        cash_return <= 2'b01;
                    end
                    else begin
                        state <= S1;
                        purchase <= 0;
                        cash_return <= 2'b00;
                    end
                end

                default: begin
                    state <= S0;
                    purchase <= 0;
                    cash_return <= 2'b00;
                end
            endcase
        end
    end

endmodule
