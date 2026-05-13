/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000008",
    "R1": "0x00030002",
    "R2": "0x00050004"
  }
}
*/
.text
.global _start
_start:
    // SMULBB: Signed Multiply Bottom Half x Bottom Half
    // R0 = R1[15:0] * R2[15:0] (signed)
    // R1 = 0x00030002 (low half = 2)
    // R2 = 0x00050004 (low half = 4)
    // R0 = 2 * 4 = 8
    ldr r1, =0x00030002
    ldr r2, =0x00050004
    smulbb r0, r1, r2
    bkpt #0
