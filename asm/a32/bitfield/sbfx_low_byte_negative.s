/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFF80" }
}
*/
.arch armv7-a
.text
.global _start
_start:
    ldr r1, =0x12345680
    sbfx r0, r1, #0, #8
    bkpt #0
.ltorg
