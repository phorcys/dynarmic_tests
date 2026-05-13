/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x20001000"
  }
}
*/
.text
.global _start
_start:
    ldr r0, =0x10002000
    ldr r1, =0x10001000
    qasx r0, r0, r1
    bkpt #0
