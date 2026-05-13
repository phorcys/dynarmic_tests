// A32 infra reproducer:
// switch/jump-table path selection + real syscall + nested call chain -> page align -> header/child chain.
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

static unsigned char arena[0x50000] __attribute__((aligned(4096)));
static const char marker[] = "J";

static __attribute__((noinline)) u32 add_0x200(u32* slot) {
    *slot += 0x200u;
    return *slot;
}

static __attribute__((noinline)) u32 add_0x5FE(u32* slot) {
    *slot += 0x5FEu;
    return *slot;
}

static __attribute__((noinline)) u32 issue_write(void) {
    return (u32)sys_write(STDOUT, marker, 1);
}

static __attribute__((noinline)) u32 select_and_apply(u32 which, u32* slot) {
    switch (which) {
    case 0:
        return add_0x200(slot);
    case 1:
        return add_0x5FE(slot);
    default:
        return *slot;
    }
}

static __attribute__((noinline)) u32 thunk_b(u32 which, u32* slot) {
    return select_and_apply(which, slot);
}

static __attribute__((noinline)) u32 thunk_a(u32* slot) {
    const u32 sys_ret = issue_write();
    const u32 first = thunk_b(0, slot);
    const u32 second = thunk_b(sys_ret, slot);
    TEST_ASSERT(sys_ret == 1u);
    TEST_ASSERT(second - first == 0x5FEu);
    return second;
}

static __attribute__((noinline)) void build_nodes(u32 header_base, u32 payload_base, u32 slot_value) {
    volatile struct RootNode* root = (volatile struct RootNode*)(unsigned long)header_base;
    volatile struct ChildNode* child = (volatile struct ChildNode*)(unsigned long)(header_base + 0x013Cu);

    root->tag = 0x00EAA44Cu;
    root->self = header_base;
    root->payload = payload_base;
    root->child = header_base + 0x013Cu;
    root->slot_value = slot_value;

    child->kind = 0x51u;
    child->parent = header_base;
    child->payload = payload_base;
    child->stamp = slot_value ^ 0x00FF00FFu;
}

int test_main(void) {
    const u32 arena_base = (u32)(unsigned long)arena;
    u32 slot = arena_base + 0x0F801u;
    const u32 produced = thunk_a(&slot);
    const u32 payload_base = (produced + 0xFFFu) & ~0xFFFu;
    const u32 header_base = payload_base - 0x10000u;

    TEST_ASSERT(produced == arena_base + 0x0FFFFu);
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

    TEST_ASSERT(child->kind == 0x51u);
    TEST_ASSERT(child->parent == header_base);
    TEST_ASSERT(child->payload == payload_base);
    TEST_ASSERT(child->stamp == (produced ^ 0x00FF00FFu));

    test_pass();
    return 0;
}
