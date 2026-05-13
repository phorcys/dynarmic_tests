/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000FFFFFFFF",
    "X1": "0x0000000000000001",
    "X2": "0x0000000000000000",
    "X3": "0x0000000080000000"
  }
}
*/
// Test: NEG instruction (alias for SUB with zero)
// NEG Wd, Wm = SUB Wd, WZR, Wm

.text
.global _start
_start:
    // Test 1: NEG of positive
    mov w11, #1
    neg w12, w11             // 0 - 1 = -1 = 0xFFFFFFFF
    mov w0, w12

    // Test 2: NEG of negative (using MOV with negative)
    mov w11, #0xFFFFFFFF     // -1
    neg w12, w11             // 0 - (-1) = 1
    mov w1, w12

    // Test 3: NEG of zero
    mov w11, #0
    neg w12, w11             // 0 - 0 = 0
    mov w2, w12

    // Test 4: NEG of INT_MIN
    mov w11, #0x80000000
    neg w12, w11             // 0 - INT_MIN = INT_MIN (overflow in 32-bit)
    mov w3, w12

    brk #0