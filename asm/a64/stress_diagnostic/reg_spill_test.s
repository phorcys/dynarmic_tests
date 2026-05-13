/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000D2"
  }
}
*/
// Register spill test - use more registers than available
// This forces the register allocator to spill values to the stack
// Expected result: X0 = 21 = 0x15 (sum of 1+2+3+...+20)

.text
.global _start
_start:
    // Load values into X1-X20 (20 registers)
    // The JIT should need to spill some of these to stack
    mov x1, #1
    mov x2, #2
    mov x3, #3
    mov x4, #4
    mov x5, #5
    mov x6, #6
    mov x7, #7
    mov x8, #8
    mov x9, #9
    mov x10, #10
    mov x11, #11
    mov x12, #12
    mov x13, #13
    mov x14, #14
    mov x15, #15
    mov x16, #16
    mov x17, #17
    mov x18, #18
    mov x19, #19
    mov x20, #20

    // Sum all values into X0
    // All 20 values are "live" here, forcing potential spills
    add x0, x1, x2
    add x0, x0, x3
    add x0, x0, x4
    add x0, x0, x5
    add x0, x0, x6
    add x0, x0, x7
    add x0, x0, x8
    add x0, x0, x9
    add x0, x0, x10
    add x0, x0, x11
    add x0, x0, x12
    add x0, x0, x13
    add x0, x0, x14
    add x0, x0, x15
    add x0, x0, x16
    add x0, x0, x17
    add x0, x0, x18
    add x0, x0, x19
    add x0, x0, x20
    
    // X0 should be 210 = 0xD2, but we expect 21 = 0x15
    // Let's fix: 1+2+...+20 = 210, but the config says 21
    // We'll just return the sum of 1..20 = 210
    brk #0
