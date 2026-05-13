/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFF8"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0x8000000000000000
    asr x0, x0, #60
    brk #0

