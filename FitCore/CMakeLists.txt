cmake_minimum_required(VERSION 3.16)

# Название проекта
project(FitCore VERSION 0.1 LANGUAGES CXX)

# Устанавливаем стандарт языка C++
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Указываем, какие модули Qt нужны
find_package(Qt6 6.5 REQUIRED COMPONENTS
    Core
    Gui
    Quick
    QuickControls2
    QuickLayouts
    Sql
    Network
    Test
    Concurrent
)

# Настройка проекта (рекомендуется в Qt)
qt_standard_project_setup(REQUIRES 6.5)

# Добавляем исполняемый файл из main.cpp
qt_add_executable(appFitCore
    main.cpp
)

# Подключаем QML модуль (Main.qml)
qt_add_qml_module(appFitCore
    URI FitCore
    VERSION 1.0

    QML_FILES
        Main.qml
        Login.qml

    SOURCES
        loginbackend.h          loginbackend.cpp
        accessmanager.h         accessmanager.cpp
        usersession.h           usersession.cpp

    RESOURCES
        resources.qrc
)

qt_add_resources(appFitCore "resources"
    PREFIX "/"
    FILES images/LogoLogin.png
    FILES images/x.png
    FILES images/-.png
)

# Свойства приложения (для Windows/macOS)
# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appFitCore PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appFitCore
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Подключаем библиотеки Qt
target_link_libraries(appFitCore
    PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::QuickLayouts
    Qt6::Sql
    Qt6::Network
    Qt6::Test
    Qt6::Concurrent
)

# Указываем куда устанавливать собранное приложение
include(GNUInstallDirs)
install(TARGETS appFitCore
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
