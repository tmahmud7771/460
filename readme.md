# Finite State Machine (FSM) Implementation Guide

## Table of Contents

- [Introduction](#introduction)
- [Understanding FSM Types](#understanding-fsm-types)
- [FSM Design Steps](#fsm-design-steps)
- [Code Templates](#code-templates)
- [Implementation Examples](#implementation-examples)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Introduction

This guide provides a structured approach to implementing Finite State Machines (FSMs) in Verilog, covering both Mealy and Moore machine types.

## Understanding FSM Types

### Mealy Machine

- Outputs depend on both current state AND inputs
- Generally uses fewer states
- Output can change asynchronously with input
- Output equation: Z = f(Present State, Input)

### Moore Machine

- Outputs depend ONLY on current state
- May require more states than Mealy
- Output changes synchronously with state transitions
- Output equation: Z = f(Present State)

## FSM Design Steps

1. **Problem Analysis**

   - Identify inputs and outputs
   - List all possible states
   - Determine required state transitions

2. **State Encoding**

   - Assign binary codes to states
   - Use parameters for readability

   ```verilog
   parameter S0 = 3'b000, S1 = 3'b001, ...;
   ```

3. **State Register Declaration**

   - Define state register size

   ```verilog
   reg [2:0] state;  // For up to 8 states
   ```

4. **Implementation Choice**
   - Decide between Mealy or Moore based on requirements
   - Consider timing and state count requirements

## Code Templates

### Mealy Machine Template

```verilog
module fsm_mealy(
    input clk, reset,
    input w,
    output reg z
);
    // State definitions
    parameter   A = 3'b000,
                B = 3'b001,
                C = 3'b010;

    reg [2:0] state;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= A;
        end
        else begin
            case(state)
                A: if(w) begin state<=B; z=0; end
                   else begin state<=A; z=1; end
                B: if(w) begin state<=C; z=1; end
                   else begin state<=A; z=0; end
                // Add more states as needed
                default: state <= 3'bxxx;
            endcase
        end
    end
endmodule
```

### Moore Machine Template

```verilog
module fsm_moore(
    input clk, reset,
    input w,
    output reg z
);
    // State definitions
    parameter   A = 3'b000,
                B = 3'b001,
                C = 3'b010;

    reg [2:0] state;

    // Output logic - depends only on state
    always @(state) begin
        case(state)
            A: z = 0;
            B: z = 1;
            C: z = 0;
            default: z = 0;
        endcase
    end

    // State transitions
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= A;
        end
        else begin
            case(state)
                A: if(w) state<=B; else state<=A;
                B: if(w) state<=C; else state<=A;
                // Add more states as needed
                default: state <= 3'bxxx;
            endcase
        end
    end
endmodule
```

## Implementation Examples

### Converting Mealy to Moore

1. Separate output logic from state transitions
2. Move output assignments to a dedicated always block
3. Make output dependent only on state
4. Add additional states if needed

### Key Differences in Implementation

- Mealy: Output assignments within state transition logic
- Moore: Separate output logic block
- Mealy: Output can change with input
- Moore: Output changes only with state

## Best Practices

1. **State Encoding**

   - Use meaningful state names
   - Consider one-hot encoding for large FSMs
   - Use parameters for state definitions

2. **Reset Logic**

   - Always include synchronous or asynchronous reset
   - Initialize to a known state

3. **Default Cases**

   - Include default cases in case statements
   - Handle undefined states

4. **Documentation**
   - Comment state transitions
   - Include timing diagrams
   - Document input/output behavior

## Troubleshooting

Common Issues and Solutions:

1. **Unintended State Transitions**

   - Check reset logic
   - Verify state encoding
   - Review case statement completeness

2. **Timing Issues**

   - Review clock domain crossings
   - Check for combinational loops
   - Verify setup/hold times

3. **Output Glitches**

   - In Mealy: Check input synchronization
   - In Moore: Verify output logic separation

4. **Synthesis Issues**
   - Use proper always block sensitivity lists
   - Avoid latches
   - Check for incomplete assignments
