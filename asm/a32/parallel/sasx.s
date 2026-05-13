/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00010002" },
  "VecData": {}
}
*/
.text
.global _start
_start:
    // SASX 测试 - 使用 QEMU 验证的结果
    mov r1, #2
    mov r2, #1
    
    sasx r0, r1, r2
    
    bkpt #0