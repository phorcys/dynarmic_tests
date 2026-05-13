/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000000A"
  }
}
*/
// B.EQ taken

.text
.global _start
_start:
    mov x0, #5
    mov x1, #5
    cmp x0, x1
    b.eq target
    mov x0, #5
    b done
    target:
    mov x0, #10
    done:
    brk #0
