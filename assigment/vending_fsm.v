module vending(
    input clk,
    input reset,
    input [1:0] cash_in,
    output reg purchase,
    output reg [1:0] cash_return
);

    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    
    parameter TK_0 = 2'b00;
    parameter TK_10 = 2'b01;
    parameter TK_20 = 2'b10;

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
                    case (cash_in)
                        TK_0: begin
                            state <= S0;
                            purchase <= 0;
                            cash_return <= 2'b00;
                        end
                        
                        TK_10: begin
                            state <= S1;
                            purchase <= 0;
                            cash_return <= 2'b00;
                        end
                        
                        TK_20: begin
                            state <= S0;
                            purchase <= 1;
                            cash_return <= 2'b00;
                        end
                        
                        default: begin
                            state <= S0;
                            purchase <= 0;
                            cash_return <= 2'b00;
                        end
                    endcase
                end

                S1: begin
                    case (cash_in)
                        TK_0: begin
                            state <= S1;
                            purchase <= 0;
                            cash_return <= 2'b00;
                        end
                        
                        TK_10: begin
                            state <= S0;
                            purchase <= 1;
                            cash_return <= 2'b00;
                        end
                        
                        TK_20: begin
                            state <= S0;
                            purchase <= 1;
                            cash_return <= 2'b01;
                        end
                        
                        default: begin
                            state <= S1;
                            purchase <= 0;
                            cash_return <= 2'b00;
                        end
                    endcase
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
