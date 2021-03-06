#ifndef DBKEY_H
#define DBKEY_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>

class DBKey : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString collection READ collection )
public:
    explicit DBKey(QObject *parent = nullptr);




    QString collection() const;
    void setCollection(const QString &collection);

signals:

public slots:


private:
    QString mCollection = "AnonsCihazlari";

    QString mCihazAdi = "cihazadi";

    QString mLatitude = "latitude";

    QString mLongtitude = "longtitude";

    QString mMahalle = "mahalle";
};

#endif // DBKEY_H
