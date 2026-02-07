cmake_minimum_required(VERSION 3.16)
project(KDEQt6App VERSION 0.1 LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets)
find_package(KF6 REQUIRED COMPONENTS KIO KXmlGui)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

add_executable(kdeqt6-app src/main.cpp)
target_link_libraries(kdeqt6-app PRIVATE Qt6::Core Qt6::Gui Qt6::Widgets KF6::KIOCore KF6::KXmlGui)

install(TARGETS kdeqt6-app RUNTIME DESTINATION bin)
