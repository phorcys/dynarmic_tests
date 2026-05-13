/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000001",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000001",
    "X5": "0x0000000000000000"
  }
}
*/
// Test: Signed comparison condition codes (GE, LT, GT, LE)
// These use N and V flags for signed comparison

.text
.global _start
_start:
    // Set up flags: N=0, Z=0, C=1, V=0 (result of cmp 1, 0)
    // For signed: 1 > 0
    mov w11, #1
    cmp w11, #0

    // HI (Unsigned Higher, C=1 && Z=0) - true
    cset w12, hi
    mov w0, w12              // x0 = 1

    // LS (Unsigned Lower or Same, !(C=1 && Z=0)) - false
    cset w12, ls
    mov w1, w12              // x1 = 0

    // GE (Signed Greater or Equal, N==V) - true (N=0, V=0)
    cset w12, ge
    mov w2, w12              // x2 = 1

    // LT (Signed Less Than, N!=V) - false (N=0, V=0)
    cset w12, lt
    mov w3, w12              // x3 = 0

    // GT (Signed Greater Than, Z=0 && N==V) - true
    cset w12, gt
    mov w4, w12              // x4 = 1

    // LE (Signed Less or Equal, !(Z=0 && N==V)) - false
    cset w12, le
    mov w5, w12              // x5 = 0

    brk #0
