
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "registropuntajes.h"

int main(int argc, char *argv[])
{
    // Se inicia la aplicacion
    QGuiApplication aplicacion(argc, argv);

    // Se crea el registro que guarda las puntuaciones
    RegistroPuntajes registro;

    // Se crea el motor que carga la interfaz QML
    QQmlApplicationEngine motor;

    // Permite utilizar el registro desde Main.qml
    motor.rootContext()->setContextProperty(
        "registroPuntajes", &registro
        );

    // Se carga la pantalla principal del juego
    motor.loadFromModule("JuegoDemo", "Main");

    // Si no se carga la interfaz, se cierra el programa
    if (motor.rootObjects().isEmpty()) {
        return -1;
    }

    // Mantiene la aplicacion funcionando
    return aplicacion.exec();
}
