/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000001",
    "X3": "0x0000000000000001",
    "X4": "0x0000000000000000",
    "X5": "0x000000000000000B"
  }
}
*/
// Test: MUL/UMULH/SMULH - multiplication edge cases
// Testing overflow and high part results

.text
.global _start
_start:
    // === Test 1: MUL 0 * anything = 0 ===
    mov x8, #0
    mov x9, #0x5678
    movk x9, #0x1234, lsl #16  // 0x12345678
    mul x10, x8, x9
    mov x1, x10              // Should be 0
    
    // === Test 2: MUL -1 * -1 = 1 ===
    mov x8, #-1
    mov x9, #-1
    mul x10, x8, x9
    mov x2, x10              // Should be 1
    
    // === Test 3: UMULH - unsigned high part ===
    // 2^32 * 2^32 = 2^64, low = 0, high = 1
    mov x8, #1
    lsl x8, x8, #32          // 0x100000000
    umulh x10, x8, x8        // high part of (2^32)^2
    mov x3, x10              // Should be 1
    
    // === Test 4: SMULH - signed high part ===
    // (-1) * (-1) = 1, high part = 0 (sign extended)
    mov x8, #-1
    smulh x10, x8, x8
    mov x4, x10              // Should be 0 (no overflow in high part)
    
    // === Test 5: MADD (multiply-add) ===
    mov x8, #2
    mov x9, #3
    mov x10, #5
    madd x11, x8, x9, x10    // 2 * 3 + 5 = 11
    mov x5, x11

    mov x0, #0

    brk #0