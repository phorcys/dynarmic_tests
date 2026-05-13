/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000A",
    "X1": "0x0000000080000000"
  }
}
*/
.text
.global _start
_start:
    mov x0, #10
    
    // First, set up condition: CMP x0, #5
    cmp x0, #5
    // NZCV should be 0x20000000 (C=1)
    
    // Now CCMP x0, #15, #0, gt
    // GT condition: Z==0 && N==V
    // From CMP: Z=0, N=0, V=0, so N==V is true
    // GT = true
    // So compare 10 vs 15
    ccmp x0, #15, #0, gt
    
    // Expected: NZCV = 0x80000000 (N=1, Z=0, C=0, V=0)
    mrs x1, nzcv
    brk #0
