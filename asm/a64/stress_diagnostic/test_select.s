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
    mov x0, #0
    msr nzcv, xzr   // NZCV = 0
    // GT = Z==0 && N==V = true
    
    // Try CSEL to test conditional select
    mov x0, #0x80000000
    mov x1, #0
    csel x0, x0, x1, gt   // If GT, x0 = 0x80000000, else x0 = 0
    brk #0
