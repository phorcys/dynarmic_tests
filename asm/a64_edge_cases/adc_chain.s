/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000001"
  }
}
*/
// Edge case test: adc_chain

.text
.global _start
_start:

    mov w0, #0xFFFF
    movk w0, #0xFFFF, lsl #16
    mov w1, #0
    adds w2, w0, #1   // 0xFFFFFFFF + 1 = 0, C=1
    adc w3, w1, w1    // 0 + 0 + C = 1


    brk #0
