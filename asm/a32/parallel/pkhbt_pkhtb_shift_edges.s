/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xDEF05678",
    "R1": "0x12349ABC",
    "R2": "0x00005678",
    "R3": "0x89AB8000"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x12345678
    ldr r5, =0x9ABCDEF0
    pkhbt r0, r4, r5, lsl #16

    ldr r4, =0x12345678
    ldr r5, =0x9ABCDEF0
    pkhtb r1, r4, r5, asr #16

    ldr r4, =0xFFFF5678
    ldr r5, =0x00008000
    pkhbt r2, r4, r5

    ldr r4, =0x89AB5678
    ldr r5, =0x80000000
    pkhtb r3, r4, r5, asr #16

    bkpt #0
