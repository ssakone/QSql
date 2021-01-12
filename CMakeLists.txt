cmake_minimum_required(VERSION 3.14)

project(SISql LANGUAGES CXX)

find_package(Qt5 REQUIRED COMPONENTS
  Core
  Gui
  Qml
  Quick
  QuickControls2
  Svg
  Sql
  Xml
  QuickCompiler
)

set(HEADERS
    include/SISql/sqlplugin.h
)

set(SOURCES
  src/sqlplugin.cpp
  qml/SISql.qrc
)


list(APPEND QML_IMPORT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/qml/SISql)

list(REMOVE_DUPLICATES QML_IMPORT_PATH)

set(QML_IMPORT_PATH ${QML_IMPORT_PATH}
    CACHE STRING "Qt Creator 4.1 extra qml import paths"
    FORCE
)

list(APPEND QML2_IMPORT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/qml/SISql)

list(REMOVE_DUPLICATES QML2_IMPORT_PATH)

set(QML_IMPORT_PATH ${QML2_IMPORT_PATH}
    CACHE STRING "Qt Creator 4.1 extra qml import paths"
    FORCE
)


qtquick_compiler_add_resources(SISQL_QML_RES qml/SISql.qrc)

add_library(SISql STATIC ${HEADERS} ${SOURCES} ${SISQL_QML_RES})


target_compile_definitions(SISql PUBLIC)
target_include_directories(SISql PUBLIC include)

target_link_libraries(SISql PUBLIC
  Qt::Core
  Qt::Gui
  Qt::Svg
  Qt::Sql
  Qt::Xml
  Qt::Qml
  Qt::Quick
  Qt::QuickControls2
)

