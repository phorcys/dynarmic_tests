/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002",
    "X1": "0x0000000000000001",
    "X2": "0x000000007FFFFFFF",
    "X3": "0x0000000080000000"
  }
}
*/
// Test: ADCS with different initial C flag values

.text
.global _start
_start:
    // Test 1: ADCS with C=0
    mov w11, #1
    mov w12, #1
    msr nzcv, xzr            // Clear flags (C=0)
    adcs w13, w11, w12       // 1 + 1 + 0 = 2
    mov w0, w13

    // Test 2: ADCS with C=1
    mov w11, #0
    mov w12, #0
    mov x14, #0x20000000     // C=1
    msr nzcv, x14
    adcs w13, w11, w12       // 0 + 0 + 1 = 1
    mov w1, w13

    // Test 3: ADCS with INT_MAX, C=0
    mov w11, #0x7FFFFFFF
    mov w12, #0
    msr nzcv, xzr            // C=0
    adcs w13, w11, w12       // INT_MAX + 0 + 0 = INT_MAX
    mov w2, w13

    // Test 4: ADCS overflow with C=1
    mov w11, #0x7FFFFFFF
    mov w12, #0
    mov x14, #0x20000000     // C=1
    msr nzcv, x14
    adcs w13, w11, w12       // INT_MAX + 0 + 1 = INT_MIN (overflow)
    mov w3, w13

    brk #0