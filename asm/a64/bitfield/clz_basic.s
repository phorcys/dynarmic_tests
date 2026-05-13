/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000020"
  }
}
*/
// CLZ basic - count leading zeros in 64-bit

.text
.global _start
_start:
    mov x0, #0x80000000
    clz x0, x0            // count leading zeros = 32 (bit 31 is set, 32 leading zeros)
    brk #0
