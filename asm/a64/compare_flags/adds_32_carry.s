/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000006"
  }
}
*/
// ADDS 32-bit carry: 0xFFFFFFFF + 1 = 0 with carry, Z=1,C=1

.text
.global _start
_start:
    mov w0, #-1
    adds w0, w0, #1            // 32-bit: Z=1, C=1 -> NZCV=0x60000000
    mrs x1, nzcv
    lsr x0, x1, #28            // extract bits [31:28] = 0x6
    brk #0
