/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000000C"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r0, #0
    bl level1
    bkpt #0

level1:  push {lr} ; add r0, r0, #1 ; bl level2  ; pop {pc}
level2:  push {lr} ; add r0, r0, #1 ; bl level3  ; pop {pc}
level3:  push {lr} ; add r0, r0, #1 ; bl level4  ; pop {pc}
level4:  push {lr} ; add r0, r0, #1 ; bl level5  ; pop {pc}
level5:  push {lr} ; add r0, r0, #1 ; bl level6  ; pop {pc}
level6:  push {lr} ; add r0, r0, #1 ; bl level7  ; pop {pc}
level7:  push {lr} ; add r0, r0, #1 ; bl level8  ; pop {pc}
level8:  push {lr} ; add r0, r0, #1 ; bl level9  ; pop {pc}
level9:  push {lr} ; add r0, r0, #1 ; bl level10 ; pop {pc}
level10: push {lr} ; add r0, r0, #1 ; bl level11 ; pop {pc}
level11: push {lr} ; add r0, r0, #1 ; bl level12 ; pop {pc}
level12: add r0, r0, #1 ; bx lr
