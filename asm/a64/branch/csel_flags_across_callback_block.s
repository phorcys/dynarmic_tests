/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X3": "0x0000000000002222"
  },
  "MemData": {
    "0x1000": ["0x0000000000001111", "0x0000000000002222"]
  }
}
*/
// Regression test for NZCV synchronization across a block boundary followed by
// callback memory. The CMP is in the first block. The fallthrough block reloads
// memory before CSEL, forcing backends that invalidate host flags around
// callbacks to reload NZCV from architectural state.

.text
.global _start
_start:
    mov x0, #50
    cmp x0, #30                 // LE is false.
    b.eq equal                  // Not taken; splits the block after CMP.

    mov x20, #0x1000
    ldr x1, [x20]
    ldr x2, [x20, #8]
    csel x3, x1, x2, le         // Must select x2.
    b done

equal:
    mov x3, #0

done:
    brk #0
