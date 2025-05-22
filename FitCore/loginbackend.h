#ifndef LOGINBACKEND_H
#define LOGINBACKEND_H

#include "usersession.h"

#include <QObject>

class loginbackend : public QObject {

    Q_OBJECT

public:
    explicit loginbackend(UserSession* userSession, QObject *parent = nullptr);

    Q_INVOKABLE void verifyCredentials(const QString &username, const QString &password_hash);

signals:
    void loginSuccess();
    void loginFailed(const QString &reason);

private:
    UserSession* m_userSession;
};

#endif // LOGINBACKEND_H
