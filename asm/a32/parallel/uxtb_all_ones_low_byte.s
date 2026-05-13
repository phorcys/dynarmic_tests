/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000080" }
}
*/
.text
.global _start
_start:
    ldr r1, =0xFFFFFF80
    uxtb r0, r1
    bkpt #0
.ltorg
