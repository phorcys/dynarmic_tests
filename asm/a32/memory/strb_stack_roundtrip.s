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
    mov r0, #0x78
    sub sp, sp, #4
    mov r1, sp
    strb r0, [r1]
    ldrb r0, [r1]
    add sp, sp, #4
    bkpt #0
