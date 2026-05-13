/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000A",
    "X1": "0x0000000020000000",
    "X2": "0x0000000080000000",
    "X3": "0x0000000080000000"
  }
}
*/
.text
.global _start
_start:
    mov x0, #10
    cmp x0, #5
    mrs x1, nzcv     // Should be 0x20000000
    
    // Manually do what CCMP does
    // GT condition: Z==0 && N==V
    // From X1 = 0x20000000: Z=0, N=0, V=0, so GT=true
    
    // Now do the subtraction manually
    subs xzr, x0, #15
    mrs x2, nzcv     // Should be 0x80000000
    mrs x3, nzcv
    brk #0
