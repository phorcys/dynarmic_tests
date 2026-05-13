/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000080000000"
  }
}
*/
.text
.global _start
_start:
    mov x0, #0x80000000
    msr nzcv, x0   // Set NZCV = 0x80000000
    mrs x1, nzcv   // Read it back
    brk #0
