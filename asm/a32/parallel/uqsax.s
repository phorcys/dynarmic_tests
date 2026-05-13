/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000002" },
  "VecData": {}
}
*/
.text
.global _start
_start:
    // UQSAX 测试
    mov r1, #2
    mov r2, #1
    
    uqsax r0, r1, r2
    
    bkpt #0
