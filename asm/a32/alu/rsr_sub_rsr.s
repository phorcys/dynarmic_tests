/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000FF0",
    "R1": "0x00000FFF",
    "R2": "0x000000FF",
    "R3": "0x00000004"
  }
}
*/
.text
.global _start
_start:
    // SUB RSR: Subtract with register-shifted register
    // SUB R0, R1, R2, LSR R3 - R0 = R1 - (R2 >> R3)
    // R1 = 0xFFF, R2 = 0xFF, R3 = 4 -> R0 = 0xFFF - (0xFF >> 4) = 0xFFF - 0x0F = 0xFF0
    ldr r1, =0xFFF
    mov r2, #0xFF
    mov r3, #4
    sub r0, r1, r2, lsr r3
    bkpt #0
