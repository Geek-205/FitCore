#ifndef ACCESSMANAGER_H
#define ACCESSMANAGER_H

#pragma once
#include <QString>
#include <QStringList>
#include <QMap>

class AccessManager
{
public:
    static QStringList getTabsForRole(const QString& role);
};

#endif // ACCESSMANAGER_H
