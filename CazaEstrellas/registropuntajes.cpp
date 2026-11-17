
#include "registropuntajes.h"
#include <QDateTime>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSaveFile>
#include <QStandardPaths>

// Constructor que carga las partidas guardadas
RegistroPuntajes::RegistroPuntajes(QObject *padre)
    : QAbstractListModel(padre)
{
    cargarPartidas();
}

// Devuelve la cantidad de partidas de la lista
int RegistroPuntajes::rowCount(
    const QModelIndex &padre
    ) const
{
    if (padre.isValid())
        return 0;

    return partidas.size();
}

// Obtiene la informacion de una partida segun el campo
QVariant RegistroPuntajes::data(
    const QModelIndex &indice,
    int campo
    ) const
{
    if (!indice.isValid() ||
        indice.row() < 0 ||
        indice.row() >= partidas.size())
        return {};

    const Partida &partida = partidas.at(indice.row());

    switch (campo) {
    case Nombre:
        return partida.nombre;

    case Alias:
        return partida.alias;

    case Edad:
        return partida.edad;

    case Dificultad:
        return partida.dificultad;

    case Puntos:
        return partida.puntos;

    case Fecha:
        return partida.fecha;

    default:
        return {};
    }
}

// Define los nombres que QML utiliza para leer los datos
QHash<int, QByteArray> RegistroPuntajes::roleNames() const
{
    return {
        {Nombre, "nombre"},
        {Alias, "alias"},
        {Edad, "edad"},
        {Dificultad, "dificultad"},
        {Puntos, "puntos"},
        {Fecha, "fecha"}
    };
}

// Devuelve la cantidad total de partidas
int RegistroPuntajes::cantidad() const
{
    return partidas.size();
}

// Registra una nueva partida con sus datos y puntuacion
void RegistroPuntajes::agregarPartida(
    const QString &nombre,
    const QString &alias,
    int edad,
    const QString &dificultad,
    int puntos
    )
{
    // Comprueba que los datos sean validos
    if (nombre.trimmed().size() < 2 ||
        alias.trimmed().size() < 2 ||
        edad < 5 ||
        edad > 100 ||
        puntos < 0)
        return;

    Partida partida;

    partida.nombre = nombre.trimmed();
    partida.alias = alias.trimmed();
    partida.edad = edad;
    partida.dificultad = dificultad;
    partida.puntos = puntos;

    // Guarda la fecha en que se realizo la partida
    partida.fecha = QDateTime::currentDateTime().toString(
        "dd/MM/yyyy hh:mm"
        );

    // Agrega la partida al inicio del historial
    beginInsertRows(QModelIndex(), 0, 0);

    partidas.prepend(partida);

    endInsertRows();

    emit cantidadChanged();

    // Guarda los cambios en el archivo
    guardarPartidas();
}

// Elimina todas las partidas del historial
void RegistroPuntajes::eliminarHistorial()
{
    if (partidas.isEmpty())
        return;

    beginResetModel();

    partidas.clear();

    endResetModel();

    emit cantidadChanged();

    guardarPartidas();
}

// Obtiene la ubicacion donde se guardan las partidas
QString RegistroPuntajes::obtenerRuta() const
{
    return QStandardPaths::writableLocation(
               QStandardPaths::AppDataLocation
               ) + "/partidas.json";
}

// Carga las partidas que se guardaron anteriormente
void RegistroPuntajes::cargarPartidas()
{
    QFile archivo(obtenerRuta());

    // Comprueba que el archivo se pueda abrir
    if (!archivo.open(QIODevice::ReadOnly))
        return;

    QJsonParseError error;

    // Convierte el contenido del archivo a JSON
    QJsonDocument documento = QJsonDocument::fromJson(
        archivo.readAll(), &error
        );

    if (error.error != QJsonParseError::NoError ||
        !documento.isArray())
        return;

    // Recorre los datos para recuperar cada partida
    for (const QJsonValue &valor : documento.array()) {
        if (!valor.isObject())
            continue;

        QJsonObject objeto = valor.toObject();

        Partida partida;

        partida.nombre = objeto.value("nombre").toString();
        partida.alias = objeto.value("alias").toString();
        partida.edad = objeto.value("edad").toInt();
        partida.dificultad = objeto.value("dificultad").toString();
        partida.puntos = objeto.value("puntos").toInt();
        partida.fecha = objeto.value("fecha").toString();

        partidas.append(partida);
    }
}

// Guarda todas las partidas en un archivo JSON
void RegistroPuntajes::guardarPartidas() const
{
    QFileInfo informacion(obtenerRuta());

    // Crea la carpeta de datos si no existe
    QDir().mkpath(informacion.absolutePath());

    QJsonArray lista;

    // Convierte cada partida en un objeto JSON
    for (const Partida &partida : partidas) {
        QJsonObject objeto;

        objeto["nombre"] = partida.nombre;
        objeto["alias"] = partida.alias;
        objeto["edad"] = partida.edad;
        objeto["dificultad"] = partida.dificultad;
        objeto["puntos"] = partida.puntos;
        objeto["fecha"] = partida.fecha;

        lista.append(objeto);
    }

    QSaveFile archivo(obtenerRuta());

    if (!archivo.open(QIODevice::WriteOnly))
        return;

    // Escribe los datos y guarda los cambios
    archivo.write(QJsonDocument(lista).toJson());

    archivo.commit();
}
