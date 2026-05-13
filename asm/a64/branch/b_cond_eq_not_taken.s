/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000064"
  }
}
*/
// B.EQ not taken

.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
    cmp x0, x1      // Z=0
    b.eq taken
    mov x0, #100
    b end
    taken:
    mov x0, #1
    end:
    brk #0
