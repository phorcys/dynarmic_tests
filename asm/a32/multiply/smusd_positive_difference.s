/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000005" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00020003
    ldr r2, =0x00020003
    smusd r0, r1, r2
    bkpt #0
.ltorg
