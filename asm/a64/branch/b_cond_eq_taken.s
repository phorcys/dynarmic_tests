/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// B.EQ taken

.text
.global _start
_start:
    mov x0, #0
    cmp x0, x0      // Z=1
    b.eq taken
    mov x0, #100
    b end
    taken:
    mov x0, #1
    end:
    brk #0
