/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000000000000",
    "X3": "0x0000000040000000"
  }
}
*/
// Edge case test: ands_z_flag

.text
.global _start
_start:

    mov w0, #0xFF
    mov w1, #0xFF00
    ands w2, w0, w1   // 0xFF & 0xFF00 = 0
    mrs x3, nzcv      // N=0, Z=1 => NZCV=0x40000000


    brk #0
