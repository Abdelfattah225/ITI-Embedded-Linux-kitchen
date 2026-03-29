
cmake_minimum_required(VERSION 3.16)
project(itisimplecal LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

add_executable(itisimplecal
    main.cpp
    resources.qrc
)

target_link_libraries(itisimplecal PRIVATE Qt6::Quick)

include(GNUInstallDirs)
install(TARGETS itisimplecal RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

