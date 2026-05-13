// A32 infra reproducer:
// multithunk call chain + real Linux syscall return value -> page align -> header/payload object init.
#include "test_syscall.h"

typedef unsigned char u8;
typedef unsigned int u32;

struct HeaderNode {
    u32 tag;
    u32 kind;
    u32 self;
    u32 payload;
    u32 slot;
};

static u8 arena[0x40000] __attribute__((aligned(4096)));
static const char marker[] = "X";

static __attribute__((noinline)) u32 issue_write_syscall(void) {
    return (u32)sys_write(STDOUT, marker, 1);
}

static __attribute__((noinline)) u32 thunk_b(u32* slot) {
    *slot += issue_write_syscall();
    return *slot;
}

static __attribute__((noinline)) u32 thunk_a(u32* slot) {
    return thunk_b(slot);
}

static __attribute__((noinline)) void build_header(u32 header_base, u32 payload_base, u32 slot_value) {
    volatile struct HeaderNode* node = (volatile struct HeaderNode*)(unsigned long)header_base;
    node->tag = 0x00EAA44Cu;
    node->kind = 0x0Cu;
    node->self = header_base;
    node->payload = payload_base;
    node->slot = slot_value;
}

int test_main(void) {
    const u32 arena_base = (u32)(unsigned long)arena;
    u32 slot = arena_base + 0x0F876u;
    const u32 produced = thunk_a(&slot);
    const u32 header_base = (produced + 0xFFFu) & ~0xFFFu;
    const u32 payload_base = header_base + 0x10000u;

    TEST_ASSERT(produced == arena_base + 0x0F877u);
    TEST_ASSERT(header_base == arena_base + 0x10000u);
    TEST_ASSERT(payload_base == arena_base + 0x20000u);
    TEST_ASSERT(payload_base - header_base == 0x10000u);

    build_header(header_base, payload_base, produced);

    volatile struct HeaderNode* node = (volatile struct HeaderNode*)(unsigned long)header_base;
    TEST_ASSERT(node->tag == 0x00EAA44Cu);
    TEST_ASSERT(node->kind == 0x0Cu);
    TEST_ASSERT(node->self == header_base);
    TEST_ASSERT(node->payload == payload_base);
    TEST_ASSERT(node->slot == produced);

    test_pass();
    return 0;
}
