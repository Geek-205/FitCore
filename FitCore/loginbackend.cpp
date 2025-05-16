#include "loginbackend.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariant>

loginbackend::loginbackend(QObject *parent) : QObject(parent) {}

void loginbackend::verifyCredentials(const QString &username, const QString &password_hash) {

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) {
        emit loginFailed("Database is not connected");
        return;
    }

    QSqlQuery query;
    query.prepare("SELECT COUNT(*) FROM SystemUsers WHERE username = :username AND password_hash = :password");
    query.bindValue(":username", username);
    query.bindValue(":password", password_hash);

    if (query.exec() && query.next() && query.value(0).toInt() > 0) {
        emit loginSuccess();
    }
    else {
        emit loginFailed("Invalid credentials");
    }

    qDebug() << "verifyCredentials called with" << username << password_hash;
}
