cmake_minimum_required(VERSION 3.20.0)

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(zephyr_moddable_xs)

set(APP_XS_GENERATED_DIR "" CACHE PATH "Generated XS C source directory")
set(TI_SIMPLELINK_SDK_DIR "" CACHE PATH "Path to TI SimpleLink SDK root")
set(TI_DRIVER_LIBRARIES "" CACHE STRING "Semicolon-separated TI driver libraries for the active board/toolchain")

if(APP_XS_GENERATED_DIR STREQUAL "")
    get_filename_component(APP_BUILD_PARENT_DIR "${CMAKE_BINARY_DIR}" DIRECTORY)
    set(APP_XS_GENERATED_DIR "${APP_BUILD_PARENT_DIR}/xs")
endif()

file(GLOB APP_SOURCES CONFIGURE_DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.c
    ${CMAKE_CURRENT_SOURCE_DIR}/drivers/*.c
)

target_sources(app PRIVATE ${APP_SOURCES})

target_include_directories(app PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/drivers
)

if(EXISTS "${APP_XS_GENERATED_DIR}")
    file(GLOB XS_GENERATED_SOURCES CONFIGURE_DEPENDS "${APP_XS_GENERATED_DIR}/*.c")
    if(XS_GENERATED_SOURCES)
        target_sources(app PRIVATE ${XS_GENERATED_SOURCES})
    endif()
endif()

if(NOT TI_SIMPLELINK_SDK_DIR STREQUAL "")
    target_include_directories(app PRIVATE ${TI_SIMPLELINK_SDK_DIR}/source)
endif()

if(NOT TI_DRIVER_LIBRARIES STREQUAL "")
    target_link_libraries(app PRIVATE ${TI_DRIVER_LIBRARIES})
endif()
