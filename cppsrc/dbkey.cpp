#include "dbkey.h"

DBKey::DBKey(QObject *parent) : QObject(parent)
{

}

QString DBKey::collection() const
{
    return mCollection;
}

void DBKey::setCollection(const QString &collection)
{
    mCollection = collection;
}
