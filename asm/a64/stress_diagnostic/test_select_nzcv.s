/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000000000000"
  }
}
*/
.text
.global _start
_start:
    // Set NZCV = 0 (GT condition: Z=0, N=V)
    msr nzcv, xzr
    
    // Try conditional select
    // If GT, select 0x80000000, else select 0
    mov x0, #0x80000000
    mov x1, #0
    csel x0, x0, x1, gt
    brk #0
