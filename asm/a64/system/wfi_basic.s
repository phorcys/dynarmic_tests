/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// WFI basic

.text
.global _start
_start:
    mov x0, #1
    wfi
    brk #0
