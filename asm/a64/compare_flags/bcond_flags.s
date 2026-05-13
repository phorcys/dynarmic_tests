/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000002",
    "X2": "0x0000000000000003",
    "X3": "0x0000000000000004"
  }
}
*/
.text
.global _start
_start:
    // Test conditional branch B.cond
    // Test EQ/NE conditions

    // Test 1: Z=1 (EQ true, NE false)
    mov x10, #0x40000000    // N=0, Z=1, C=0, V=0
    msr nzcv, x10

    b.eq label1
    mov x0, #0              // Should not execute
    b done1
label1:
    mov x0, #1              // EQ taken: x0 = 1
done1:

    b.ne label2
    mov x1, #0              // NE not taken: x1 = 0? No, NE is false so branch not taken
    b done2
label2:
    mov x1, #99             // Should not execute
done2:
    mov x1, #2              // x1 = 2 (after not taken)

    // Test 2: Z=0 (EQ false, NE true)
    mov x10, #0x00000000    // N=0, Z=0, C=0, V=0
    msr nzcv, x10

    b.eq label3
    mov x2, #3              // EQ not taken: x2 = 3
    b done3
label3:
    mov x2, #99             // Should not execute
done3:

    b.ne label4
    mov x3, #0              // Should not execute
    b done4
label4:
    mov x3, #4              // NE taken: x3 = 4
done4:

    brk #0
