// A32 infra reproducer:
// inline-asm LDREX/STREX producer -> page align -> header/payload object init.
#include "test_syscall.h"

typedef unsigned int u32;

struct HeaderNode {
    u32 tag;
    u32 self;
    u32 payload;
    u32 child;
    u32 slot_value;
    u32 strex_status;
};

static unsigned char arena[0x40000] __attribute__((aligned(4096)));

static __attribute__((noinline)) u32 exclusive_increment(u32* slot, u32* status_out) {
    register u32 addr __asm__("r0") = (u32)(unsigned long)slot;
    register u32 loaded __asm__("r1");
    register u32 status __asm__("r2");
    register u32 desired __asm__("r3");

    __asm__ volatile(
        "ldrex %[loaded], [%[addr]]\n"
        "add %[desired], %[loaded], #1\n"
        "strex %[status], %[desired], [%[addr]]\n"
        : [loaded] "=&r"(loaded), [status] "=&r"(status), [desired] "=&r"(desired)
        : [addr] "r"(addr)
        : "cc", "memory");

    *status_out = status;
    return desired;
}

static __attribute__((noinline)) void build_header(u32 header_base, u32 payload_base, u32 slot_value, u32 strex_status) {
    volatile struct HeaderNode* node = (volatile struct HeaderNode*)(unsigned long)header_base;
    node->tag = 0x00EAA44Cu;
    node->self = header_base;
    node->payload = payload_base;
    node->child = header_base + 0x013Cu;
    node->slot_value = slot_value;
    node->strex_status = strex_status;
}

int test_main(void) {
    const u32 arena_base = (u32)(unsigned long)arena;
    u32 slot = arena_base + 0x0F7FFu;
    u32 strex_status = 0xFFFFFFFFu;
    const u32 produced = exclusive_increment(&slot, &strex_status);
    const u32 header_base = (produced + 0xFFFu) & ~0xFFFu;
    const u32 payload_base = header_base + 0x10000u;

    TEST_ASSERT(strex_status == 0u);
    TEST_ASSERT(slot == arena_base + 0x0F800u);
    TEST_ASSERT(produced == arena_base + 0x0F800u);
    TEST_ASSERT(header_base == arena_base + 0x10000u);
    TEST_ASSERT(payload_base == arena_base + 0x20000u);
    TEST_ASSERT(payload_base - header_base == 0x10000u);

    build_header(header_base, payload_base, produced, strex_status);

    volatile struct HeaderNode* node = (volatile struct HeaderNode*)(unsigned long)header_base;
    TEST_ASSERT(node->tag == 0x00EAA44Cu);
    TEST_ASSERT(node->self == header_base);
    TEST_ASSERT(node->payload == payload_base);
    TEST_ASSERT(node->child == header_base + 0x013Cu);
    TEST_ASSERT(node->slot_value == produced);
    TEST_ASSERT(node->strex_status == 0u);

    test_pass();
    return 0;
}
