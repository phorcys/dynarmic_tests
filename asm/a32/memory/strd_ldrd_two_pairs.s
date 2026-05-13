/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x11111111",
    "R1": "0x22222222",
    "R2": "0x33333333",
    "R3": "0x44444444"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    ldr r0, =0x11111111
    ldr r1, =0x22222222
    ldr r2, =0x33333333
    ldr r3, =0x44444444
    strd r0, r1, [sp]
    strd r2, r3, [sp, #8]
    ldrd r0, r1, [sp]
    ldrd r2, r3, [sp, #8]
    add sp, sp, #16
    bkpt #0
