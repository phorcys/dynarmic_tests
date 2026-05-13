/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFF2",
    "R1": "0x0000000A",
    "R2": "0xFFFFFFF9",
    "R3": "0x00000011"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x0003FFFF    @ hi=3 lo=-1
    ldr r5, =0xFFFC0002    @ hi=-4 lo=2
    smuad r0, r4, r5       @ (-1*2) + (3*-4) = -14

    ldr r4, =0x0003FFFF
    ldr r5, =0x00040002    @ hi=4 lo=2
    smuad r1, r4, r5       @ (-1*2) + (3*4) = 10

    ldr r4, =0x0003FFFF
    ldr r5, =0x00020001    @ hi=2 lo=1
    smusd r2, r4, r5       @ (-1*1) - (3*2) = -7

    ldr r4, =0x00030005    @ hi=3 lo=5
    ldr r5, =0x00020001    @ hi=2 lo=1
    smusd r3, r4, r5       @ (5*1) - (3*2) = -1? use adjusted below

    ldr r4, =0x00030005
    ldr r5, =0x00010004    @ hi=1 lo=4
    smusd r3, r4, r5       @ (5*4) - (3*1) = 17

    bkpt #0
