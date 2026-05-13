/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000090000000",
    "X1": "0x0000000030000000",
    "X2": "0x0000000000000000",
    "X3": "0x0000000080000000"
  }
}
*/
.text
.global _start
_start:
    // Test signed overflow conditions

    // Test 1: Positive overflow (INT_MAX + 1)
    mov w11, #0x7FFFFFFF        // INT_MAX
    mov w12, #1
    adds w13, w11, w12          // INT_MAX + 1 = INT_MIN (overflow)
    mrs x0, nzcv
    // Result: 0x80000000, flags: N=1, Z=0, C=0, V=1 -> 0x90000000

    // Test 2: Negative underflow (INT_MIN - 1)
    mov w11, #0x80000000        // INT_MIN
    mov w12, #1
    subs w13, w11, w12          // INT_MIN - 1 = 0x7FFFFFFF (underflow)
    mrs x1, nzcv
    // Result: 0x7FFFFFFF, flags: N=0, Z=0, C=1, V=1 -> 0x30000000

    // Test 3: No overflow - normal positive addition
    mov w11, #100
    mov w12, #50
    adds w13, w11, w12          // 100 + 50 = 150
    mrs x2, nzcv
    // Expected: N=0, Z=0, C=0, V=0 -> 0x00000000

    // Test 4: No overflow - normal negative result
    mov w11, #50
    mov w12, #100
    subs w13, w11, w12          // 50 - 100 = -50
    mrs x3, nzcv
    // Expected: N=1, Z=0, C=0, V=0 -> 0x80000000

    brk #0