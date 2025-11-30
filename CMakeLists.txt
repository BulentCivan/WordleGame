cmake_minimum_required(VERSION 3.16)
project(WordleGame VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Network)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_resources(APP_QML resources.qrc)

add_executable(WordleGame WIN32
    main.cpp
    WordOperator.cpp
    WordOperator.h
    ${APP_QML}
)

target_link_libraries(WordleGame
    PRIVATE Qt6::Quick Qt6::Network
)
