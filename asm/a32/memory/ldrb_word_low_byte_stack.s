/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000078"
  }
}
*/
.text
.global _start
_start:
    ldr r2, =0x12345678
    push {r2}
    mov r1, sp
    ldrb r0, [r1]
    pop {r2}
    bkpt #0
