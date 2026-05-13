// A32 infra reproducer:
// real syscall result -> function-table dispatch -> multistage slot producer -> header/payload/child chain.
#include "test_syscall.h"

typedef unsigned char u8;
typedef unsigned int u32;

struct RootNode {
    u32 tag;
    u32 self;
    u32 payload;
    u32 child;
    u32 slot_value;
};

struct ChildNode {
    u32 kind;
    u32 parent;
    u32 payload;
    u32 stamp;
};

typedef u32 (*slot_stage_fn)(u32* slot, u32 value);

static u8 arena[0x50000] __attribute__((aligned(4096)));

static __attribute__((noinline)) u32 stage_add_a(u32* slot, u32 value) {
    *slot += value;
    return *slot;
}

static __attribute__((noinline)) u32 stage_add_b(u32* slot, u32 value) {
    *slot += value;
    return *slot;
}

static __attribute__((noinline)) u32 dispatch_stage(slot_stage_fn fn, u32* slot, u32 value) {
    return fn(slot, value);
}

static __attribute__((noinline)) u32 produce_slot_value(slot_stage_fn* table, u32 index, u32* slot) {
    const u32 first = dispatch_stage(table[index ^ 1u], slot, 0x180u);
    const u32 second = dispatch_stage(table[index], slot, 0x67Fu);
    TEST_ASSERT(second - first == 0x67Fu);
    return second;
}

static __attribute__((noinline)) u32 align_payload(u32 value) {
    return (value + 0xFFFu) & ~0xFFFu;
}

static __attribute__((noinline)) void build_nodes(u32 header_base, u32 payload_base, u32 slot_value) {
    volatile struct RootNode* root = (volatile struct RootNode*)(unsigned long)header_base;
    volatile struct ChildNode* child = (volatile struct ChildNode*)(unsigned long)(header_base + 0x013Cu);

    root->tag = 0x00EAA44Cu;
    root->self = header_base;
    root->payload = payload_base;
    root->child = header_base + 0x013Cu;
    root->slot_value = slot_value;

    child->kind = 0x21u;
    child->parent = header_base;
    child->payload = payload_base;
    child->stamp = slot_value ^ 0x00FF00FFu;
}

int test_main(void) {
    static slot_stage_fn table[] = {stage_add_a, stage_add_b};

    const u32 arena_base = (u32)(unsigned long)arena;
    const u32 pid = (u32)sys_getpid();
    const u32 index = pid & 1u;
    u32 slot = arena_base + 0x0F801u;
    const u32 produced = produce_slot_value(table, index, &slot);
    const u32 payload_base = align_payload(produced);
    const u32 header_base = payload_base - 0x10000u;

    TEST_ASSERT(produced == arena_base + 0x10000u);
    TEST_ASSERT(payload_base == arena_base + 0x10000u);
    TEST_ASSERT(header_base == arena_base);
    TEST_ASSERT(payload_base - header_base == 0x10000u);

    build_nodes(header_base, payload_base, produced);

    volatile struct RootNode* root = (volatile struct RootNode*)(unsigned long)header_base;
    volatile struct ChildNode* child = (volatile struct ChildNode*)(unsigned long)(header_base + 0x013Cu);

    TEST_ASSERT(root->tag == 0x00EAA44Cu);
    TEST_ASSERT(root->self == header_base);
    TEST_ASSERT(root->payload == payload_base);
    TEST_ASSERT(root->child == header_base + 0x013Cu);
    TEST_ASSERT(root->slot_value == produced);

    TEST_ASSERT(child->kind == 0x21u);
    TEST_ASSERT(child->parent == header_base);
    TEST_ASSERT(child->payload == payload_base);
    TEST_ASSERT(child->stamp == (produced ^ 0x00FF00FFu));

    test_pass();
    return 0;
}
