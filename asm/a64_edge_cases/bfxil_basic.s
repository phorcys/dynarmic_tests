/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x00000000FFFFFABC"
  }
}
*/
// Edge case test: bfxil_basic

.text
.global _start
_start:

    mov w0, #0xABCD
    movk w0, #0x1234, lsl #16   // w0 = 0x1234ABCD
    mov w1, #0xFFFFFFFF
    bfxil w1, w0, #4, #12   // extract bits [15:4] of w0 and insert into w1 bits [11:0]
                            // w0[15:4] = 0xABCD >> 4 = 0xABC (bits [11:0])
                            // w1 = 0xFFFFFABC


    brk #0
