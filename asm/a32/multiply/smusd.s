/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFB"
  }
}
*/
.text
.global _start
_start:
    // SMUSD: Signed Multiply Subtract Dual
    // R0 = (R1[15:0] * R2[15:0]) - (R1[31:16] * R2[31:16])
    // R1 = 0x00020001 (high=2, low=1)
    // R2 = 0x00040003 (high=4, low=3)
    // Result = (1*3) - (2*4) = 3 - 8 = -5 = 0xFFFFFFFB
    ldr r1, =0x00020001
    ldr r2, =0x00040003
    smusd r0, r1, r2
    bkpt #0
