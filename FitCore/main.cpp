#include "loginbackend.h"
#include <QQmlContext>

#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlError>

#include <QDebug>

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QSqlDatabase db = QSqlDatabase::addDatabase("QODBC");

    db.setDatabaseName("Driver={SQL Server};Server=localhost\\SQLEXPRESS;Database=FitCore;Trusted_Connection=yes;");

    if (!db.open()) {
        qWarning() << "Database error: " << db.lastError().text();
    }
    else {
        qDebug() << "Connected to Database!";
    }

    loginbackend loginbackend;
    engine.rootContext()->setContextProperty("loginbackend", &loginbackend);

    engine.loadFromModule("FitCore", "Login");

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);

    return app.exec();
}
