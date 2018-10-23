#ifndef DBKEY_H
#define DBKEY_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>

class DBKey : public QObject
{
    Q_OBJECT
public:
    explicit DBKey(QObject *parent = nullptr);

signals:

public slots:
};

#endif // DBKEY_H