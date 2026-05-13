// A32 infra reproducer:
// high register-pressure locals + function-pointer chain + real syscall + header/child/grandchild graph init.
#include "test_syscall.h"

typedef unsigned int u32;

struct RootNode {
    u32 tag;
    u32 self;
    u32 payload;
    u32 child;
    u32 grandchild;
    u32 slot_value;
};

struct ChildNode {
    u32 kind;
    u32 parent;
    u32 payload;
    u32 next;
    u32 stamp;
};

struct GrandChildNode {
    u32 kind;
    u32 parent;
    u32 payload;
    u32 stamp;
};

typedef u32 (*stage_fn)(u32* slot, u32 value);

static unsigned char arena[0x60000] __attribute__((aligned(4096)));
static const char marker[] = "R";

static __attribute__((noinline)) u32 stage_add_a(u32* slot, u32 value) {
    *slot += value;
    return *slot;
}

static __attribute__((noinline)) u32 stage_add_b(u32* slot, u32 value) {
    *slot += value;
    return *slot;
}

static __attribute__((noinline)) u32 stage_add_c(u32* slot, u32 value) {
    *slot += value;
    return *slot;
}

static __attribute__((noinline)) u32 do_write(void) {
    return (u32)sys_write(STDOUT, marker, 1);
}

static __attribute__((noinline)) u32 call_stage(stage_fn fn, u32* slot, u32 value) {
    return fn(slot, value);
}

static __attribute__((noinline)) u32 nested_dispatch(stage_fn* table, u32* slot) {
    volatile u32 live0 = 0x11111111u;
    volatile u32 live1 = 0x22222222u;
    volatile u32 live2 = 0x33333333u;
    volatile u32 live3 = 0x44444444u;
    volatile u32 live4 = 0x55555555u;
    volatile u32 live5 = 0x66666666u;
    volatile u32 live6 = 0x77777777u;
    volatile u32 live7 = 0x88888888u;

    const u32 w = do_write();
    const u32 a = call_stage(table[0], slot, 0x100u);
    const u32 b = call_stage(table[w], slot, 0x500u);
    const u32 c = call_stage(table[2], slot, 0x2FEu);

    TEST_ASSERT(w == 1u);
    TEST_ASSERT(b - a == 0x500u);
    TEST_ASSERT(c - b == 0x2FEu);
    TEST_ASSERT((live0 ^ live1 ^ live2 ^ live3 ^ live4 ^ live5 ^ live6 ^ live7) == 0x88888888u);
    return c;
}

static __attribute__((noinline)) void build_graph(u32 header_base, u32 payload_base, u32 slot_value) {
    volatile struct RootNode* root = (volatile struct RootNode*)(unsigned long)header_base;
    volatile struct ChildNode* child = (volatile struct ChildNode*)(unsigned long)(header_base + 0x013Cu);
    volatile struct GrandChildNode* grandchild = (volatile struct GrandChildNode*)(unsigned long)(header_base + 0x01B8u);

    root->tag = 0x00EAA44Cu;
    root->self = header_base;
    root->payload = payload_base;
    root->child = header_base + 0x013Cu;
    root->grandchild = header_base + 0x01B8u;
    root->slot_value = slot_value;

    child->kind = 0x61u;
    child->parent = header_base;
    child->payload = payload_base;
    child->next = header_base + 0x01B8u;
    child->stamp = slot_value ^ 0x00FF00FFu;

    grandchild->kind = 0x71u;
    grandchild->parent = header_base;
    grandchild->payload = payload_base;
    grandchild->stamp = slot_value ^ 0x0F0F0F0Fu;
}

int test_main(void) {
    static stage_fn table[] = {stage_add_a, stage_add_b, stage_add_c};

    const u32 arena_base = (u32)(unsigned long)arena;
    u32 slot = arena_base + 0x0F801u;
    const u32 produced = nested_dispatch(table, &slot);
    const u32 payload_base = (produced + 0xFFFu) & ~0xFFFu;
    const u32 header_base = payload_base - 0x10000u;

    TEST_ASSERT(produced == arena_base + 0x100FFu);
    TEST_ASSERT(payload_base == arena_base + 0x11000u);
    TEST_ASSERT(header_base == arena_base + 0x1000u);
    TEST_ASSERT(payload_base - header_base == 0x10000u);

    build_graph(header_base, payload_base, produced);

    volatile struct RootNode* root = (volatile struct RootNode*)(unsigned long)header_base;
    volatile struct ChildNode* child = (volatile struct ChildNode*)(unsigned long)(header_base + 0x013Cu);
    volatile struct GrandChildNode* grandchild = (volatile struct GrandChildNode*)(unsigned long)(header_base + 0x01B8u);

    TEST_ASSERT(root->tag == 0x00EAA44Cu);
    TEST_ASSERT(root->self == header_base);
    TEST_ASSERT(root->payload == payload_base);
    TEST_ASSERT(root->child == header_base + 0x013Cu);
    TEST_ASSERT(root->grandchild == header_base + 0x01B8u);
    TEST_ASSERT(root->slot_value == produced);

    TEST_ASSERT(child->kind == 0x61u);
    TEST_ASSERT(child->parent == header_base);
    TEST_ASSERT(child->payload == payload_base);
    TEST_ASSERT(child->next == header_base + 0x01B8u);
    TEST_ASSERT(child->stamp == (produced ^ 0x00FF00FFu));

    TEST_ASSERT(grandchild->kind == 0x71u);
    TEST_ASSERT(grandchild->parent == header_base);
    TEST_ASSERT(grandchild->payload == payload_base);
    TEST_ASSERT(grandchild->stamp == (produced ^ 0x0F0F0F0Fu));

    test_pass();
    return 0;
}
