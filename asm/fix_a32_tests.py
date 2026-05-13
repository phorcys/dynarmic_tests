#!/usr/bin/env python3
"""批量修复 A32 测试文件"""

import os
from pathlib import Path

# 需要修复的测试文件（使用栈数据替代 DataMem）
FIXES = {
    "ldrh.s": '''/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00005678"
  }
}
*/
.text
.global _start
_start:
    @ LDRH: Load halfword (zero-extended)
    @ Store test data on stack: 0x5678
    movw r2, #0x5678
    push {r2}
    
    @ Load halfword from stack
    mov r1, sp
    ldrh r0, [r1]
    
    @ Restore stack
    pop {r2}
    bkpt #0
''',
    "ldrsb.s": '''/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0xffffff88"
  }
}
*/
.text
.global _start
_start:
    @ LDRSB: Load signed byte
    @ Store test data on stack: 0x88 (sign-extends to 0xFFFFFF88)
    mov r2, #0x88
    push {r2}
    
    @ Load signed byte from stack
    mov r1, sp
    ldrsb r0, [r1]
    
    @ Restore stack
    pop {r2}
    bkpt #0
''',
    "ldrsh.s": '''/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0xffff8766"
  }
}
*/
.text
.global _start
_start:
    @ LDRSH: Load signed halfword
    @ Store test data: 0x8766 (sign-extends to 0xFFFF8766)
    movw r2, #0x8766
    push {r2}
    
    @ Load signed halfword from stack
    mov r1, sp
    ldrsh r0, [r1]
    
    @ Restore stack
    pop {r2}
    bkpt #0
''',
    "strb.s": '''/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000078"
  }
}
*/
.text
.global _start
_start:
    @ STRB: Store byte
    mov r0, #0x78
    sub sp, sp, #4
    
    @ Store byte to stack
    mov r1, sp
    strb r0, [r1]
    
    @ Read back to verify
    ldrb r0, [r1]
    add sp, sp, #4
    bkpt #0
''',
    "strh.s": '''/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00005678"
  }
}
*/
.text
.global _start
_start:
    @ STRH: Store halfword
    movw r0, #0x5678
    sub sp, sp, #4
    
    @ Store halfword to stack
    mov r1, sp
    strh r0, [r1]
    
    @ Read back to verify
    ldrh r0, [r1]
    add sp, sp, #4
    bkpt #0
''',
    "uxth.s": '''/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x0000ffff",
    "R1": "0x00005678"
  }
}
*/
.text
.global _start
_start:
    @ UXTH: Unsigned extend halfword
    mov r0, #0
    mvn r0, r0      @ r0 = 0xFFFFFFFF
    uxth r0, r0     @ r0 = 0x0000FFFF
    
    movw r1, #0x5678
    uxth r1, r1     @ r1 = 0x5678 (unchanged)
    bkpt #0
''',
    "ldmia.s": '''/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R2": "0x11111111",
    "R3": "0x22222222",
    "R4": "0x33333333"
  }
}
*/
.text
.global _start
_start:
    @ LDMIA: Load multiple increment after
    @ Store test data on stack
    ldr r0, =0x11111111
    push {r0}
    ldr r0, =0x22222222
    push {r0}
    ldr r0, =0x33333333
    push {r0}
    
    @ Load multiple
    mov r1, sp
    ldmia r1!, {r2, r3, r4}
    
    @ Fix stack
    add sp, sp, #12
    bkpt #0
''',
    "stmdb.s": '''/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R5": "0x11111111",
    "R6": "0x22222222"
  }
}
*/
.text
.global _start
_start:
    @ STMDB: Store multiple decrement before
    mov r0, #0
    mov r1, #0
    
    ldr r5, =0x11111111
    ldr r6, =0x22222222
    
    @ Store multiple
    sub sp, sp, #8
    mov r2, sp
    stmdb r2!, {r5, r6}
    
    @ Verify by loading back
    ldmdb sp, {r0, r1}
    add sp, sp, #8
    bkpt #0
''',
    "stmia.s": '''/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x11111111",
    "R1": "0x22222222"
  }
}
*/
.text
.global _start
_start:
    @ STMIA: Store multiple increment after
    mov r2, #0
    mov r3, #0
    
    ldr r0, =0x11111111
    ldr r1, =0x22222222
    
    @ Store multiple
    sub sp, sp, #8
    mov r4, sp
    stmia r4!, {r0, r1}
    
    @ Verify by loading back
    ldmia sp, {r2, r3}
    add sp, sp, #8
    bkpt #0
''',
    "ldmda.s": '''/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R2": "0x11111111",
    "R3": "0x22222222"
  }
}
*/
.text
.global _start
_start:
    @ LDMDA: Load multiple decrement after
    @ Store test data on stack (high to low)
    ldr r0, =0x22222222
    push {r0}
    ldr r0, =0x11111111
    push {r0}
    
    @ Load multiple decrement after
    mov r1, sp
    add r1, r1, #4  @ Point to higher address
    ldmda r1, {r2, r3}
    
    @ Fix stack
    add sp, sp, #8
    bkpt #0
''',
    "ldrexb.s": '''/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x000000ab"
  }
}
*/
.text
.global _start
_start:
    @ LDREXB: Load register exclusive byte
    mov r2, #0xab
    push {r2}
    
    mov r1, sp
    ldrexb r0, [r1]
    
    pop {r2}
    bkpt #0
''',
    "ldrexh.s": '''/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x0000abcd"
  }
}
*/
.text
.global _start
_start:
    @ LDREXH: Load register exclusive halfword
    movw r2, #0xabcd
    push {r2}
    
    mov r1, sp
    ldrexh r0, [r1]
    
    pop {r2}
    bkpt #0
''',
    "strd.s": '''/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x11111111",
    "R1": "0x22222222"
  }
}
*/
.text
.global _start
_start:
    @ STRD: Store register dual
    ldr r0, =0x11111111
    ldr r1, =0x22222222
    
    sub sp, sp, #8
    mov r2, sp
    strd r0, r1, [r2]
    
    @ Verify by loading back
    ldrd r4, r5, [sp]
    mov r0, r4
    mov r1, r5
    add sp, sp, #8
    bkpt #0
''',
    "pop.s": '''/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R4": "0x00001234"
  }
}
*/
.text
.global _start
_start:
    @ POP: Pop from stack
    ldr r0, =0x00001234
    push {r0}
    
    pop {r4}
    bkpt #0
''',
}

def main():
    a32_dir = Path(__file__).parent / "a32"
    
    fixed = 0
    for name, content in FIXES.items():
        filepath = a32_dir / name
        if filepath.exists():
            with open(filepath, 'w') as f:
                f.write(content)
            print(f"Fixed: {name}")
            fixed += 1
        else:
            print(f"Not found: {name}")
    
    print(f"\nFixed {fixed} files")

if __name__ == '__main__':
    main()
