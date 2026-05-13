/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x00000000FFFFFFFF",
    "X3": "0x00000000FFFFFFFE"
  }
}
*/
// Edge case test: sbc_chain

.text
.global _start
_start:

    mov w0, #0
    mov w1, #1
    subs w2, w0, #1   // 0 - 1 = 0xFFFFFFFF, C=0 (borrow)
    sbc w3, w0, w1    // 0 - 1 - !C = 0 - 1 - 1 = 0xFFFFFFFE


    brk #0
