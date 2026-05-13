/* CONFIG
{
  "Match": "All",
  "QemuSkip": "This ADRP absolute-address test assumes a fixed image base under the QEMU runner",
  "RegData": { "X2": "0x0000000012345678" },
  "MemData": { "0x1000": ["0x0000000012345678"] }
}
*/
// ADRP + ADD :lo12: test
// Data is initialized via MemData at address 0x1000

.text
.global _start
_start:
    // Test ADRP+ADD to access data at 0x1000
    // ADRP loads page-aligned address (PC & ~0xFFF) + (imm << 12)
    // At PC=0, we need to load page 0x1000, so imm = 1
    adrp x1, 0x1000
    // ADD adds the page offset (0x0 in this case)
    add x1, x1, #0x0
    
    // Load from the computed address (0x1000)
    ldr x2, [x1]
    // X2 should be 0x12345678
    
    brk #0
