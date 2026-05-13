cmake_minimum_required(VERSION 3.22)
project(dynarmic_bintest)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 20)

# Find dynarmic
set(DYNARMIC_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/..")
include_directories(${DYNARMIC_ROOT}/src)
include_directories(${DYNARMIC_ROOT}/externals/mcl/include)

# Include directories
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

# Runner executable
add_executable(dynarmic_bintest_runner
    runner/bintest_runner.cpp
)

target_link_libraries(dynarmic_bintest_runner
    dynarmic
)

# Test sources (for reference, actual compilation uses aarch64-none-elf-gcc)
# These are not built by CMake, but listed here for IDE support

# Group 1: Basic tests
set(GROUP1_TESTS
    tests/group1_basic/01_integer_arith.c
    tests/group1_basic/02_integer_logic.c
    tests/group1_basic/03_integer_shift.c
    tests/group1_basic/04_integer_compare.c
    tests/group1_basic/05_integer_assign.c
    tests/group1_basic/06_integer_cast.c
    tests/group1_basic/07_float_arith.c
    tests/group1_basic/08_float_compare.c
    tests/group1_basic/09_float_cast.c
    tests/group1_basic/10_pointer_basics.c
)

# Group 2: Instructions and function calls
set(GROUP2_TESTS
    tests/group2_instructions/01_simple_call.c
    tests/group2_instructions/02_nested_call.c
    tests/group2_instructions/03_recursive_call.c
    tests/group2_instructions/04_many_args.c
    tests/group2_instructions/05_varargs.c
    tests/group2_instructions/06_struct_arg.c
    tests/group2_instructions/07_array_arg.c
    tests/group2_instructions/08_return_struct.c
    tests/group2_instructions/09_return_array.c
    tests/group2_instructions/10_callee_saved.c
    tests/group2_instructions/11_tail_call.c
    tests/group2_instructions/12_indirect_call.c
    tests/group2_instructions/13_callback.c
    tests/group2_instructions/14_function_ptr.c
    tests/group2_instructions/15_deep_recursion.c
)

# Group 3: Complex calculation and jumps
set(GROUP3_TESTS
    tests/group3_complex/01_nested_loops.c
    tests/group3_complex/02_conditional_nested.c
    tests/group3_complex/03_switch_case.c
    tests/group3_complex/04_goto_jump.c
    tests/group3_complex/05_computed_goto.c
    tests/group3_complex/06_setjmp_longjmp.c
    tests/group3_complex/07_fibonacci.c
    tests/group3_complex/08_factorial.c
    tests/group3_complex/09_gcd.c
    tests/group3_complex/10_prime_check.c
    tests/group3_complex/11_sorting.c
    tests/group3_complex/12_searching.c
    tests/group3_complex/13_matrix_mult.c
    tests/group3_complex/14_string_ops.c
    tests/group3_complex/15_bit_operations.c
)

# Group 4: Vector instructions
set(GROUP4_TESTS
    tests/group4_vector/01_vector_load.c
    tests/group4_vector/02_vector_store.c
    tests/group4_vector/03_vector_arith.c
    tests/group4_vector/04_vector_logic.c
    tests/group4_vector/05_vector_compare.c
    tests/group4_vector/06_vector_shift.c
    tests/group4_vector/07_vector_mul.c
    tests/group4_vector/08_vector_reduce.c
    tests/group4_vector/09_vector_gather.c
    tests/group4_vector/10_vector_scatter.c
    tests/group4_vector/11_vector_transpose.c
    tests/group4_vector/12_vector_interleave.c
    tests/group4_vector/13_vector_table.c
    tests/group4_vector/14_vector_cvt.c
    tests/group4_vector/15_vector_matrix.c
)

# Group 5: High complexity mixed
set(GROUP5_TESTS
    tests/group5_mixed/01_fft.c
    tests/group5_mixed/02_matrix_decomp.c
    tests/group5_mixed/03_polynomial.c
    tests/group5_mixed/04_interpolation.c
    tests/group5_mixed/05_convolution.c
    tests/group5_mixed/06_correlation.c
    tests/group5_mixed/07_dsp_filter.c
    tests/group5_mixed/08_image_process.c
    tests/group5_mixed/09_compression.c
    tests/group5_mixed/10_encryption.c
    tests/group5_mixed/11_neural_network.c
    tests/group5_mixed/12_physics_sim.c
    tests/group5_mixed/13_audio_process.c
    tests/group5_mixed/14_graphics_render.c
    tests/group5_mixed/15_game_logic.c
)

# Custom target to build tests with aarch64-none-elf-gcc
add_custom_target(build_tests
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/scripts/build_tests.sh
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Building tests with aarch64-none-elf-gcc"
)

# Custom target to run tests
add_custom_target(run_tests
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/scripts/run_tests.sh
    DEPENDS dynarmic_bintest_runner build_tests
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Running binary tests"
)

add_custom_target(build_tests_a32
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/scripts/build_tests_a32.sh
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Building A32 tests with arm-none-eabi-gcc"
)

add_custom_target(verify_tests_a32_qemu
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/scripts/verify_tests_a32_qemu.sh
    DEPENDS build_tests_a32
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Verifying A32 binary tests with qemu-arm"
)

add_custom_target(run_tests_a32
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/scripts/run_tests_a32.sh
    DEPENDS dynarmic_bintest_runner_a32 build_tests_a32
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Running A32 binary tests"
)
