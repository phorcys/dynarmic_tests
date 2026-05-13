/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// ASR negative

.text
.global _start
_start:
    mov x0, #-1
    asr x0, x0, #1
    brk #0
