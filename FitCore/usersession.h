#ifndef USERSESSION_H
#define USERSESSION_H

#pragma once
#include <QObject>
#include <QString>
#include <QStringList>

class UserSession : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString role READ role WRITE setRole NOTIFY roleChanged)
    Q_PROPERTY(QStringList availableTabs READ availableTabs NOTIFY availableTabsChanged)

public:
    explicit UserSession(QObject *parent = nullptr);

    QString role() const;
    void setRole(const QString& newRole);

    QStringList availableTabs() const;

signals:
    void roleChanged();
    void availableTabsChanged();

private:
    QString m_role;
    QStringList m_availableTabs;
};

#endif // USERSESSION_H
