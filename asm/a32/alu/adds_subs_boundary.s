/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x80000000",
    "R1": "0x00000000",
    "R2": "0xFFFFFFFF",
    "R3": "0x00000000"
  }
}
*/
// Test: ADDS/SUBS flags - 边界条件测试
// 测试溢出、进位、零标志等

.text
.arm
.global _start
_start:
    @ Test 1: ADDS 溢出 (有符号)
    @ 0x7FFFFFFF + 1 = 0x80000000 (有符号溢出)
    ldr r4, =0x7FFFFFFF     @ 最大有符号正数
    adds r0, r4, #1         @ 结果 = 0x80000000, V=1
    
    @ Test 2: ADDS 进位 (无符号)
    @ 0xFFFFFFFF + 1 = 0 (进位)
    mvn r5, #0              @ r5 = 0xFFFFFFFF
    adds r1, r5, #1         @ 结果 = 0, C=1, Z=1
    
    @ Test 3: SUBS 借位
    @ 0 - 1 = 0xFFFFFFFF (借位)
    mov r6, #0
    subs r2, r6, #1         @ 结果 = 0xFFFFFFFF, C=0 (borrow)
    
    @ Test 4: SUBS 零结果
    @ 5 - 5 = 0
    mov r7, #5
    subs r3, r7, #5         @ 结果 = 0, Z=1, C=1
    
    bkpt #0
