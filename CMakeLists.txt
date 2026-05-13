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
    if (DYNARMIC_TESTS_BOOST_INCLUDE_DIR)
        target_include_directories(dynarmic_bintest_a64 PRIVATE "${DYNARMIC_TESTS_BOOST_INCLUDE_DIR}")
    endif()

    add_executable(dynarmic_bintest_a32
        runners/a32_bintest_runner.cpp
    )
    target_link_libraries(dynarmic_bintest_a32 PRIVATE dynarmic)
    if (DYNARMIC_TESTS_BOOST_INCLUDE_DIR)
        target_include_directories(dynarmic_bintest_a32 PRIVATE "${DYNARMIC_TESTS_BOOST_INCLUDE_DIR}")
    endif()
elseif (DYNARMIC_TESTS_ENABLE_RUNNERS)
    message(STATUS "Dynarmic runners disabled: host backend '${DYNARMIC_TESTS_HOST_ARCH}' is not available in this Dynarmic checkout")
endif()

find_program(DYNARMIC_TESTS_AARCH64_CC aarch64-none-elf-gcc)
find_program(DYNARMIC_TESTS_ARM_CC arm-none-eabi-gcc)

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
endif()
