/* CONFIG
{
  "Match": "All",
  "TlsData": {
    "0x0": "0x00000C77"
  },
  "SvcTest": [
    {"svc": "0x10", "action": "read_tls", "offset": "0x0", "result_reg": "R0"}
  ],
  "RegData": {
    "R0": "0x00001000",
    "R4": "0x00001000",
    "R5": "0x00002000",
    "R6": "0xCAFEBABE",
    "R7": "0x00002000",
    "R8": "0xCAFEBABE",
    "R9": "0x00001000"
  }
}
*/

.text
.arm
.global _start
_start:
    svc     #0x10
    bl      thunk_a
    mov     r9, r0
    ldr     r6, [r4]
    ldr     r7, [r4, #4]
    ldr     r8, [r4, #8]
    bkpt    #0

thunk_a:
    push    {lr}
    bl      thunk_b
    mov     r4, r0
    add     r5, r4, #0x1000
    bl      init_header
    mov     r0, r4
    pop     {pc}

thunk_b:
    push    {lr}
    add     r0, r0, #0xF00
    add     r0, r0, #0x89
    lsr     r0, r0, #12
    lsl     r0, r0, #12
    pop     {pc}

init_header:
    push    {lr}
    ldr     r1, =0xCAFEBABE
    str     r1, [r4]
    str     r5, [r4, #4]
    str     r1, [r4, #8]
    pop     {pc}
