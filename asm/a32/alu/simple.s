/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001"
  }
}
*/
.text
.arm
.global _start
_start:
    @ RRX without C flag (C=0)
    @ R0 = 0x00000003, C = 0
    @ After RRX: R0 = 0x00000001 (0 goes to bit 31)
    
    @ SUBS a, b, c: C = 0 if a < b (unsigned borrow)
    @ So SUBS r0, #0, #1 will set C=0 (0 < 1)
    sub r0, r0, r0       @ r0 = 0
    subs r0, r0, #1      @ r0 = -1 (0xFFFFFFFF), C=0 (borrow occurred)
    
    mov r0, #3            @ Reset r0
    rrx r0, r0            @ C=0, so result = 0x00000001
    bkpt #0
