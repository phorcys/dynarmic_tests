/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x000000001200FF78"
  }
}
*/
// BFI test: insert w0[15:0] into w1[23:8]
// w0 = 0x00FFFF00, w0[15:0] = 0xFF00
// w1 = 0x12345678
// BFI w1, w0, #8, #16 -> result = 0x1200FF78

.text
.global _start
_start:
    mov w0, #0xFF
    movk w0, #0xFF00, lsl #16   // w0 = 0x00FFFF00
    mov w1, #0x5678
    movk w1, #0x1234, lsl #16   // w1 = 0x12345678
    bfi w1, w0, #8, #16
    
    brk #0
