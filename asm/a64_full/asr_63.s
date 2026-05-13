/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0x8000000000000000
    asr x0, x0, #63
    brk #0

