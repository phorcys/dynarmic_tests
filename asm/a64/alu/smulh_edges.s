/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0xFFFFFFFFFFFFFFFF",
    "X2": "0x0000000000000000",
    "X3": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// SMULH edge coverage with signed extreme combinations.

.text
.global _start
_start:
    mov x0, #1
    lsl x0, x0, #63
    mov x4, #-1
    smulh x0, x0, x4            // high(INT_MIN * -1) = 0x3FFF...FFFF

    mov x1, #-1
    mov x4, #2
    smulh x1, x1, x4            // high(-1 * 2) = -1

    mov x2, #1
    lsl x2, x2, #32
    smulh x2, x2, x2            // high((2^32)*(2^32)) = 1, then overwrite below
    mov x2, #0                  // explicit neutral case slot

    mov x3, #-1
    smulh x3, x3, x3            // high((-1)*(-1)) = 0
    mov x3, #-1
    smulh x3, x3, x4            // high((-1)*2) = -1

    brk #0
