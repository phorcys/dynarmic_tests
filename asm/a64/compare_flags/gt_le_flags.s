/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000001"
  }
}
*/
// Test: GT and LE conditions with various flag combinations

.text
.global _start
_start:
    // Set up flags: N=0, Z=0, C=1, V=0 (positive result, no overflow)
    mov w11, #5
    cmp w11, #3              // 5 - 3 = 2, N=0, Z=0, C=1, V=0

    // GT (Signed Greater Than: Z=0 && N==V) - true (Z=0, N=V=0)
    cset w12, gt
    mov w0, w12              // x0 = 1

    // LE (Signed Less or Equal: !(Z=0 && N==V)) - false
    cset w12, le
    mov w1, w12              // x1 = 0

    // Now set flags with Z=1
    cmp w11, w11             // 5 - 5 = 0, N=0, Z=1, C=1, V=0

    // GT with Z=1 - false
    cset w12, gt
    mov w2, w12              // x2 = 0

    // LE with Z=1 - true
    cset w12, le
    mov w3, w12              // x3 = 1

    brk #0
