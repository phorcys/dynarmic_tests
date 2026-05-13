/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xA0000000"
  }
}
*/
.text
.arm
.global _start
_start:
    @ Test CMP setting NZCV flags
    @ CMP 0xFFFFFFFF, 0 should set:
    @ N = 1 (result negative)
    @ Z = 0 (result not zero)
    @ C = 1 (no borrow, 0xFFFFFFFF >= 0)
    @ V = 0 (no overflow)
    @ NZCV = 0xA0000000 (N=1, Z=0, C=1, V=0)
    
    mvn r0, #0            @ r0 = 0xFFFFFFFF
    cmp r0, #0            @ Compare 0xFFFFFFFF with 0
    
    @ Read NZCV using MRS
    mrs r0, cpsr
    and r0, r0, #0xF0000000   @ Extract NZCV bits
    bkpt #0
