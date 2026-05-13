// A32 infra reproducer:
// memory-resident function table -> indirect thunk dispatch -> page align -> header/child object init.
#include "test_syscall.h"

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

typedef u32 (*stage_fn)(u32* slot, u32 value);
typedef u32 (*dispatch_fn)(stage_fn fn, u32* slot, u32 value);

struct VTableLike {
    dispatch_fn invoke;
    stage_fn stages[2];
};

static unsigned char arena[0x50000] __attribute__((aligned(4096)));

static __attribute__((noinline)) u32 stage_add_0x240(u32* slot, u32 value) {
    *slot += value;
    return *slot;
}

static __attribute__((noinline)) u32 stage_add_0x53Fu(u32* slot, u32 value) {
    *slot += value;
    return *slot;
}

static __attribute__((noinline)) u32 indirect_invoke(stage_fn fn, u32* slot, u32 value) {
    return fn(slot, value);
}

static __attribute__((noinline)) u32 thunk_b(dispatch_fn invoke, stage_fn fn, u32* slot, u32 value) {
    return invoke(fn, slot, value);
}

static __attribute__((noinline)) u32 thunk_a(struct VTableLike* vt, u32* slot) {
    const u32 a = thunk_b(vt->invoke, vt->stages[0], slot, 0x240u);
    const u32 b = thunk_b(vt->invoke, vt->stages[1], slot, 0x53Fu);
    TEST_ASSERT(b - a == 0x53Fu);
    return b;
}

static __attribute__((noinline)) void build_nodes(u32 header_base, u32 payload_base, u32 slot_value) {
    volatile struct RootNode* root = (volatile struct RootNode*)(unsigned long)header_base;
    volatile struct ChildNode* child = (volatile struct ChildNode*)(unsigned long)(header_base + 0x013Cu);

    root->tag = 0x00EAA44Cu;
    root->self = header_base;
    root->payload = payload_base;
    root->child = header_base + 0x013Cu;
    root->slot_value = slot_value;

    child->kind = 0x41u;
    child->parent = header_base;
    child->payload = payload_base;
    child->stamp = slot_value ^ 0x00FF00FFu;
}

int test_main(void) {
    struct VTableLike vt = {
        .invoke = indirect_invoke,
        .stages = {stage_add_0x240, stage_add_0x53Fu},
    };

    const u32 arena_base = (u32)(unsigned long)arena;
    u32 slot = arena_base + 0x0F881u;
    const u32 produced = thunk_a(&vt, &slot);
    const u32 payload_base = (produced + 0xFFFu) & ~0xFFFu;
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

    TEST_ASSERT(child->kind == 0x41u);
    TEST_ASSERT(child->parent == header_base);
    TEST_ASSERT(child->payload == payload_base);
    TEST_ASSERT(child->stamp == (produced ^ 0x00FF00FFu));

    test_pass();
    return 0;
}
