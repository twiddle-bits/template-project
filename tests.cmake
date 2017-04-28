# CMakeLists.txt

# tests

set(test_dir ${PROJECT_SOURCE_DIR}/tests)

file(GLOB src_files ${test_dir}/*.c ${test_dir}/*.cpp)

msg("Got test src: ${src_files}")

add_executable(tests ${src_files})

target_include_directories(
  tests
  PRIVATE ${PROJECT_SOURCE_DIR}/export)

target_link_libraries(tests <PKG>)

add_custom_command(
  TARGET tests
  POST_BUILD
  COMMAND $<TARGET_FILE:tests>)
