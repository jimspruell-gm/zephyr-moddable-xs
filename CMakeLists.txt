cmake_minimum_required(VERSION 3.20.0)

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(zephyr_moddable_xs)

set(APP_XS_GENERATED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/build/xs" CACHE PATH "Generated XS C source directory")
set(TI_SIMPLELINK_SDK_DIR "" CACHE PATH "Path to TI SimpleLink SDK root")

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

if(TI_SIMPLELINK_SDK_DIR)
    target_include_directories(app PRIVATE ${TI_SIMPLELINK_SDK_DIR}/source)

    file(GLOB TI_DRIVER_LIBS CONFIGURE_DEPENDS
        ${TI_SIMPLELINK_SDK_DIR}/source/ti/drivers/lib/*.a
        ${TI_SIMPLELINK_SDK_DIR}/source/ti/drivers/lib/*.lib
    )

    if(TI_DRIVER_LIBS)
        target_link_libraries(app PRIVATE ${TI_DRIVER_LIBS})
    endif()
endif()
