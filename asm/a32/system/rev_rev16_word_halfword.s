/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x78563412", "R1": "0x34127856" }
}
*/
.text
.global _start
_start:
    ldr r3, =0x12345678
    rev r0, r3
    ldr r3, =0x12345678
    rev16 r1, r3
    bkpt #0

.pool
