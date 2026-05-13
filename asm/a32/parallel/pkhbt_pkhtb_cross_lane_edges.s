/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xABCD2468",
    "R1": "0x89AB5724",
    "R2": "0xAAAAFFFF"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x13572468
    ldr r5, =0x89ABCDEF
    pkhbt r0, r4, r5, lsl #8

    ldr r4, =0x89ABCDEF
    ldr r5, =0x13572468
    pkhtb r1, r4, r5, asr #8

    ldr r4, =0xAAAAAAAA
    mvn r5, #0
    pkhtb r2, r4, r5, asr #31

    bkpt #0
