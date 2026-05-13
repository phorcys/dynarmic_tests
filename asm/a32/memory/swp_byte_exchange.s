/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000011",
    "R1": "0x00000022"
  }
}
*/
.text
.arm
.global _start
_start:
    @ SWPB byte exchange
    sub sp, sp, #16
    mov r0, #0x11
    strb r0, [sp]            @ Store data on stack
    
    ldrb r0, [sp]            @ R0 = data byte = 0x11
    mov r1, #0x22
    swpb r0, r1, [sp]        @ R0 = old data byte, memory = R1 byte
    bkpt #0
