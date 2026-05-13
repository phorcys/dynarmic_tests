/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000001" }
}
*/
.text
.global _start
_start:
    @ CBZ/CBNZ: Compare and Branch (if Zero/Non-Zero)
    @ These are Thumb-only, but we can test equivalent
    
    @ For ARM, use conditional branch
    mov r0, #0
    
    cmp r0, #0
    moveq r0, #1         @ If r0 == 0, set r0 = 1
    
    bkpt #0
