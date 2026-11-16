#ifndef REGISTROPUNTAJES_H
#define REGISTROPUNTAJES_H


#include <QAbstractListModel>
#include <QList>
#include <QString>

struct Partida
{
    QString nombre;
    QString alias;
    int edad;
    QString dificultad;
    int puntos;
    QString fecha;
};


class RegistroPuntajes : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int cantidad READ cantidad NOTIFY cantidadChanged)

public:
    explicit RegistroPuntajes(QObject *padre = nullptr);

    enum Campos {
        Nombre = Qt::UserRole + 1,
        Alias,
        Edad,
        Dificultad,
        Puntos,
        Fecha
    };

    int rowCount(
        const QModelIndex &padre = QModelIndex()
        ) const override;

    QVariant data(
        const QModelIndex &indice,
        int campo
        ) const override;

    QHash<int, QByteArray> roleNames() const override;

    int cantidad() const;
};

#endif // REGISTROPUNTAJES_H
