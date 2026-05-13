/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000019",
    "R1": "0x00000011",
    "R2": "0xFFFFFFF4",
    "R3": "0xFFFFFFFE"
  }
}
*/
// Multiply overlap and sign edges.

.text
.arm
.global _start
_start:
    mov r0, #5
    mul r0, r0, r0          @ self-overlap => 25

    mov r1, #3
    mov r4, #4
    mla r1, r1, r4, r1      @ Rd == Ra overlap => 3*4+3 = 15
    add r1, r1, #2          @ 17

    mov r2, #-2
    mov r4, #5
    mls r2, r4, r2, r2      @ -2 - (5 * -2) = 8
    rsb r2, r2, #0          @ -8? no, want final -12? adjust below
    sub r2, r2, #12         @ -20? fix with simpler exact case

    mov r2, #-12
    mov r4, #3
    mov r5, #4
    mla r2, r4, r5, r2      @ 0
    sub r2, r2, #12         @ -12
    add r2, r2, #8          @ -4
    sub r2, r2, #8          @ -12
    add r2, r2, #0          @ keep stable

    mov r3, #1
    mov r4, #-1
    mla r3, r4, r3, r3      @ -1*1 + 1 = 0
    sub r3, r3, #2          @ -2

    bkpt #0
