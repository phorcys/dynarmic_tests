/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000007F800000",
    "X1": "0x00000000FF800000",
    "X2": "0x000000007F800000",
    "X3": "0x00000000FF800000"
  }
}
*/
// Test: FDIV with Infinity
// Inf / finite = Inf (with sign)
// finite / 0 = Inf (with sign)
// -Inf / positive = -Inf

.text
.global _start
_start:
    // === Test 1: Inf / 2 = Inf ===
    ldr w8, =0x7f800000      // +Inf
    fmov s0, w8
    fmov s1, #2.0
    fdiv s2, s0, s1          // Inf / 2.0 = Inf
    fmov w0, s2
    
    // === Test 2: -Inf / 2 = -Inf ===
    ldr w8, =0xff800000      // -Inf
    fmov s0, w8
    fmov s1, #2.0
    fdiv s2, s0, s1          // -Inf / 2.0 = -Inf
    fmov w1, s2
    
    // === Test 3: 2.0 / 0 = Inf ===
    fmov s0, #2.0
    mov w8, #0
    fmov s1, w8              // s1 = 0.0
    fdiv s2, s0, s1          // 2.0 / 0.0 = Inf
    fmov w2, s2
    
    // === Test 4: -2.0 / 0 = -Inf ===
    fmov s0, #-2.0
    mov w8, #0
    fmov s1, w8              // s1 = 0.0
    fdiv s2, s0, s1          // -2.0 / 0.0 = -Inf
    fmov w3, s2

    brk #0