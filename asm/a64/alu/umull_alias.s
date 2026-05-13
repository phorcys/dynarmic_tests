/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000001FFFFFFFE",
    "X1": "0xFFFFFFFE00000001",
    "X2": "0x0000000100000000",
    "X3": "0x0000000000000009"
  }
}
*/
// UMULL alias coverage: unsigned 32x32 -> 64 with edge values and source reuse.

.text
.global _start
_start:
    mov w0, #0xFFFFFFFF
    mov w1, #2
    umull x0, w0, w1            // 0xFFFFFFFF * 2 = 0x1FFFFFFFE

    mov w1, #0xFFFFFFFF
    umull x1, w1, w1            // low case with destination reuse

    mov w2, #1
    lsl w2, w2, #16
    umull x2, w2, w2            // 0x10000 * 0x10000 = 0x100000000

    mov w3, #3
    umull x3, w3, w3            // 9

    brk #0
