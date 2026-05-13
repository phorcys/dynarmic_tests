/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000090000000",
    "X2": "0x0000000030000000",
    "X3": "0x0000000000000000"
  }
}
*/
// Test: ADDS/SUBS with overflow conditions
// Overflow occurs when:
// - Adding two positives gives negative (signed overflow)
// - Adding two negatives gives positive (signed overflow)

.text
.global _start
_start:
    // === Test 1: ADDS overflow - 0x7FFFFFFF + 1 = 0x80000000 ===
    // N=1, Z=0, C=0, V=1 (signed overflow)
    // NZCV = 0x90000000
    mov w8, #1
    lsl w8, w8, #31          // w8 = 0x80000000
    sub w8, w8, #1           // w8 = 0x7FFFFFFF
    adds w9, w8, #1          // 0x7FFFFFFF + 1 = 0x80000000
    mrs x1, nzcv             // N=1, V=1
    
    // === Test 2: SUBS overflow - 0x80000000 - 1 = 0x7FFFFFFF ===
    // N=0, Z=0, C=1 (no borrow), V=1 (signed overflow)
    // NZCV = 0x30000000
    mov w8, #1
    lsl w8, w8, #31          // w8 = 0x80000000
    subs w9, w8, #1          // 0x80000000 - 1 = 0x7FFFFFFF
    mrs x2, nzcv             // C=1, V=1
    
    // === Test 3: No overflow case ===
    mov w8, #100
    adds w9, w8, #200        // 300, no overflow
    mrs x10, nzcv
    lsr x3, x10, #28
    and x3, x3, #1           // X3 = 0 (no overflow)

    mov x0, #0

    brk #0
