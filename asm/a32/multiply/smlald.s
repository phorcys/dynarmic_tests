/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000000B",
    "R1": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    // SMLALD: Signed Multiply Accumulate Long Dual
    // R0:R1 (64-bit) += (R2[15:0] * R3[15:0]) + (R2[31:16] * R3[31:16])
    // R2 = 0x00020001 (high=2, low=1)
    // R3 = 0x00040003 (high=4, low=3)
    // R0 = 0, R1 = 0
    // Result = 0 + (1*3) + (2*4) = 3 + 8 = 11 = 0xB
    // R0 = 11, R1 = 0
    mov r0, #0
    mov r1, #0
    ldr r2, =0x00020001
    ldr r3, =0x00040003
    smlald r0, r1, r2, r3
    bkpt #0
