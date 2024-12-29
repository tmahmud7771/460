module fsm2(z, w, clk, reset);

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
                     A: if (w) begin state<=B; z=0; end else begin state<=A; z=0; end
                     B: if (w) begin state<=C; z=0; end else begin state<=E; z=0; end
                     C: if (w) begin state<=D; z=0; end else begin state<=E; z=0; end
                     D: if (w) begin state<=D; z=1; end else begin state<=E; z=0; end
                     E: if (w) begin state<=F; z=0; end else begin state<=A; z=0; end
                     F: if (w) begin state<=C; z=0; end else begin state<=E; z=1; end
                    default: state<=3'bxxx;
                endcase
            end
        end
endmodule