/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000005"
  }
}
*/
// TBZ not taken - bit 1 is set, so branch not taken

.text
.global _start
_start:
    mov x0, #2
    tbz x0, #1, target   // bit 1 is set (x0=2), so TBZ not taken
    mov x0, #5
    b done
target:
    mov x0, #10
done:
    brk #0
