/* CONFIG
{
  "Match": "All",
  "RegData": { "D2": "0x0000000003020100" }
}
*/
.text
.global _start
_start:
    @ Vtbl: Vector Table Lookup
    @ VTBL.8 Vd, {Vn}, Vm
    @ Each byte in Vm is an index into table Vn
    
    @ Create table: [0, 1, 2, 3]
    ldr r0, =0x03020100
    vmov d0, r0, r1      @ D0 = table [0, 1, 2, 3, 0, 0, 0, 0]
    
    @ Create indices: [0, 1, 2, 3, ...]
    ldr r0, =0x03020100
    vmov d1, r0, r1      @ D1 = indices
    
    vtbl.8 d2, {d0}, d1  @ D2 = table[indices]
    
    bkpt #0
.ltorg
