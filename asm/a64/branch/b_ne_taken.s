/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000000A"
  }
}
*/
// B.NE taken

.text
.global _start
_start:
    mov x0, #5
    mov x1, #3
    cmp x0, x1
    b.ne target
    mov x0, #5
    b done
    target:
    mov x0, #10
    done:
    brk #0
