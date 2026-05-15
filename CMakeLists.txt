cmake_minimum_required(VERSION 3.22)

project(dynarmic_tests LANGUAGES C CXX)

include(CTest)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

option(DYNARMIC_TESTS_ENABLE_RUNNERS "Build Dynarmic binary test runners" ON)
option(DYNARMIC_TESTS_ENABLE_A64_BINTEST "Register A64 bintest CTest entry" ON)
option(DYNARMIC_TESTS_ENABLE_A32_BINTEST "Register A32 bintest CTest entry" ON)
option(DYNARMIC_TESTS_ENABLE_SIMDE_BINTEST "Register SIMDe bintest CTest entry" ON)
option(DYNARMIC_TESTS_ENABLE_A64_ASM "Register A64 asm CTest entry" ON)
option(DYNARMIC_TESTS_ENABLE_A32_ASM "Register A32 asm CTest entry" ON)
option(DYNARMIC_TESTS_ENABLE_FASTMEM_FAULT "Build and register protected-page fastmem fault test" ON)
option(DYNARMIC_TESTS_USE_EDEN_CPM "Use Eden's CPM dependency declarations when building against an Eden checkout" ON)

set(DYNARMIC_TESTS_EDEN_ROOT "" CACHE PATH "Path to an Eden checkout containing src/dynarmic")
set(DYNARMIC_TESTS_DYNARMIC_ROOT "" CACHE PATH "Path to a standalone Dynarmic checkout")
set(DYNARMIC_TESTS_GENERATED_DIR "${CMAKE_BINARY_DIR}/generated" CACHE PATH "Generated ELF output directory")
set(DYNARMIC_TESTS_SIMDE_ROOT "" CACHE PATH "Path to a SIMDe checkout")
set(DYNARMIC_TESTS_BOOST_INCLUDE_DIR "" CACHE PATH "Path containing the boost/ include directory")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(DynarmicTestsDynarmic)

dynarmic_tests_detect_host_backend()
dynarmic_tests_import_dynarmic()

if (DYNARMIC_TESTS_ENABLE_RUNNERS AND DYNARMIC_TESTS_HOST_BACKEND_AVAILABLE)
    add_executable(dynarmic_bintest_a64
        runners/a64_bintest_runner.cpp
    )
    target_link_libraries(dynarmic_bintest_a64 PRIVATE dynarmic)

    add_executable(dynarmic_bintest_a32
        runners/a32_bintest_runner.cpp
    )
    target_link_libraries(dynarmic_bintest_a32 PRIVATE dynarmic)

    add_executable(dynarmic_asmtest_a64
        runners/asm/a64_asmtest.cpp
    )
    target_link_libraries(dynarmic_asmtest_a64 PRIVATE dynarmic fmt::fmt)

    add_executable(dynarmic_asmtest_a32
        runners/asm/a32_asmtest.cpp
    )
    target_link_libraries(dynarmic_asmtest_a32 PRIVATE dynarmic fmt::fmt)

    if (UNIX AND DYNARMIC_TESTS_ENABLE_FASTMEM_FAULT)
        add_executable(dynarmic_fastmem_fault
            runners/fastmem_fault.cpp
        )
        target_link_libraries(dynarmic_fastmem_fault PRIVATE dynarmic)
    endif()

    if (DYNARMIC_TESTS_BOOST_INCLUDE_DIR)
        foreach (target dynarmic_bintest_a64 dynarmic_bintest_a32 dynarmic_asmtest_a64 dynarmic_asmtest_a32)
            target_include_directories(${target} PRIVATE "${DYNARMIC_TESTS_BOOST_INCLUDE_DIR}")
        endforeach()
    endif()
elseif (DYNARMIC_TESTS_ENABLE_RUNNERS)
    message(STATUS "Dynarmic runners disabled: host backend '${DYNARMIC_TESTS_HOST_ARCH}' is not available in this Dynarmic checkout")
endif()

find_program(DYNARMIC_TESTS_AARCH64_CC aarch64-none-elf-gcc)
find_program(DYNARMIC_TESTS_ARM_CC arm-none-eabi-gcc)
find_package(Python3 COMPONENTS Interpreter)

set(DYNARMIC_TESTS_DRIVER "${CMAKE_CURRENT_SOURCE_DIR}/scripts/dynarmic-tests")

if (DYNARMIC_TESTS_AARCH64_CC)
    add_custom_target(dynarmic_tests_build_a64_bintest
        COMMAND "${DYNARMIC_TESTS_DRIVER}" build-a64
                --out "${DYNARMIC_TESTS_GENERATED_DIR}/a64"
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        COMMENT "Building A64 binary tests"
        VERBATIM
    )
else()
    message(STATUS "aarch64-none-elf-gcc not found; A64 bintest build target will be unavailable")
endif()

if (DYNARMIC_TESTS_ARM_CC)
    add_custom_target(dynarmic_tests_build_a32_bintest
        COMMAND "${DYNARMIC_TESTS_DRIVER}" build-a32
                --out "${DYNARMIC_TESTS_GENERATED_DIR}/a32"
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        COMMENT "Building A32 binary tests"
        VERBATIM
    )
else()
    message(STATUS "arm-none-eabi-gcc not found; A32 bintest build target will be unavailable")
endif()

