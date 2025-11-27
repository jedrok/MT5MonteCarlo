cmake_minimum_required(VERSION 3.16)


project(MT5MonteCarlo VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

set(MACOSX_BUNDLE_ICON_FILE mt5_monte_carlo_icon.icns)
set(APP_ICON ${CMAKE_SOURCE_DIR}/assets/logo/mt5_monte_carlo_icon.icns)
# ensure icon is copied into the .app bundle Resources
set_source_files_properties(${APP_ICON} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")


find_package(Qt6 REQUIRED COMPONENTS
    Quick
    Graphs
)

find_package(Xlnt REQUIRED)


qt_add_executable(appMT5MonteCarlo
    MACOSX_BUNDLE
    main.cpp
    ${APP_ICON}
)

qt_policy(SET QTP0001 OLD)

qt_add_qml_module(appMT5MonteCarlo
    URI MT5MonteCarlo
    VERSION 0.1
    QML_FILES Main.qml
    RESOURCES resources.qrc
    QML_FILES MetricCard.qml
    SOURCES ExcelParser.cpp
    SOURCES ExcelParser.h
    SOURCES StatusBarManager.cpp
    SOURCES StatusBarManager.h
    SOURCES MonteCarloSimulator.h
    SOURCES MonteCarloSimulator.cpp
    RESOURCES assets/logo/mt5_monte_carlo_icon.png
    RESOURCES assets/logo/mt5_monte_carlo_icon.icns
)

add_custom_target(show_vcpkg_json SOURCES vcpkg.json)
add_custom_target(show_README.md SOURCES README.md)


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
