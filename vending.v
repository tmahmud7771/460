module vm10(purchase, ret, cash_in, clk, reset);
/*
cash_in=0,5,10,20 TK
price = 10 TK
*/
    input clk, reset;
    input [1:0] cash_in;
    output reg purchase;
    output reg [1:0] ret;
    
    reg [1:0] state;
    parameter     
                S0 = 2'b00,  // 0 TK state
                S1 = 2'b01,  // 5 TK state
                S2 = 2'b10,  // 10 TK state
                S3 = 2'b11,  // 15 TK state
                n = 10,      // Price of product  
                R0 = 2'b00,  // Return 0 TK
                R5 = 2'b01,  // Return 5 TK
                R10 = 2'b10, // Return 10 TK
                R15 = 2'b11; // Return 15 TK
    
    always@(posedge clk)
        begin
        if (reset)
            begin
                state <= S0;
                purchase <= 0;
                ret <= R0;
            end
        else
            begin
            case(state)    
                S0: // "VM has 0 Tk" - state
                    case(cash_in)
                        2'b00: begin // 0 TK inserted
                            state <= S0;
                            purchase <= 0;
                            ret <= R0;
                        end
                        2'b01: begin // 5 TK inserted
                            state <= S1;
                            purchase <= 0;
                            ret <= R0;
                        end
                        2'b10: begin // 10 TK inserted
                            state <= S0;
                            purchase <= 1;
                            ret <= R0;
                        end
                        2'b11: begin // 20 TK inserted
                            state <= S0;
                            purchase <= 1;
                            ret <= R10;
                        end
                        default: begin
                            state <= S0;
                            purchase <= 0;
                            ret <= R0;
                        end
                    endcase
                        
                S1: // "VM has 5 Tk" - state
                    case(cash_in)
                        2'b00: begin // 0 TK inserted
                            state <= S1;
                            purchase <= 0;
                            ret <= R0;
                        end
                        2'b01: begin // 5 TK inserted
                            state <= S0;
                            purchase <= 1;
                            ret <= R0;
                        end
                        2'b10: begin // 10 TK inserted
                            state <= S0;
                            purchase <= 1;
                            ret <= R5;
                        end
                        2'b11: begin // 20 TK inserted
                            state <= S0;
                            purchase <= 1;
                            ret <= R15;
                        end
                        default: begin
                            state <= S1;
                            purchase <= 0;
                            ret <= R0;
                        end
                    endcase

                S2: // "VM has 10 Tk" - state
                    case(cash_in)
                        2'b00: begin
                            state <= S0;
                            purchase <= 1;
                            ret <= R0;
                        end
                        default: begin
                            state <= S0;
                            purchase <= 1;
                            ret <= cash_in; // Return whatever was inserted
                        end
                    endcase

                S3: // "VM has 15 Tk" - state
                    begin
                        state <= S0;
                        purchase <= 1;
                        ret <= R5; // Always return 5 TK excess
                    end

                default: // Invalid state
                    begin
                        state <= S0;
                        purchase <= 0;
                        ret <= R0;
                    end
            endcase
            end
        end
endmodule