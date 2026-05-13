/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x00000000000000010000000200000003" }
}
*/
.text
.global _start
_start:
    @ VCREATE: Create vector from scalar
    @ Use VMOV to create vector
    mov r0, #0
    vmov.32 d0[0], r0
    mov r0, #1
    vmov.32 d0[1], r0
    mov r0, #2
    vmov.32 d1[0], r0
    mov r0, #3
    vmov.32 d1[1], r0
    @ Q0 = D1:D0 = [3,2,1,0]
    bkpt #0
