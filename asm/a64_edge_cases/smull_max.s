/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x0000000000000001"
  }
}
*/
// Edge case test: smull_max

.text
.global _start
_start:

    mov w0, #0xFFFF
    movk w0, #0xFFFF, lsl #16   // w0 = 0xFFFFFFFF (-1)
    smull x1, w0, w0            // -1 * -1 = 1 (64-bit)


    brk #0
