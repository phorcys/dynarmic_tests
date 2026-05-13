/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000001",
    "X2": "0x0000000000000001",
    "X3": "0x0000000000000001"
  }
}
*/
// Test: SBCS with different initial C flag values
// SBCS Wd, Wn, Wm: Wd = Wn - Wm - !C

.text
.global _start
_start:
    // Test 1: SBCS with C=1 (no borrow)
    // result = Wn - Wm - 0 = Wn - Wm
    mov w11, #1
    mov w12, #1
    mov x14, #0x20000000     // C=1
    msr nzcv, x14
    sbcs w13, w11, w12       // 1 - 1 - 0 = 0
    mov w0, w13

    // Test 2: SBCS with C=0 (borrow)
    // result = Wn - Wm - 1
    mov w11, #2
    mov w12, #0
    msr nzcv, xzr            // C=0
    sbcs w13, w11, w12       // 2 - 0 - 1 = 1
    mov w1, w13

    // Test 3: SBCS large - small with C=1
    mov w11, #10
    mov w12, #9
    mov x14, #0x20000000     // C=1
    msr nzcv, x14
    sbcs w13, w11, w12       // 10 - 9 - 0 = 1
    mov w2, w13

    // Test 4: SBCS with C=0, subtracting 0
    mov w11, #2
    mov w12, #0
    msr nzcv, xzr            // C=0
    sbcs w13, w11, w12       // 2 - 0 - 1 = 1
    mov w3, w13

    brk #0