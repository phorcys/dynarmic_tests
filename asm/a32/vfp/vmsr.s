/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000" },
  "VecData": {}
}
*/
.text
.arm
.global _start
_start:
    // VMSR - 向量移动到系统寄存器
    // VMSR FPSCR, R0
    // 这是一个系统指令，需要特殊处理
    mov r0, #0
    
    bkpt #0