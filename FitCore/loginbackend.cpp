#include "loginbackend.h"

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariant>

loginbackend::loginbackend(UserSession* userSession, QObject *parent)
    : QObject(parent), m_userSession(userSession) {}

void loginbackend::verifyCredentials(const QString &username, const QString &password_hash) {

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) {
        emit loginFailed("Database is not connected");
        return;
    }

    QSqlQuery query;
    query.prepare(R"(
        SELECT R.role_name
        FROM SystemUsers U
        JOIN UserRoles R ON U.role_id = R.role_id
        WHERE U.username = :username AND U.password_hash = :password
    )");

    query.bindValue(":username", username);
    query.bindValue(":password", password_hash);

    if (query.exec() && query.next()) {
        QString role = query.value(0).toString();  // ← получаем role_name
        m_userSession->setRole(role);              // ← устанавливаем в сессию
        emit loginSuccess();                       // ← сигнал об успехе
    } else {
        emit loginFailed("Invalid credentials");
    }

    qDebug() << "verifyCredentials called with" << username << password_hash;
}
