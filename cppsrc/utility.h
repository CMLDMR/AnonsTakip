#ifndef UTILITY_H
#define UTILITY_H

#include <QtCore/QObject>
#include <QtCore/qglobal.h>

#include <QDate>
#include <QTime>
#include <QUrl>
#include <QFileInfo>


class Utility : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString errorMessage READ errorMessage WRITE setErrorMessage NOTIFY errorMessageChanged)
public:
    explicit Utility(QObject *parent = nullptr);

    QString errorMessage() const;
    void setErrorMessage(const QString &errorMessage);


    Q_INVOKABLE QString getTime() const;

    Q_INVOKABLE qint64 getDate() const;

    Q_INVOKABLE QString getRandomFileName( const QString& filePath );


signals:
    void errorMessageChanged(QString mesaj);


public slots:


private:


    QString mErrorMessage;
};

#endif // UTILITY_H
