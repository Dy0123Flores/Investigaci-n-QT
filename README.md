# CazaEstrellas — Qt for Mobile

## Descripción del proyecto

CazaEstrellas es un videojuego desarrollado con Qt 6.8.3, C++ y QML para el curso Desarrollo de Software IV de la Universidad de Costa Rica.

El juego consiste en atrapar estrellas y evitar meteoritos durante partidas de 30 segundos. Cuenta con tres niveles de dificultad, cambios progresivos de velocidad, sistema de puntuaciones, combos y efectos de sonido.

El proyecto fue desarrollado con el propósito de demostrar las principales características de Qt for Mobile y su funcionamiento en el desarrollo de aplicaciones móviles.

## Tecnologías utilizadas

- Qt 6.8.3
- Qt Creator
- C++
- QML y Qt Quick
- Qt Multimedia
- CMake
- Android SDK y NDK
- JDK 17
- Git y GitHub

## Funcionalidades

El videojuego permite registrar jugadores mediante nombre, alias y edad. También cuenta con validaciones para comprobar que los datos ingresados sean correctos.

Durante la partida aparecen estrellas que suman puntos y meteoritos que los restan. El juego utiliza un cronómetro y un sistema que aumenta la velocidad cada 10 segundos.

Además, incluye música de fondo, efectos de sonido, pausa, selección de dificultad y almacenamiento local de resultados.

## Estructura del proyecto

`CMakeLists.txt`: configura los archivos y bibliotecas del proyecto.

`main.cpp`: inicia la aplicación y conecta C++ con QML.

`Main.qml`: contiene la interfaz gráfica y las funciones del videojuego.

`registropuntajes.h`: declara la estructura de las partidas y la clase encargada de administrar los puntajes.

`registropuntajes.cpp`: implementa los métodos para registrar, consultar, guardar y eliminar partidas.

`audio/`: contiene la música y los efectos utilizados durante el juego.

## Requisitos para ejecutar el proyecto

Es necesario contar con Qt Creator y Qt 6.8.3, incluyendo los componentes Qt Quick, Qt Quick Controls y Qt Multimedia.

Para ejecutar la aplicación en Windows se necesita un kit de compilación compatible, como MinGW.

Para Android es necesario configurar el JDK, Android SDK, Android NDK y un kit de Qt para Android.

## Ejecución en Windows

1. Abrir Qt Creator.
2. Seleccionar File → Open File or Project.
3. Abrir el archivo CMakeLists.txt.
4. Seleccionar el kit Desktop Qt 6.8.3 MinGW.
5. Ejecutar Run CMake.
6. Seleccionar Build Project.
7. Ejecutar la aplicación desde Qt Creator.

## Compilación para Android

1. Abrir el proyecto en Qt Creator.
2. Seleccionar el kit Qt 6.8.3 for Android arm64-v8a.
3. Comprobar que el SDK, NDK y JDK estén configurados.
4. Seleccionar Android API 34 como plataforma de compilación.
5. Ejecutar Run CMake.
6. Compilar el proyecto mediante Build Project.
7. Buscar el APK generado en la carpeta de compilación.
8. Instalarlo en un dispositivo Android compatible.

## Almacenamiento de información

Las puntuaciones del videojuego se guardan en un archivo JSON dentro del directorio de datos de la aplicación.

Cada partida almacena el nombre, alias, edad, dificultad, puntuación y fecha.

La información puede consultarse desde la pantalla de resultados y eliminarse mediante la opción de borrar historial.

## Limitaciones

El videojuego no cuenta con un sistema de usuarios en línea ni con una clasificación compartida entre dispositivos.

Actualmente no utiliza una API REST, ya que los resultados se almacenan localmente.

La compatibilidad debe comprobarse en los dispositivos de destino. La versión Android desarrollada utiliza la arquitectura arm64-v8a.

## Pruebas realizadas

Se realizaron las pruebas correspondientes en aplicación QT Creator y las pruebas se estaran almacenadas en la carpeta demostración
## Control de versiones

El proyecto utiliza Git y GitHub para registrar las modificaciones realizadas durante su desarrollo. Los commits permiten identificar los cambios en la configuración, los métodos, la interfaz y las funcionalidades del videojuego.

## Integrantes
Dylan Flores Reyes
Alejandra Quiros

## Referencias

- Documentación oficial de Qt: https://doc.qt.io/qt-6.8/
- Qt for Android: https://doc.qt.io/qt-6.8/android.html
- Qt Quick: https://doc.qt.io/qt-6.8/qtquick-index.html
- Qt Multimedia: https://doc.qt.io/qt-6.8/qtmultimedia-index.html
