/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000002"
  }
}
*/
// ASR positive

.text
.global _start
_start:
    mov x0, #4
    asr x0, x0, #1        // 4 >> 1 = 2
    brk #0