if (DYNARMIC_TESTS_AARCH64_CC AND DYNARMIC_TESTS_SIMDE_ROOT)
    add_custom_target(dynarmic_tests_build_simde_bintest
        COMMAND "${DYNARMIC_TESTS_DRIVER}" build-simde
                --simde "${DYNARMIC_TESTS_SIMDE_ROOT}"
                --out "${DYNARMIC_TESTS_GENERATED_DIR}/simde"
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        COMMENT "Building SIMDe A64 binary tests"
        VERBATIM
    )
endif()

find_program(DYNARMIC_TESTS_QEMU_AARCH64 qemu-aarch64)
find_program(DYNARMIC_TESTS_QEMU_ARM qemu-arm)

if (DYNARMIC_TESTS_QEMU_AARCH64)
    add_custom_target(dynarmic_tests_oracle_a64_bintest
        COMMAND "${DYNARMIC_TESTS_DRIVER}" oracle-a64-bintest
                --tests "${DYNARMIC_TESTS_GENERATED_DIR}/a64"
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        COMMENT "Verifying A64 binary tests with qemu-aarch64"
        VERBATIM
    )

    add_custom_target(dynarmic_tests_oracle_simde_bintest
        COMMAND "${DYNARMIC_TESTS_DRIVER}" oracle-simde-bintest
                --tests "${DYNARMIC_TESTS_GENERATED_DIR}/simde"
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        COMMENT "Verifying SIMDe binary tests with qemu-aarch64"
        VERBATIM
    )

    if (Python3_Interpreter_FOUND)
        add_custom_target(dynarmic_tests_oracle_a64_asm
            COMMAND "${DYNARMIC_TESTS_DRIVER}" oracle-a64-asm
                    --tests "${CMAKE_CURRENT_SOURCE_DIR}/asm/a64"
            WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
            COMMENT "Verifying A64 asm tests with qemu-aarch64"
            VERBATIM
        )
    endif()
endif()

if (DYNARMIC_TESTS_QEMU_ARM)
    add_custom_target(dynarmic_tests_oracle_a32_bintest
        COMMAND "${DYNARMIC_TESTS_DRIVER}" oracle-a32-bintest
                --tests "${DYNARMIC_TESTS_GENERATED_DIR}/a32"
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        COMMENT "Verifying A32 binary tests with qemu-arm"
        VERBATIM
    )

    if (Python3_Interpreter_FOUND)
        add_custom_target(dynarmic_tests_oracle_a32_asm
            COMMAND "${DYNARMIC_TESTS_DRIVER}" oracle-a32-asm
                    --tests "${CMAKE_CURRENT_SOURCE_DIR}/asm/a32"
            WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
            COMMENT "Verifying A32 asm tests with qemu-arm"
            VERBATIM
        )
    endif()
endif()

if (BUILD_TESTING AND DYNARMIC_TESTS_ENABLE_RUNNERS AND DYNARMIC_TESTS_HOST_BACKEND_AVAILABLE)
    if (DYNARMIC_TESTS_ENABLE_A64_BINTEST)
        add_test(NAME dynarmic_tests_a64_bintest
            COMMAND dynarmic_bintest_a64 "${DYNARMIC_TESTS_GENERATED_DIR}/a64"
        )
        set_tests_properties(dynarmic_tests_a64_bintest PROPERTIES
            LABELS "dynarmic;a64;bintest"
        )
    endif()

    if (DYNARMIC_TESTS_ENABLE_A32_BINTEST)
        add_test(NAME dynarmic_tests_a32_bintest
            COMMAND dynarmic_bintest_a32 "${DYNARMIC_TESTS_GENERATED_DIR}/a32"
        )
        set_tests_properties(dynarmic_tests_a32_bintest PROPERTIES
            LABELS "dynarmic;a32;bintest"
        )
    endif()

    if (DYNARMIC_TESTS_ENABLE_SIMDE_BINTEST)
        add_test(NAME dynarmic_tests_simde_bintest
            COMMAND dynarmic_bintest_a64 "${DYNARMIC_TESTS_GENERATED_DIR}/simde"
        )
        set_tests_properties(dynarmic_tests_simde_bintest PROPERTIES
            LABELS "dynarmic;a64;bintest;simde"
        )
    endif()

    if (Python3_Interpreter_FOUND AND DYNARMIC_TESTS_ENABLE_A64_ASM)
        add_test(NAME dynarmic_tests_a64_asm
            COMMAND "${DYNARMIC_TESTS_DRIVER}" run-a64-asm
                    --runner "$<TARGET_FILE:dynarmic_asmtest_a64>"
                    --tests "${CMAKE_CURRENT_SOURCE_DIR}/asm/a64"
        )
        set_tests_properties(dynarmic_tests_a64_asm PROPERTIES
            LABELS "dynarmic;a64;asm"
        )
    endif()

    if (Python3_Interpreter_FOUND AND DYNARMIC_TESTS_ENABLE_A32_ASM)
        add_test(NAME dynarmic_tests_a32_asm
            COMMAND "${DYNARMIC_TESTS_DRIVER}" run-a32-asm
                    --runner "$<TARGET_FILE:dynarmic_asmtest_a32>"
                    --tests "${CMAKE_CURRENT_SOURCE_DIR}/asm/a32"
        )
        set_tests_properties(dynarmic_tests_a32_asm PROPERTIES
            LABELS "dynarmic;a32;asm"
        )
    endif()

    if (TARGET dynarmic_fastmem_fault)
        add_test(NAME dynarmic_tests_fastmem_fault
            COMMAND dynarmic_fastmem_fault
        )
        set_tests_properties(dynarmic_tests_fastmem_fault PROPERTIES
            LABELS "dynarmic;a64;fastmem"
        )
    endif()
endif()
