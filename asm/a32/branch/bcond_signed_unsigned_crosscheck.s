/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000011",
    "R1": "0x00000022",
    "R2": "0x00000033",
    "R3": "0x00000044"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0xFFFFFFFF
    cmp r4, #1
    bhi unsigned_high
    mov r0, #0
unsigned_high:
    mov r0, #0x11

    cmp r4, #1
    bgt signed_greater
    mov r1, #0x22
    b after_signed
signed_greater:
    mov r1, #0
after_signed:

    mov r4, #0
    cmp r4, #0
    beq equal_case
    mov r2, #0
equal_case:
    mov r2, #0x33

    mov r4, #0
    cmp r4, #1
    bls lower_same
    mov r3, #0
lower_same:
    mov r3, #0x44

    bkpt #0
