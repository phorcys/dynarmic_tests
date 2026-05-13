/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000016" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00020003
    ldr r2, =0x00050004
    smuad r0, r1, r2
    bkpt #0
.ltorg
