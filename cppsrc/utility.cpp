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
