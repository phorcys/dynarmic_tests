/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFF0002" },
  "VecData": {}
}
*/
.text
.global _start
_start:
    // SSAX 测试
    mov r1, #2
    mov r2, #1
    
    ssax r0, r1, r2
    
    bkpt #0
