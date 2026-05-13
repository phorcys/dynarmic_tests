/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000015"
  }
}
*/
.text
.global _start
_start:
    // SMLAD: Signed Multiply Accumulate Dual
    // R0 = R3 + (R1[15:0] * R2[15:0]) + (R1[31:16] * R2[31:16])
    // R1 = 0x00020001 (high=2, low=1)
    // R2 = 0x00040003 (high=4, low=3)
    // R3 = 10
    // Result = 10 + (1*3) + (2*4) = 10 + 3 + 8 = 21 = 0x15
    ldr r1, =0x00020001
    ldr r2, =0x00040003
    mov r3, #10
    smlad r0, r1, r2, r3
    bkpt #0
