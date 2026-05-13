/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000300000001", "D1": "0x0000000400000002" }
}
*/
.text
.global _start
_start:
    @ VLD2 - Load 2-element structure
    @ Interleaved load: D0 = [1, 3], D1 = [2, 4]
    ldr r0, =data_buf
    vld2.32 {d0, d1}, [r0]
    bkpt #0
    
data_buf:
    .word 1
    .word 2
    .word 3
    .word 4
.ltorg
