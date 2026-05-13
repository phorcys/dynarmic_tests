/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x12345078" }
}
*/
.text
.global _start
_start:
    ldr r0, =0x12345678
    bfc r0, #8, #4
    bkpt #0

.pool
