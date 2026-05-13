/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFFFA" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x0000FFFE
    ldr r2, =0x00000003
    smulbb r0, r1, r2
    bkpt #0
.ltorg
