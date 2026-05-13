/* CONFIG
{
  "RegData": {
    "X0": "0x00000000C0000000"
  }
}
*/
// ASR 32-bit sign extend

.text
.global _start
_start:
    mov w0, #1
    lsl w0, w0, #31       // w0 = 0x80000000
    asr w0, w0, #1        // w0 = 0xC0000000, x0 = 0x00000000C0000000
    brk #0
