/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFF8000" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00008000
    sxth r0, r1
    bkpt #0
.ltorg
