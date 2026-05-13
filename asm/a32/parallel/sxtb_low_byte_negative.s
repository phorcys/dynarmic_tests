/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFF80" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00000080
    sxtb r0, r1
    bkpt #0
.ltorg
