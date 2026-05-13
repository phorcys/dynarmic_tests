/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x06260060", "R1": "0x00000000", "R2": "0x00001234", "R3": "0x00005678" }
}
*/
.text
.global _start
_start:
    // SMLAL: Signed Multiply Accumulate Long
    // R1:R0 = R1:R0 + R2 * R3
    // R1:R0 is a 64-bit accumulator
    mov r0, #0
    mov r1, #0
    mov r2, #0x1234
    mov r3, #0x5678

    smlal r0, r1, r2, r3   @ R1:R0 = 0 + 0x1234 * 0x5678

    @ 0x1234 * 0x5678 = 0x06260060
    bkpt #0