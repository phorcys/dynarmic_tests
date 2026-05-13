/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000080"
  }
}
*/
// UXTB zero extend byte

.text
.global _start
_start:
    mov w0, #0xFFFFFF80
    uxtb x0, w0           // zero extend byte: 0x80 -> 0x80
    brk #0
