/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000001",
    "X3": "0x0000000000000000"
  }
}
*/
// Test: GE and LT conditions with overflow

.text
.global _start
_start:
    // Set up overflow scenario: positive + positive = negative
    // 0x7FFFFFFF + 1 = 0x80000000 (overflow)
    mov w11, #0x7FFFFFFF
    adds w11, w11, #1        // Sets V=1, N=1

    // GE (Signed Greater or Equal: N==V) - true (N=1, V=1)
    cset w12, ge
    mov w0, w12              // x0 = 1

    // LT (Signed Less Than: N!=V) - false (N=V=1)
    cset w12, lt
    mov w1, w12              // x1 = 0

    // Now clear V flag
    mov w11, #1
    adds w11, w11, #1        // 1+1=2, N=0, Z=0, C=0, V=0

    // GE with N=0, V=0: N==V is true
    cset w12, ge
    mov w2, w12              // x2 = 1

    // LT with N=0, V=0: N!=V is false
    cset w12, lt
    mov w3, w12              // x3 = 0

    brk #0
