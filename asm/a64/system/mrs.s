/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000040000000"
  }
}
*/
// Test: MRS Xt, systemreg - move from system register

.text
.global _start
_start:
    mov x0, #0
    
    // MRS: read from system register (NZCV)
    // Default NZCV has Z=1 (zero flag)
    mrs x1, nzcv

    brk #0
