// A32 infra reproducer:
// function-pointer / jump-table producer -> multistage value chain -> page align -> header/payload object init.
#include "test_syscall.h"

typedef unsigned int u32;

struct HeaderNode {
    u32 tag;
    u32 self;
    u32 payload;
    u32 child;
    u32 slot_value;
};

typedef u32 (*slot_stage_fn)(u32* slot, u32 value);
typedef u32 (*value_stage_fn)(u32 value);

static unsigned char arena[0x50000] __attribute__((aligned(4096)));

static __attribute__((noinline)) u32 stage_add_small(u32* slot, u32 value) {
    *slot += value;
    return *slot;
}

static __attribute__((noinline)) u32 stage_add_large(u32* slot, u32 value) {
    *slot += value;
    return *slot;
}

static __attribute__((noinline)) u32 stage_align_payload(u32 value) {
    return (value + 0xFFFu) & ~0xFFFu;
}

static __attribute__((noinline)) u32 stage_header_from_payload(u32 payload_base) {
    return payload_base - 0x10000u;
}

static __attribute__((noinline)) u32 dispatch_slot_stage(slot_stage_fn fn, u32* slot, u32 value) {
    return fn(slot, value);
}

static __attribute__((noinline)) u32 build_slot_value(slot_stage_fn* table, u32* slot) {
    const u32 first = dispatch_slot_stage(table[0], slot, 0x200u);
    const u32 second = dispatch_slot_stage(table[1], slot, 0x588u);
    TEST_ASSERT(first + 0x588u == second);
    return second;
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
    static slot_stage_fn slot_table[] = {stage_add_small, stage_add_large};
    static value_stage_fn value_table[] = {stage_align_payload, stage_header_from_payload};

    const u32 arena_base = (u32)(unsigned long)arena;
    u32 slot = arena_base + 0x0F877u;
    const u32 produced = build_slot_value(slot_table, &slot);
    const u32 payload_base = value_table[0](produced);
    const u32 header_base = value_table[1](payload_base);

    TEST_ASSERT(produced == arena_base + 0x0FFFFu);
    TEST_ASSERT(payload_base == arena_base + 0x10000u);
    TEST_ASSERT(header_base == arena_base);
    TEST_ASSERT(payload_base - header_base == 0x10000u);

    build_header(header_base, payload_base, produced);

    volatile struct HeaderNode* node = (volatile struct HeaderNode*)(unsigned long)header_base;
    TEST_ASSERT(node->tag == 0x00EAA44Cu);
    TEST_ASSERT(node->self == header_base);
    TEST_ASSERT(node->payload == payload_base);
    TEST_ASSERT(node->child == header_base + 0x013Cu);
    TEST_ASSERT(node->slot_value == produced);

    test_pass();
    return 0;
}
