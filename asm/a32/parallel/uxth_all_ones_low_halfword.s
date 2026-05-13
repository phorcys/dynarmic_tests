/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000FFFF" }
}
*/
.text
.global _start
_start:
    ldr r1, =0xFFFFFFFF
    uxth r0, r1
    bkpt #0
.ltorg
