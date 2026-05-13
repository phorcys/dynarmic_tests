/* CONFIG
{
  "RegData": {
    "X0": "0x0000000040000000"
  }
}
*/
// BICS - Bit Clear and set flags

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0xFF
    bics x0, x0, x1       // 0xFF & ~0xFF = 0, Z=1
    mrs x0, nzcv          // NZCV = 0x40000000 (Z=1)
    brk #0
