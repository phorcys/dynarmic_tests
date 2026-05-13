/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000300000001", "D1": "0x0000000400000002" }
}
*/
.text
.global _start
_start:
    @ VST2 - Store 2-element structure
    @ Interleaved store: [D0[0], D1[0], D0[1], D1[1]]
    mov r0, #1
    mov r1, #3
    vmov d0, r0, r1      @ D0 = [1, 3]
    mov r0, #2
    mov r1, #4
    vmov d1, r0, r1      @ D1 = [2, 4]
    @ Allocate space on stack
    sub sp, sp, #32
    vst2.32 {d0, d1}, [sp]
    add sp, sp, #32
    bkpt #0
.ltorg
