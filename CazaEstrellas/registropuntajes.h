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


class registropuntajes
{
public:
    registropuntajes();
};

#endif // REGISTROPUNTAJES_H
