/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// Test: CCMP Xn, Xm, #nzcv, #cond - conditional compare

.text
.global _start
_start:
    // Initialize flags: N=0, Z=0, C=1, V=0
    mov x0, #1
    cmp x0, #0       // Sets C=1, Z=0, N=0, V=0

    // CCMP: if condition true, compare; else set NZCV to immediate
    // CCMP X0, X1, #0, EQ (condition 0 = EQ)
    // If Z==1 (EQ), compare X0 with X1
    // But Z=0, so condition EQ is false, set NZCV to immediate (0)
    mov x1, #1
    ccmp x0, x1, #0, eq

    // NZCV should be 0 (from immediate)

    // Now test when condition is true
    cmp x0, #1       // Sets Z=1 (equal), C=1, N=0, V=0
    ccmp x0, x1, #2, eq  // EQ is true, compare X0 with X1
    // X0 = 1, X1 = 1, so comparison is equal
    // NZCV = N=0, Z=1, C=1, V=0 = 0x60000000

    // Extract Z flag (bit 30)
    mrs x0, nzcv
    lsr x0, x0, #30
    and x0, x0, #1   // Z = 1

    brk #0
