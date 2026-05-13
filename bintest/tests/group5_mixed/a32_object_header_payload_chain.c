// A32 infra reproducer:
// multi-stage producer chain -> jump table -> align -> header/subobject/payload init.
#include "test_syscall.h"

typedef unsigned char u8;
typedef unsigned int u32;

struct RootHeader {
    u32 tag;
    u32 flags;
    u32 self;
    u32 child;
    u32 payload;
    u32 cookie;
    u32 slot_value;
};

struct ChildHeader {
    u32 tag;
    u32 parent;
    u32 payload;
    u32 stamp;
};

typedef u32 (*slot_stage)(u32* slot, u32 a, u32 b);
typedef u32 (*value_stage)(u32 value);

static u8 arena[0x40000] __attribute__((aligned(4096)));

static __attribute__((noinline)) u32 stage_add_minus_one(u32* slot, u32 a, u32 b) {
    *slot = *slot + a + b - 1u;
    return *slot;
}

static __attribute__((noinline)) u32 stage_identity(u32 value) {
    return value;
}

static __attribute__((noinline)) u32 stage_align_4k(u32 value) {
    return (value + 0xFFFu) & ~0xFFFu;
}

static __attribute__((noinline)) void build_child(u32 child_base, u32 parent_base, u32 payload_base) {
    volatile struct ChildHeader* child = (volatile struct ChildHeader*)(unsigned long)child_base;
    child->tag = 0xC1A0C1A0u;
    child->parent = parent_base;
    child->payload = payload_base;
    child->stamp = payload_base ^ 0x55AA55AAu;
}

static __attribute__((noinline)) void build_root(u32 header_base, u32 payload_base, u32 slot_value) {
    volatile struct RootHeader* root = (volatile struct RootHeader*)(unsigned long)header_base;
    const u32 child_base = header_base + 0x013Cu;
    volatile u8* payload = (volatile u8*)(unsigned long)payload_base;

    root->tag = 0x00EAA44Cu;
    root->flags = 0x0000000Cu;
    root->self = header_base;
    root->child = child_base;
    root->payload = payload_base;
    root->cookie = slot_value ^ 0xA5A5A5A5u;
    root->slot_value = slot_value;

    for (u32 i = 0; i < 0x20; i++) {
        payload[i] = (u8)(0x41u + ((slot_value >> (i & 7)) & 0x0Fu));
    }

    build_child(child_base, header_base, payload_base);
}

int test_main(void) {
    static slot_stage slot_table[] = {stage_add_minus_one};
    static value_stage value_table[] = {stage_identity, stage_align_4k};

    const u32 arena_base = (u32)(unsigned long)arena;
    u32 slot = arena_base + 0x0FC77u;

    const u32 produced = slot_table[0](&slot, 0x00000480u, 0x00000008u);
    const u32 routed = value_table[0](produced);
    const u32 header_base = value_table[1](routed);
    const u32 payload_base = header_base + 0x10000u;
    const u32 child_base = header_base + 0x013Cu;

    test_printstr("A32 object/header/payload chain...\n");
    test_printstr("  header_base: ");
    test_printhex(header_base);
    test_printstr("\n  child_base: ");
    test_printhex(child_base);
    test_printstr("\n  payload_base: ");
    test_printhex(payload_base);
    test_printstr("\n");

    TEST_ASSERT(produced == routed);
    TEST_ASSERT(produced == arena_base + 0x100FEu);
    TEST_ASSERT(header_base == arena_base + 0x11000u);
    TEST_ASSERT(payload_base == arena_base + 0x21000u);
    TEST_ASSERT(payload_base + 0x20u <= arena_base + sizeof(arena));

    build_root(header_base, payload_base, produced);

    volatile struct RootHeader* root = (volatile struct RootHeader*)(unsigned long)header_base;
    volatile struct ChildHeader* child = (volatile struct ChildHeader*)(unsigned long)child_base;
    volatile u8* payload = (volatile u8*)(unsigned long)payload_base;

    TEST_ASSERT(root->tag == 0x00EAA44Cu);
    TEST_ASSERT(root->flags == 0x0000000Cu);
    TEST_ASSERT(root->self == header_base);
    TEST_ASSERT(root->child == child_base);
    TEST_ASSERT(root->payload == payload_base);
    TEST_ASSERT(root->cookie == (produced ^ 0xA5A5A5A5u));
    TEST_ASSERT(root->slot_value == produced);

    TEST_ASSERT(child->tag == 0xC1A0C1A0u);
    TEST_ASSERT(child->parent == header_base);
    TEST_ASSERT(child->payload == payload_base);
    TEST_ASSERT(child->stamp == (payload_base ^ 0x55AA55AAu));

    TEST_ASSERT(payload[0] == (u8)(0x41u + ((produced >> 0) & 0x0Fu)));
    TEST_ASSERT(payload[7] == (u8)(0x41u + ((produced >> 7) & 0x0Fu)));
    TEST_ASSERT(payload[15] == (u8)(0x41u + ((produced >> 7) & 0x0Fu)));

    test_printstr("All object/header/payload tests passed!\n");
    test_pass();
    return 0;
}
