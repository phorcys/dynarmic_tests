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
    // Set up GT condition: Z=0, N=V
    // We can set NZCV directly using msr
    msr nzcv, xzr   // NZCV = 0 (N=0, Z=0, C=0, V=0)
    // Now GT = Z==0 && N==V = true
    
    ccmp x0, #15, #0, gt
    // Compare 10 vs 15: N=1, Z=0, C=0, V=0
    // NZCV = 0x80000000
    mrs x1, nzcv
    brk #0
