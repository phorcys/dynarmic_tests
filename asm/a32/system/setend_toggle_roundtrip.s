/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x12345678" }
}
*/
.text
.global _start
_start:
    ldr r0, =0x12345678
    setend be
    setend le
    bkpt #0
.ltorg
