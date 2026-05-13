/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000E8F9E30D"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0
    mov w1, #0x41
    crc32b w0, w0, w1
    brk #0

