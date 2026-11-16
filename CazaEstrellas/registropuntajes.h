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
    registropuntajes();
};

#endif // REGISTROPUNTAJES_H
