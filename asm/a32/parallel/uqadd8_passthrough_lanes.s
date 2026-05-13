/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x01020304" }
}
*/
.text
.global _start
_start:
    mov r1, #0
    ldr r2, =0x01020304
    uqadd8 r0, r1, r2
    bkpt #0
.ltorg
