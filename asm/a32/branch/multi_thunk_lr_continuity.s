/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x000000D3",
    "R4": "0x11223344",
    "R5": "0x55667788",
    "R6": "0x00000003",
    "R7": "0x000000D3"
  }
}
*/

.text
.arm
.global _start
_start:
    mov     r4, #0x44
    orr     r4, r4, #0x3300
    orr     r4, r4, #0x220000
    orr     r4, r4, #0x11000000

    mov     r5, #0x88
    orr     r5, r5, #0x7700
    orr     r5, r5, #0x660000
    orr     r5, r5, #0x55000000

    mov     r6, #1
    bl      thunk_a
    mov     r7, r0
    bkpt    #0

thunk_a:
    push    {lr}
    add     r6, r6, #1
    bl      thunk_b
    add     r0, r0, #4
    pop     {pc}

thunk_b:
    add     r6, r6, #1
    add     r0, r4, r5
    add     r0, r0, r6
    and     r0, r0, #0xFF
    bx      lr
