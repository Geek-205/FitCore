#include "accessmanager.h"

QStringList AccessManager::getTabsForRole(const QString& role) {
    static QMap<QString, QStringList> accessMatrix = {
        { "Administrator", { "Dashboard", "Members", "Memberships", "Payments", "Visits", "Classes", "Reports", "Settings" } },
        { "Trainer",       { "Dashboard", "Members", "Visits", "Classes" } },
        { "Front Desk",    { "Dashboard", "Members", "Memberships", "Payments", "Visits" } },
        { "Manager",       { "Dashboard", "Members", "Reports", "Settings" } },
        { "Accountant",    { "Dashboard", "Payments", "Reports" } },
        { "IT Specialist", { "Dashboard", "Settings" } }
    };

    return accessMatrix.value(role, {});
}
