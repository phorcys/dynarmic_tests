// A32 infra reproducer:
// stack-slot producer -> callback/thunk chain -> align -> header/payload object init.
#include "test_syscall.h"

typedef unsigned char u8;
typedef unsigned int u32;

struct StackHeader {
    u32 tag;
    u32 header_base;
    u32 payload_base;
    u32 next;
    u32 slot_value;
};

typedef u32 (*slot_stage)(u32* slot, u32 value);
typedef u32 (*value_stage)(u32 value);

static u8 arena[0x50000] __attribute__((aligned(4096)));

static __attribute__((noinline)) u32 stage_add(u32* slot, u32 value) {
    *slot += value;
    return *slot;
}

static __attribute__((noinline)) u32 stage_read(const u32* slot) {
    return *slot;
}

static __attribute__((noinline)) u32 stage_align_payload(u32 value) {
    return (value + 0xFFFu) & ~0xFFFu;
}

static __attribute__((noinline)) u32 stage_header_from_payload(u32 payload_base) {
    return payload_base - 0x10000u;
}

static __attribute__((noinline)) u32 thunk_stage(slot_stage op, u32* slot, u32 value) {
    return op(slot, value);
}

static __attribute__((noinline)) u32 thunk_chain(slot_stage op0, slot_stage op1, const u32* slot_in) {
    u32 local_slot = *slot_in;
    const u32 first = thunk_stage(op0, &local_slot, 0x200u);
    const u32 second = thunk_stage(op1, &local_slot, 0x188u);
    TEST_ASSERT(first == ((u32)(unsigned long)arena + 0x0FE77u));
    return second;
}

static __attribute__((noinline)) void build_header(u32 header_base, u32 payload_base, u32 slot_value) {
    volatile struct StackHeader* header = (volatile struct StackHeader*)(unsigned long)header_base;
    volatile u8* payload = (volatile u8*)(unsigned long)payload_base;

    header->tag = 0x00EAA44Cu;
    header->header_base = header_base;
    header->payload_base = payload_base;
    header->next = header_base + 0x013Cu;
    header->slot_value = slot_value;

    for (u32 i = 0; i < 0x20; i++) {
        payload[i] = (u8)(0x40u + ((slot_value >> (i & 7)) & 0x0Fu));
    }
}

int test_main(void) {
    static slot_stage slot_ops[] = {stage_add, stage_add};
    static value_stage value_ops[] = {stage_align_payload, stage_header_from_payload};
    const u32 arena_base = (u32)(unsigned long)arena;
    const u32 seed = arena_base + 0x0FC77u;
    const u32 produced = thunk_chain(slot_ops[0], slot_ops[1], &seed);
    const u32 observed = stage_read(&produced);
    const u32 payload_base = value_ops[0](observed);
    const u32 header_base = value_ops[1](payload_base);

    TEST_ASSERT(produced == arena_base + 0x0FFFFu);
    TEST_ASSERT(observed == produced);
    TEST_ASSERT(payload_base == arena_base + 0x10000u);
    TEST_ASSERT(header_base == arena_base);
    TEST_ASSERT(payload_base - header_base == 0x10000u);

    build_header(header_base, payload_base, observed);

    volatile struct StackHeader* header = (volatile struct StackHeader*)(unsigned long)header_base;
    volatile u8* payload = (volatile u8*)(unsigned long)payload_base;

    TEST_ASSERT(header->tag == 0x00EAA44Cu);
    TEST_ASSERT(header->header_base == header_base);
    TEST_ASSERT(header->payload_base == payload_base);
    TEST_ASSERT(header->next == header_base + 0x013Cu);
    TEST_ASSERT(header->slot_value == observed);
    TEST_ASSERT(payload[0] == (u8)(0x40u + ((observed >> 0) & 0x0Fu)));
    TEST_ASSERT(payload[7] == (u8)(0x40u + ((observed >> 7) & 0x0Fu)));

    test_pass();
    return 0;
}
