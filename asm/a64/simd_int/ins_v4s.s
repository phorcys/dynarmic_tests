/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000000000000200000001"
  }
}
*/
// Test: INS Vd.S[index], Wn - insert element from GPR
// V0 initially zero, then insert 1 into S[0], 2 into S[1]
// S[0] = bits [31:0], S[1] = bits [63:32]

.text
.global _start
_start:
    // Zero V0
    movi v0.4s, #0

    // Insert 1 into S[0]
    mov w0, #1
    mov v0.s[0], w0

    // Insert 2 into S[1]
    mov w1, #2
    mov v0.s[1], w1

    brk #0