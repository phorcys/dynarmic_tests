/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000007",
    "R1": "0x00000005",
    "R2": "0x0000000B",
    "R3": "0xFFFFFFFB"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x00030002
    ldr r5, =0x00010002
    smuad r0, r4, r5       @ 7

    ldr r4, =0x00020003
    ldr r5, =0x00020003
    smusd r1, r4, r5       @ 5

    ldr r4, =0x00020001
    ldr r5, =0x00040003
    smuad r2, r4, r5       @ 11

    ldr r4, =0x00020001
    ldr r5, =0x00040003
    smusd r3, r4, r5       @ -5

    bkpt #0
