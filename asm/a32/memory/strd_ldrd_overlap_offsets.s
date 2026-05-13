/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xAAAABBBB",
    "R1": "0xCCCCDDDD",
    "R2": "0x11112222",
    "R3": "0x33334444"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #32
    ldr r4, =0xAAAABBBB
    ldr r5, =0xCCCCDDDD
    strd r4, r5, [sp, #4]

    ldr r4, =0x11112222
    ldr r5, =0x33334444
    strd r4, r5, [sp, #12]

    ldrd r0, r1, [sp, #4]
    ldrd r2, r3, [sp, #12]

    add sp, sp, #32
    bkpt #0
