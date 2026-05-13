/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000000A"
  }
}
*/
// Simple BL test: call and return inline

.text
.global _start
_start:
    mov x0, #0
    bl 1f
    brk #0
1:
    add x0, x0, #10
    ret
