
#ifndef REGISTROPUNTAJES_H
#define REGISTROPUNTAJES_H

#include <QAbstractListModel>
#include <QList>
#include <QString>

// Guarda los datos de una partida
struct Partida
{
    QString nombre;
    QString alias;
    int edad;
    QString dificultad;
    int puntos;
    QString fecha;
};

// Clase encargada de administrar el historial
class RegistroPuntajes : public QAbstractListModel
{
    Q_OBJECT

    // Permite consultar la cantidad de partidas desde QML
    Q_PROPERTY(int cantidad READ cantidad NOTIFY cantidadChanged)

public:
    explicit RegistroPuntajes(QObject *padre = nullptr);

    // Identifica los datos que se muestran en la lista
    enum Campos {
        Nombre = Qt::UserRole + 1,
        Alias,
        Edad,
        Dificultad,
        Puntos,
        Fecha
    };

    // Devuelve la cantidad de partidas almacenadas
    int rowCount(
        const QModelIndex &padre = QModelIndex()
        ) const override;

    // Obtiene los datos de una partida
    QVariant data(
        const QModelIndex &indice,
        int campo
        ) const override;

    // Asigna nombres a los datos utilizados en QML
    QHash<int, QByteArray> roleNames() const override;

    // Consulta la cantidad de partidas
    int cantidad() const;

    // Agrega una nueva partida al historial
    Q_INVOKABLE void agregarPartida(
        const QString &nombre,
        const QString &alias,
        int edad,
        const QString &dificultad,
        int puntos
        );

    // Permite borrar las partidas guardadas
    Q_INVOKABLE void eliminarHistorial();

signals:
    // Avisa cuando cambia la cantidad de partidas
    void cantidadChanged();

private:
    // Lista donde se almacenan las partidas
    QList<Partida> partidas;

    // Metodos para trabajar con el archivo JSON
    QString obtenerRuta() const;
    void cargarPartidas();
    void guardarPartidas() const;
};

#endif
