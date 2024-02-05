cmake_minimum_required(VERSION 3.15)

project(Tape-Line
  VERSION 0.0.1
  DESCRIPTION "Tape-Line"
  LANGUAGES CXX
)

if(TARGET ${PROJECT_NAME})
    return()
endif()

if(NOT CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 20)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(CMAKE_CXX_EXTENSIONS OFF)
endif(NOT CMAKE_CXX_STANDARD)

set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOMOC ON)

find_package(QT NAMES Qt5 REQUIRED COMPONENTS Core Quick)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS
    Core
    Quick
    QuickControls2
    Widgets
    Positioning
    Location
)

add_executable(${PROJECT_NAME})

target_include_directories(${PROJECT_NAME}
    PUBLIC
        include
    PRIVATE
        src/c++
)

target_sources(${PROJECT_NAME}
  PUBLIC
    src/c++/main.cpp
    src/qml/qml.qrc
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        Qt${QT_VERSION_MAJOR}::Core
        Qt${QT_VERSION_MAJOR}::Quick
        Qt${QT_VERSION_MAJOR}::QuickControls2
        Qt${QT_VERSION_MAJOR}::Widgets
        Qt${QT_VERSION_MAJOR}::Positioning
        Qt${QT_VERSION_MAJOR}::Location
)

set_target_properties(${PROJECT_NAME} PROPERTIES
    ${BUNDLE_ID_OPTION}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_compile_definitions(${PROJECT_NAME}
  PUBLIC
    -DPROJECT_NAME="${PROJECT_NAME}"
    -DPROJECT_VERSION="${PROJECT_VERSION}"
    -DPROJECT_COMPANY="${PROJECT_HOMEPAGE_URL}"
    -DMAPWIDGETS_DEMO
    -DELEVATION_CHART_DEMO
)

message("${PROJECT_NAME} version ${PROJECT_VERSION} compiled successfully")
