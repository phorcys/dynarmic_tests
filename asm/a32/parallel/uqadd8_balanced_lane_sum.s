/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x05050505" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x01020304
    ldr r2, =0x04030201
    uqadd8 r0, r1, r2
    bkpt #0
.ltorg
