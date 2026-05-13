/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000000F"
  }
}
*/
// BL with return - simple call

.text
.global _start
_start:
    mov x0, #10
    bl add_five
    brk #0

add_five:
    add x0, x0, #5
    ret
