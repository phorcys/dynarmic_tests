// A32 infra reproducer:
// inline-asm GE setup + SEL producer -> page align -> header/payload object init.
#include "test_syscall.h"

typedef unsigned int u32;

struct HeaderNode {
    u32 tag;
    u32 self;
    u32 payload;
    u32 child;
    u32 slot_value;
};

static unsigned char arena[0x40000] __attribute__((aligned(4096)));

static __attribute__((noinline)) u32 build_sel_offset(void) {
    register u32 lhs __asm__("r0") = 0x0000FC00u;
    register u32 rhs __asm__("r1") = 0x00000000u;
    register u32 ge_lhs __asm__("r3") = 0xFFFFFFFFu;
    register u32 ge_rhs __asm__("r4") = 0x00000000u;
    register u32 ge_tmp __asm__("r5");
    register u32 out __asm__("r2");
    __asm__ volatile(
        "usub8 %[tmp], %[ge_lhs], %[ge_rhs]\n"
        "sel %[out], %[lhs], %[rhs]\n"
        : [out] "=r"(out)
        : [lhs] "r"(lhs), [rhs] "r"(rhs), [ge_lhs] "r"(ge_lhs), [ge_rhs] "r"(ge_rhs), [tmp] "r"(ge_tmp)
        : "cc");
    return out;
}

static __attribute__((noinline)) void build_header(u32 header_base, u32 payload_base, u32 slot_value) {
    volatile struct HeaderNode* node = (volatile struct HeaderNode*)(unsigned long)header_base;
    node->tag = 0x00EAA44Cu;
    node->self = header_base;
    node->payload = payload_base;
    node->child = header_base + 0x013Cu;
    node->slot_value = slot_value;
}

int test_main(void) {
    const u32 arena_base = (u32)(unsigned long)arena;
    const u32 offset = build_sel_offset();
    const u32 producer = arena_base + offset;
    const u32 header_base = (producer + 0xFFFu) & ~0xFFFu;
    const u32 payload_base = header_base + 0x10000u;

    TEST_ASSERT(offset == 0x0000FC00u);
    TEST_ASSERT(producer == arena_base + 0x0000FC00u);
    TEST_ASSERT(header_base == arena_base + 0x00010000u);
    TEST_ASSERT(payload_base == arena_base + 0x00020000u);
    TEST_ASSERT(payload_base - header_base == 0x10000u);

    build_header(header_base, payload_base, producer);

    volatile struct HeaderNode* node = (volatile struct HeaderNode*)(unsigned long)header_base;
    TEST_ASSERT(node->tag == 0x00EAA44Cu);
    TEST_ASSERT(node->self == header_base);
    TEST_ASSERT(node->payload == payload_base);
    TEST_ASSERT(node->child == header_base + 0x013Cu);
    TEST_ASSERT(node->slot_value == producer);

    test_pass();
    return 0;
}
