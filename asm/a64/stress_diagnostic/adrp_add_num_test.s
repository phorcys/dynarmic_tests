/* CONFIG
{
  "Match": "All",
  "QemuSkip": "This ADRP+ADD numeric-offset test assumes a fixed code layout under the QEMU runner",
  "RegData": { "X0": "0x0000000000000002" }
}
*/
// ADRP + ADD with numeric offset

.text
.global _start
_start:
    mov x0, #1
    
    // indirect_func is at offset 0x14 (20 bytes)
    // ADRP gives page address (0 since PC=0)
    // ADD with correct offset
    adrp x2, indirect_func
    add x2, x2, #0x14
    blr x2
    // x0 = 2 now
    
    brk #0

indirect_func:
    add x0, x0, #1
    ret
