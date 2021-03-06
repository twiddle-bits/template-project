# CMakeLists.txt

cmake_minimum_required(VERSION 3.0)

project(<PKG>)

set(ver_maj 0)
set(ver_min 1)
set(ver_patch 0)
set(ver_string ${ver_maj}.${ver_min}.${ver_patch})

macro(msg m)
  message("[<PKG>] ${m}")
endmacro(msg)

set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)

set(PROJECT_VERSION ${ver_string})

if (UNIX)
  if(APPLE)
    set(CMAKE_INSTALL_NAME_DIR "@rpath/")
  else()
    set(CMAKE_INSTALL_RPATH "\$ORIGIN/../lib")
  endif()
endif(UNIX)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

include(3rdparty.cmake)

msg("Got project source dir: ${PROJECT_SOURCE_DIR}")

file(GLOB_RECURSE export_hdr ${PROJECT_SOURCE_DIR}/export/*.h ${PROJECT_SOURCE_DIR}/export/*.hpp)

file(GLOB_RECURSE src_files ${PROJECT_SOURCE_DIR}/src/*.c ${PROJECT_SOURCE_DIR}/src/*.cpp)

msg("Got export hdrs: ${export_hdr}")
msg("Got src files: ${src_files}")

add_library(<PKG> ${src_files})

if (BUILD_SHARED_LIBS)
  set(build_flag BUILDING_<PKGUPPER>)
else()
  set(build_flag )
endif()

target_compile_definitions(
  <PKG>
  PRIVATE
    ${build_flag}
    <PKGUPPER>_VER_MAJ=${ver_maj}
    <PKGUPPER>_VER_MIN=${ver_min}
    <PKGUPPER>_VER_PATCH=${ver_patch}
    <PKGUPPER>_VER_STRING=${ver_string})

target_include_directories(
  <PKG>
  PRIVATE include
  PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/export>
         $<INSTALL_INTERFACE:include>)

target_link_libraries(<PKG> )

target_compile_features(
  <PKG>
  PUBLIC
  cxx_nullptr
  cxx_lambdas
  cxx_auto_type
  cxx_static_assert)

configure_file(
  cmake/<PKG>Config.cmake.in
  ${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/<PKG>Config.cmake @ONLY)

# INSTALL

export(
  TARGETS <PKG>
  FILE ${PROJECT_BINARY_DIR}/<PKG>Targets.cmake)

export(PACKAGE <PKG>)

# install configs

install(
  TARGETS <PKG>
  EXPORT <PKG>Targets
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin
  INCLUDES DESTINATION include)

install(
  DIRECTORY export/
  DESTINATION include)

set(cmake_config_dir lib/cmake/<PKG>)

install(
  FILES ${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/<PKG>Config.cmake
  DESTINATION ${cmake_config_dir}
  COMPONENT dev)

install(
  EXPORT <PKG>Targets
  DESTINATION ${cmake_config_dir}
  COMPONENT dev)

install(
  FILES ${PROJECT_SOURCE_DIR}/LICENSE
  DESTINATION share/<PKG>)

# TESTS

include(tests.cmake)

# Packaging

set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_CURRENT_SOURCE_DIR}/LICENSE)
set(CPACK_PACKAGE_VENDOR "twiddle-bits")
set(CPACK_PACKAGE_CONTACT "twiddlebits.ak@gmail.com")
set(CPACK_STRIP_FILES 1)
include(CPack)
