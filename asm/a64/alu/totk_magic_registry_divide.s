/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000001",
    "X2": "0x0000000060000000",
    "X3": "0x0000000000000001",
    "X4": "0x0000000000000001",
    "X5": "0x0000000060000000",
    "X6": "0x0000000000000002",
    "X7": "0x0000000000000000",
    "X8": "0x0000000080000000"
  }
}
*/
// TOTK-derived sequence from 0x8000417c:
//   q = ((smulh(end - begin, 0x2aaaaaaaaaaaaaab) >> 2) +
//        (smulh(...) >> 63))
//   subs count, q
//   cset cs
// This file checks both the arithmetic chain and the flags outcome.

.text
.global _start

_start:
    // Magic divisor reciprocal used by the guest code.
    movz x20, #0xaaab
    movk x20, #0xaaaa, lsl #16
    movk x20, #0xaaaa, lsl #32
    movk x20, #0x2aaa, lsl #48

    // Case 0: begin == end, count == 0
    movz x9, #0xca40
    movk x9, #0x8465, lsl #16
    mov x10, x9
    mov x11, #0
    sub x12, x10, x9
    smulh x13, x12, x20
    asr x14, x13, #2
    lsr x15, x13, #63
    add x16, x14, x15
    subs x17, x11, x16
    mov x0, x16
    cset x1, cs
    mrs x2, nzcv

    // Case 1: diff = 0x18, count == 1  => q == 1, CS == 1
    mov x9, #0x1000
    add x10, x9, #0x18
    mov x11, #1
    sub x12, x10, x9
    smulh x13, x12, x20
    asr x14, x13, #2
    lsr x15, x13, #63
    add x16, x14, x15
    subs x17, x11, x16
    mov x3, x16
    cset x4, cs
    mrs x5, nzcv

    // Case 2: diff = 0x30, count == 1  => q == 2, CS == 0
    mov x9, #0x1000
    add x10, x9, #0x30
    mov x11, #1
    sub x12, x10, x9
    smulh x13, x12, x20
    asr x14, x13, #2
    lsr x15, x13, #63
    add x16, x14, x15
    subs x17, x11, x16
    mov x6, x16
    cset x7, cs
    mrs x8, nzcv

    brk #0
