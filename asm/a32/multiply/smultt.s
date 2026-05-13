/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000000F",
    "R1": "0x00030002",
    "R2": "0x00050004"
  }
}
*/
.text
.global _start
_start:
    // SMULTT: Signed Multiply Top Half x Top Half
    // R0 = R1[31:16] * R2[31:16] (signed)
    // R1 = 0x00030002 (high half = 3)
    // R2 = 0x00050004 (high half = 5)
    // R0 = 3 * 5 = 15 = 0xF
    ldr r1, =0x00030002
    ldr r2, =0x00050004
    smultt r0, r1, r2
    bkpt #0
