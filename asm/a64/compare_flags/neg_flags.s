/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000FFFFFFFF",
    "X1": "0x0000000080000001",
    "X2": "0x000000007FFFFFFF",
    "X3": "0x0000000000000000"
  }
}
*/
// Test: NEG instruction - Negate
// NEG Wd, Wn: Wd = 0 - Wn (alias for SUB Wd, WZR, Wn)

.text
.global _start
_start:
    // Test 1: NEG of 1
    mov w11, #1
    neg w12, w11
    // w12 = 0 - 1 = 0xFFFFFFFF
    mov x0, x12

    // Test 2: NEG of 0x7FFFFFFF
    mov w11, #0x7FFFFFFF
    neg w12, w11
    // w12 = 0 - 0x7FFFFFFF = 0x80000001
    mov x1, x12

    // Test 3: NEG of 0x80000001
    mov w11, #0x80000001
    neg w12, w11
    // w12 = 0 - 0x80000001 = 0x7FFFFFFF
    mov x2, x12

    // Test 4: NEG of 0
    mov w11, #0
    neg w12, w11
    // w12 = 0 - 0 = 0
    mov x3, x12

    brk #0