/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFF10012" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00010010
    ldr r2, =0x00020010
    usax r0, r1, r2
    bkpt #0
.ltorg
