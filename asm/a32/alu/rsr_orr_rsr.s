/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000FFF",
    "R1": "0x000000FF",
    "R2": "0x000000FF",
    "R3": "0x00000004"
  }
}
*/
.text
.global _start
_start:
    // ORR RSR: OR with register-shifted register
    // ORR R0, R1, R2, LSL R3 - R0 = R1 | (R2 << R3)
    // R1 = 0xFF, R2 = 0xFF, R3 = 4 -> R0 = 0xFF | (0xFF << 4) = 0xFF | 0xFF0 = 0xFFF
    mov r1, #0xFF
    mov r2, #0xFF
    mov r3, #4
    orr r0, r1, r2, lsl r3
    bkpt #0
