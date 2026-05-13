/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234"
  }
}
*/
// Test: STTR - Store Register (unprivileged)

.text
.global _start
_start:
    sub sp, sp, #32
    
    mov x0, #0x1234
    sttr x0, [sp]
    
    mov x0, #0
    ldtr x0, [sp]
    
    add sp, sp, #32

    brk #0
