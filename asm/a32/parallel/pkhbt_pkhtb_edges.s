/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xCCCCBBBB",
    "R1": "0x11114444",
    "R2": "0xDEF05678",
    "R3": "0x12349ABC"
  }
}
*/
.text
.arm
.global _start
_start:
    ldr r4, =0xAAAABBBB
    ldr r5, =0xCCCCDDDD
    pkhbt r0, r4, r5

    ldr r4, =0x11112222
    ldr r5, =0x33334444
    pkhtb r1, r4, r5

    ldr r4, =0x12345678
    ldr r5, =0x9ABCDEF0
    pkhbt r2, r4, r5, lsl #16

    ldr r4, =0x12345678
    ldr r5, =0x9ABCDEF0
    pkhtb r3, r4, r5, asr #16

    bkpt #0
