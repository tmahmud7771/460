module fsm2(z, w, clk, reset);
/*
w=0,1
*/
    input clk, reset;
    input w;
    output reg z;
    reg [2:0] state;
    
    parameter   A = 3'b000, 
                B = 3'b001, 
                C = 3'b010, 
                D = 3'b011, 
                E = 3'b100, 
                F = 3'b101;

    always@(posedge clk, posedge reset)
        begin
        if (reset)
            begin
                    state <= A;
            end
        else
            begin
                casex(state)    
                     A: if (w) state<=B; else state<=A;
                     B: if (w) state<=C; else state<=E;
                     C: if (w) state<=D; else state<=E;
                     D: if (w) state<=D; else state<=E;
                     E: if (w) state<=F; else state<=A;
                     F: if (w) state<=C; else state<=E;
                    default: state<=3'bxxx;
                endcase
            end
        end



    always@(state)
        begin
        case(state)
            A: z = 0;
            B: z = 0;
            C: z = 0;
            D: z = 1;
            E: z = 0;
            F: z = 1;
            default: z = 0;
        endcase
        end

endmodule