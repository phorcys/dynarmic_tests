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
    // Test unsigned conditional branches: HI, LS, CS, CC

    // Test 1: C=1, Z=0 (HI true, LS false, CS true, CC false)
    mov x10, #0x20000000    // N=0, Z=0, C=1, V=0
    msr nzcv, x10

    b.hi hi1
    mov x0, #0
    b done_hi1
hi1:
    mov x0, #1              // HI taken (C=1, Z=0): x0 = 1
done_hi1:

    b.ls ls1
    mov x1, #2              // LS not taken: x1 = 2
    b done_ls1
ls1:
    mov x1, #0
done_ls1:

    // Test 2: C=0, Z=0 (HI false, LS true, CS false, CC true)
    mov x10, #0x00000000    // N=0, Z=0, C=0, V=0
    msr nzcv, x10

    b.cs cs1
    mov x2, #3              // CS not taken: x2 = 3
    b done_cs1
cs1:
    mov x2, #0
done_cs1:

    b.cc cc1
    mov x3, #0
    b done_cc1
cc1:
    mov x3, #4              // CC taken (C=0): x3 = 4
done_cc1:

    brk #0
