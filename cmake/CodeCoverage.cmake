# SPDX-License-Identifier: MIT
# Copyright (c) 2023 AlgorIT Software Consultancy, the Netherlands

#[============================================================================[

Adds a custom build configuration type named Coverage for instrumenting
the project for gcov based coverage reporting.

If built with Clang then GNU gcov will not work with the generated .gcda and
.gcno files. There are two ways to solve this:

    - Create a symbolic link named gcov for llvm-cov that will be found
      via ${PATH} before GNU gcov.

      Rationale: if llvm-cov is invoked with a base name of gcov, it will
      behave as if the llvm-cov gcov command were called.

    - Invoke lcov with arguments: --gcov-tool <shell-script>

      <shell-script> must be found (via ${PATH} or an absolute path) and have
      content similar to:

      #!/bin/sh
      /usr/bin/llvm-cov gcov "$@"

#]============================================================================]

include(CustomConfigurationType)

add_custom_configuration_type(
    Coverage
    POSTFIX   _cov
    BASED_ON  Debug
    C_FLAGS   -O0 --coverage
    CXX_FLAGS -O0 --coverage
    EXE_LINKER_FLAGS    --coverage
    SHARED_LINKER_FLAGS --coverage)
