/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000000F",
    "R1": "0x00000FFF",
    "R2": "0x000000FF",
    "R3": "0x00000004"
  }
}
*/
.text
.global _start
_start:
    // EOR RSR: XOR with register-shifted register
    // EOR R0, R1, R2, LSL R3 - R0 = R1 ^ (R2 << R3)
    // R1 = 0xFFF, R2 = 0xFF, R3 = 4 -> R0 = 0xFFF ^ 0xFF0 = 0x00F
    ldr r1, =0xFFF
    mov r2, #0xFF
    mov r3, #4
    eor r0, r1, r2, lsl r3
    bkpt #0
