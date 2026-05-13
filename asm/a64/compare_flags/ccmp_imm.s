/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// Test: CCMP Xn, #imm, #nzcv, #cond - conditional compare immediate

.text
.global _start
_start:
    mov x0, #5
    cmp x0, #5       // Sets Z=1 (equal)

    // CCMP with immediate: if EQ, compare with immediate
    ccmp x0, #5, #0, eq  // EQ true, compare X0 with 5
    // X0 = 5, immediate = 5, so equal
    // NZCV: N=0, Z=1, C=1, V=0

    // Extract Z flag
    mrs x0, nzcv
    lsr x0, x0, #30
    and x0, x0, #1   // Z = 1

    brk #0