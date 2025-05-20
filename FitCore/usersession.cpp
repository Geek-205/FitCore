#include "usersession.h"
#include "AccessManager.h"

UserSession::UserSession(QObject *parent) : QObject{parent} {}

QString UserSession::role() const {
    return m_role;
}

void UserSession::setRole(const QString& newRole) {
    if (m_role != newRole) {
        m_role = newRole;
        m_availableTabs = AccessManager::getTabsForRole(newRole);
        emit roleChanged();
        emit availableTabsChanged();
    }
}

QStringList UserSession::availableTabs() const {
    return m_availableTabs;
}
