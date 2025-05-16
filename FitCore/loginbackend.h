#ifndef LOGINBACKEND_H
#define LOGINBACKEND_H

#include <QObject>

class loginbackend : public QObject
{
    Q_OBJECT
public:
    explicit loginbackend(QObject *parent = nullptr);

    Q_INVOKABLE void verifyCredentials(const QString &username, const QString &password_hash);

signals:
    void loginSuccess();
    void loginFailed(const QString &reason);
};

#endif // LOGINBACKEND_H
