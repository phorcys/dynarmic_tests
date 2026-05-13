// A32 infra reproducer:
// real syscall return selects function-pointer path, then nested thunk chain updates a stack slot and builds header/child nodes.
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

typedef u32 (*slot_stage_fn)(u32* slot, u32 value);

static unsigned char arena[0x50000] __attribute__((aligned(4096)));
static const char marker[] = "Z";

static __attribute__((noinline)) u32 add_0x100(u32* slot, u32 value) {
    *slot += value;
    return *slot;
}

static __attribute__((noinline)) u32 add_0x7ff(u32* slot, u32 value) {
    *slot += value;
    return *slot;
}

static __attribute__((noinline)) u32 do_write(void) {
    return (u32)sys_write(STDOUT, marker, 1);
}

static __attribute__((noinline)) u32 dispatch_stage(slot_stage_fn fn, u32* slot, u32 value) {
    return fn(slot, value);
}

static __attribute__((noinline)) u32 thunk_inner(slot_stage_fn* table, u32 index, u32* slot) {
    const u32 first = dispatch_stage(table[index], slot, 0x100u);
    const u32 second = dispatch_stage(table[index ^ 1u], slot, 0x7FFu);
    TEST_ASSERT(second - first == 0x7FFu);
    return second;
}

static __attribute__((noinline)) u32 thunk_outer(slot_stage_fn* table, u32* slot) {
    const u32 sys_ret = do_write();
    TEST_ASSERT(sys_ret == 1u);
    return thunk_inner(table, sys_ret & 1u, slot);
}

static __attribute__((noinline)) void build_nodes(u32 header_base, u32 payload_base, u32 slot_value) {
    volatile struct RootNode* root = (volatile struct RootNode*)(unsigned long)header_base;
    volatile struct ChildNode* child = (volatile struct ChildNode*)(unsigned long)(header_base + 0x013Cu);

    root->tag = 0x00EAA44Cu;
    root->self = header_base;
    root->payload = payload_base;
    root->child = header_base + 0x013Cu;
    root->slot_value = slot_value;

    child->kind = 0x31u;
    child->parent = header_base;
    child->payload = payload_base;
    child->stamp = slot_value ^ 0x00FF00FFu;
}

int test_main(void) {
    static slot_stage_fn table[] = {add_0x100, add_0x7ff};

    const u32 arena_base = (u32)(unsigned long)arena;
    u32 slot = arena_base + 0x0F800u;
    const u32 produced = thunk_outer(table, &slot);
    const u32 payload_base = (produced + 0xFFFu) & ~0xFFFu;
    const u32 header_base = payload_base - 0x10000u;

    TEST_ASSERT(produced == arena_base + 0x100FFu);
    TEST_ASSERT(payload_base == arena_base + 0x11000u);
    TEST_ASSERT(header_base == arena_base + 0x1000u);
    TEST_ASSERT(payload_base - header_base == 0x10000u);

    build_nodes(header_base, payload_base, produced);

    volatile struct RootNode* root = (volatile struct RootNode*)(unsigned long)header_base;
    volatile struct ChildNode* child = (volatile struct ChildNode*)(unsigned long)(header_base + 0x013Cu);

    TEST_ASSERT(root->tag == 0x00EAA44Cu);
    TEST_ASSERT(root->self == header_base);
    TEST_ASSERT(root->payload == payload_base);
    TEST_ASSERT(root->child == header_base + 0x013Cu);
    TEST_ASSERT(root->slot_value == produced);

    TEST_ASSERT(child->kind == 0x31u);
    TEST_ASSERT(child->parent == header_base);
    TEST_ASSERT(child->payload == payload_base);
    TEST_ASSERT(child->stamp == (produced ^ 0x00FF00FFu));

    test_pass();
    return 0;
}
