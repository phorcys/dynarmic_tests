/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000078",
    "R1": "0x00000056",
    "R2": "0x00005678",
    "R3": "0x00003456"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x12345678
    push {r4}

    mov r5, sp
    ldrb r0, [r5, #0]
    ldrb r1, [r5, #1]
    ldrh r2, [r5, #0]
    ldrh r3, [r5, #1]

    pop {r4}
    bkpt #0
