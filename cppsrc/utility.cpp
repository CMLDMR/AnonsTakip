#include "utility.h"

#include <QDebug>

Utility::Utility(QObject *parent) : QObject(parent)
{

}

QString Utility::errorMessage() const
{
    return mErrorMessage;
}

void Utility::setErrorMessage(const QString &errorMessage)
{
    mErrorMessage = errorMessage;
    emit errorMessageChanged(mErrorMessage);
}

QString Utility::getTime() const
{
    return QTime::currentTime().toString("hh:mm");
}

qint64 Utility::getDate() const
{
    return QDate::currentDate().toJulianDay();
}
