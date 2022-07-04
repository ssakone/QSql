cmake_minimum_required(VERSION 3.14)

project(QSql LANGUAGES CXX)

find_package(Qt6 COMPONENTS Sql REQUIRED)

link_directories(${CMAKE_CURRENT_SOURCE_DIR}/lib/mysql)

qt6_add_library(QSql STATIC)
qt6_add_qml_module(QSql
    URI QSql
    VERSION 1.0
    QML_FILES
        qml/SqliDriver.qml
    SOURCES
        src/sqlplugin.h
        src/sqlplugin.cpp
)
message(STATUS ${CMAKE_CURRENT_SOURCE_DIR}/src/mysql)

target_link_libraries(QSql
    PRIVATE Qt::Sql libmysql.dll libmysql.lib)
