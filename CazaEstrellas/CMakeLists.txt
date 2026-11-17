
cmake_minimum_required(VERSION 3.16)

project(JuegoDemo VERSION 1.0 LANGUAGES CXX)

# Se utiliza C++17 para desarrollar el proyecto
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Bibliotecas necesarias para la interfaz y los sonidos
find_package(Qt6 6.8 REQUIRED COMPONENTS
    Quick
    QuickControls2
    Multimedia
)

qt_standard_project_setup(REQUIRES 6.8)

# Archivos que contienen la logica en C++
qt_add_executable(appJuegoDemo
    main.cpp
    registropuntajes.h
    registropuntajes.cpp
)

# Se agrega la interfaz y los archivos de audio
qt_add_qml_module(appJuegoDemo
    URI JuegoDemo
    VERSION 1.0
    QML_FILES
        Main.qml
    RESOURCES
        audio/musica.wav
        audio/estrella.wav
        audio/meteorito.wav
        audio/etapa.wav
)

# Se conectan las bibliotecas con el proyecto
target_link_libraries(appJuegoDemo PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Multimedia
)

set_target_properties(appJuegoDemo PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

# Permite instalar la aplicacion compilada
include(GNUInstallDirs)

install(TARGETS appJuegoDemo
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
