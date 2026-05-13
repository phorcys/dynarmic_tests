/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFE",
    "X1": "0x0000000000000002",
    "X2": "0x0000000080000000",
    "X3": "0x0000000000000009"
  }
}
*/
// SMULL alias coverage: signed 32x32 -> 64 with edge values and overlap.

.text
.global _start
_start:
    mov w0, #0xFFFFFFFF
    mov w1, #2
    smull x0, w0, w1            // -1 * 2 = -2

    mov w2, #1
    lsl w2, w2, #31             // INT_MIN
    mov w3, #0xFFFFFFFF         // -1
    smull x2, w2, w3            // INT_MIN * -1 = 0x0000000080000000

    mov w1, #0xFFFFFFFF
    smull x1, w1, w1            // -1 * -1 = 1, then overwrite below
    mov w3, #3
    smull x3, w3, w3            // source reuse: 3 * 3 = 9
    mov x1, #2

    brk #0
