cmake_minimum_required(VERSION 3.16)

project(MT5MonteCarlo VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

list(APPEND CMAKE_PREFIX_PATH "/usr/local")


find_package(Qt6 REQUIRED COMPONENTS
    Quick
    Graphs
)
find_package(Xlnt REQUIRED)


qt_add_executable(appMT5MonteCarlo
    main.cpp
)

qt_policy(SET QTP0001 OLD)

qt_add_qml_module(appMT5MonteCarlo
    URI MT5MonteCarlo
    VERSION 1.0
    QML_FILES Main.qml
    RESOURCES resources.qrc
    QML_FILES MetricCard.qml
    SOURCES ExcelParser.cpp
    SOURCES ExcelParser.h
    SOURCES StatusBarManager.cpp
    SOURCES StatusBarManager.h
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appMT5MonteCarlo PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appMT5MonteCarlo
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appMT5MonteCarlo
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Graphs
    PRIVATE xlnt::xlnt
)


include(GNUInstallDirs)
install(TARGETS appMT5MonteCarlo
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
