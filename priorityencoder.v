module priority_encoder_8to3(
    input [7:0] in,      // 8-bit input
    output reg [2:0] out,// 3-bit output
    output reg valid     // valid output indicator
);

always @(*) begin
    casex(in)
        8'b1xxxxxxx: begin out = 3'b111; valid = 1'b1; end  // Priority 7
        8'b01xxxxxx: begin out = 3'b110; valid = 1'b1; end  // Priority 6
        8'b001xxxxx: begin out = 3'b101; valid = 1'b1; end  // Priority 5
        8'b0001xxxx: begin out = 3'b100; valid = 1'b1; end  // Priority 4
        8'b00001xxx: begin out = 3'b011; valid = 1'b1; end  // Priority 3
        8'b000001xx: begin out = 3'b010; valid = 1'b1; end  // Priority 2
        8'b0000001x: begin out = 3'b001; valid = 1'b1; end  // Priority 1
        8'b00000001: begin out = 3'b000; valid = 1'b1; end  // Priority 0
        8'b00000000: begin out = 3'b000; valid = 1'b0; end  // No input
        default: begin out = 3'b000; valid = 1'b0; end
    endcase
end

endmodule