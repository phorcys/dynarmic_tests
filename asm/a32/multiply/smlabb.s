/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000010",
    "R1": "0x00030002",
    "R2": "0x00050004",
    "R3": "0x00000008"
  }
}
*/
.text
.global _start
_start:
    // SMLABB: Signed Multiply Accumulate Bottom Half x Bottom Half
    // R0 = R3 + (R1[15:0] * R2[15:0])
    // R1 = 0x00030002 (low half = 2)
    // R2 = 0x00050004 (low half = 4)
    // R3 = 8
    // R0 = 8 + (2 * 4) = 16 = 0x10
    ldr r1, =0x00030002
    ldr r2, =0x00050004
    mov r3, #8
    smlabb r0, r1, r2, r3
    bkpt #0
