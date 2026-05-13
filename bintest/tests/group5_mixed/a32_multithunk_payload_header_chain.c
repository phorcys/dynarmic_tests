// A32 infra reproducer:
// multi-thunk producer chain -> page align -> payload/header relationship -> object init.
#include "test_syscall.h"

typedef unsigned char u8;
typedef unsigned int u32;

struct RootNode {
    u32 tag;
    u32 header_base;
    u32 payload_base;
    u32 child_base;
    u32 slot_value;
};

typedef u32 (*slot_stage)(u32* slot, u32 value);
typedef u32 (*value_stage)(u32 value);

static u8 arena[0x50000] __attribute__((aligned(4096)));

static __attribute__((noinline)) u32 stage_add(u32* slot, u32 value) {
    *slot += value;
    return *slot;
}

static __attribute__((noinline)) u32 stage_align_payload(u32 value) {
    return (value + 0xFFFu) & ~0xFFFu;
}

static __attribute__((noinline)) u32 stage_header_from_payload(u32 payload_base) {
    return payload_base - 0x10000u;
}

static __attribute__((noinline)) u32 thunk_b(slot_stage op, u32* slot, u32 value) {
    return op(slot, value);
}

static __attribute__((noinline)) u32 thunk_a(slot_stage op0, slot_stage op1, u32* slot) {
    const u32 first = thunk_b(op0, slot, 0x200u);
    const u32 second = thunk_b(op1, slot, 0x588u);
    TEST_ASSERT(first == ((u32)(unsigned long)arena + 0x0FA77u));
    return second;
}

static __attribute__((noinline)) void build_root(u32 header_base, u32 payload_base, u32 slot_value) {
    volatile struct RootNode* root = (volatile struct RootNode*)(unsigned long)header_base;
    volatile u8* payload = (volatile u8*)(unsigned long)payload_base;
    const u32 child_base = header_base + 0x013Cu;

    root->tag = 0x00EAA44Cu;
    root->header_base = header_base;
    root->payload_base = payload_base;
    root->child_base = child_base;
    root->slot_value = slot_value;

    for (u32 i = 0; i < 0x20; i++) {
        payload[i] = (u8)(0x60u + ((slot_value >> (i & 7)) & 0x0Fu));
    }
}

int test_main(void) {
    static slot_stage slot_ops[] = {stage_add, stage_add};
    static value_stage value_ops[] = {stage_align_payload, stage_header_from_payload};

    const u32 arena_base = (u32)(unsigned long)arena;
    u32 slot = arena_base + 0x0F877u;
    const u32 produced = thunk_a(slot_ops[0], slot_ops[1], &slot);
    const u32 payload_base = value_ops[0](produced);
    const u32 header_base = value_ops[1](payload_base);

    TEST_ASSERT(produced == arena_base + 0x0FFFFu);
    TEST_ASSERT(payload_base == arena_base + 0x10000u);
    TEST_ASSERT(header_base == arena_base);
    TEST_ASSERT(payload_base - header_base == 0x10000u);

    build_root(header_base, payload_base, produced);

    volatile struct RootNode* root = (volatile struct RootNode*)(unsigned long)header_base;
    volatile u8* payload = (volatile u8*)(unsigned long)payload_base;

    TEST_ASSERT(root->tag == 0x00EAA44Cu);
    TEST_ASSERT(root->header_base == header_base);
    TEST_ASSERT(root->payload_base == payload_base);
    TEST_ASSERT(root->child_base == header_base + 0x013Cu);
    TEST_ASSERT(root->slot_value == produced);
    TEST_ASSERT(payload[0] == (u8)(0x60u + ((produced >> 0) & 0x0Fu)));
    TEST_ASSERT(payload[7] == (u8)(0x60u + ((produced >> 7) & 0x0Fu)));

    test_pass();
    return 0;
}
