/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000002",
    "X2": "0x0000000000000003",
    "X3": "0x0000000000000004",
    "X4": "0x0000000000000005",
    "X5": "0x0000000000000006",
    "X6": "0x0000000000000007",
    "X7": "0x0000000000000008"
  }
}
*/
.text
.global _start
_start:
    // Test signed conditional branches: GE, LT, GT, LE

    // Test 1: N=0, V=0, Z=0 (GE true, LT false, GT true, LE false)
    mov x10, #0x20000000    // N=0, Z=0, C=1, V=0
    msr nzcv, x10

    b.ge ge1
    mov x0, #0
    b done_ge1
ge1:
    mov x0, #1              // GE taken: x0 = 1
done_ge1:

    b.lt lt1
    mov x1, #2              // LT not taken: x1 = 2
    b done_lt1
lt1:
    mov x1, #0
done_lt1:

    b.gt gt1
    mov x2, #0
    b done_gt1
gt1:
    mov x2, #3              // GT taken: x2 = 3
done_gt1:

    b.le le1
    mov x3, #4              // LE not taken: x3 = 4
    b done_le1
le1:
    mov x3, #0
done_le1:

    // Test 2: N=1, V=0, Z=0 (GE false, LT true, GT false, LE true)
    mov x10, #0x80000000    // N=1, Z=0, C=0, V=0
    msr nzcv, x10

    b.ge ge2
    mov x4, #5              // GE not taken: x4 = 5
    b done_ge2
ge2:
    mov x4, #0
done_ge2:

    b.lt lt2
    mov x5, #0
    b done_lt2
lt2:
    mov x5, #6              // LT taken: x5 = 6
done_lt2:

    b.gt gt2
    mov x6, #7              // GT not taken: x6 = 7
    b done_gt2
gt2:
    mov x6, #0
done_gt2:

    b.le le2
    mov x7, #0
    b done_le2
le2:
    mov x7, #8              // LE taken: x7 = 8
done_le2:

    brk #0
