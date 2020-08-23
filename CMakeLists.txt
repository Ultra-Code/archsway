cmake_minimum_required(VERSION 3.15)

project(
  constexpr
  VERSION 0.1
  DESCRIPTION "Trying Out Cmake Manually from the command lin"
  LANGUAGES CXX)

add_executable(constexpr constexpr.cpp)

set_target_properties(
  constexpr
  PROPERTIES
    CXX_STANDARD 20
    CXX_STANDARD_REQUIRED ON
    COMPILE_FLAGS
    "-Wall -Weverything -Wno-c++98-compat -Wno-c++98-compat-pedantic -Wno-unused-macros -Wno-newline-eof -Wno-exit-time-destructors -Wno-global-constructors -Wno-gnu-zero-variadic-macro-arguments -Wno-documentation -Wno-switch-enum -Wno-used-but-marked-unused -Wno-float-equal -Wno-missing-prototypes -ftrapv"
)
