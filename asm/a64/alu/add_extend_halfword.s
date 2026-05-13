/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X3": "0x0000000000009001",
    "X4": "0xFFFFFFFFFFFF9001",
    "X5": "0x0000000000008FFF",
    "X6": "0x0000000000011002"
  }
}
*/
// ADD halfword extend variants missing from the basic extend tests.

.text
.global _start
_start:
    mov x0, #0x1000
    mov w1, #0x8001
    mov w2, #0x7FFF

    add x3, x0, w1, uxth
    add x4, x0, w1, sxth
    add x5, x0, w2, sxth

    mov x6, #0x1000
    add x6, x6, w1, uxth #1

    brk #0
