/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x0000000000000000" }
}
*/
.text
.global _start
_start:
    @ VAND: Vector AND
    ldr r0, =0xFFFFFFFF
    vdup.32 d0, r0     @ D0 = [0xFFFFFFFF, 0xFFFFFFFF]
    mov r0, #0
    vdup.32 d1, r0     @ D1 = [0, 0]
    
    vand d0, d0, d1    @ D0 = [0, 0]
    
    bkpt #0
.ltorg