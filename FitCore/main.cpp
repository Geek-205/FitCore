#include "loginbackend.h"
#include "usersession.h"
#include "nativeeventfilter.h"


#include <QQmlContext>
#include <QWindow>
#include <QtGui/qpa/qplatformnativeinterface.h>
#include <QGuiApplication>

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>

#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlError>

#include <QDebug>

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    NativeEventFilter *eventFilter = new NativeEventFilter();
    QCoreApplication::instance()->installNativeEventFilter(eventFilter);
    NativeEventFilter nativeFilter;
    QCoreApplication::instance()->installNativeEventFilter(&nativeFilter);
    QQmlApplicationEngine engine;

    QObject *loginWindow = nullptr;
    QObject *mainWindow = nullptr;

    QSqlDatabase db = QSqlDatabase::addDatabase("QODBC");

    db.setDatabaseName("Driver={SQL Server};Server=localhost\\SQLEXPRESS;Database=FitCore;Trusted_Connection=yes;");

    if (!db.open()) {
        qWarning() << "Database error: " << db.lastError().text();
    }
    else {
        qDebug() << "Connected to Database!";
    }

    UserSession userSession;
    loginbackend loginbackend(&userSession);

    engine.rootContext()->setContextProperty("loginbackend", &loginbackend);
    engine.rootContext()->setContextProperty("userSession", &userSession);

    QObject::connect(&loginbackend, &loginbackend::requestMainWindow, [&]() {
        if (mainWindow)
            return;

        engine.addImportPath("qrc:/components");

        QQmlComponent component(&engine, QUrl("qrc:/Main.qml"));
        if (component.status() != QQmlComponent::Ready) {
            qWarning() << "Failed to load Main.qml:" << component.errorString();
            return;
        }

        QObject *object = component.create();
        if (!object) {
            qWarning() << "Failed to create Main.qml instance";
            return;
        }

        QWindow *window = qobject_cast<QWindow *>(object);
        if (window) {
            window->setMinimumSize(QSize(1280, 720));
            window->showMaximized(); // адаптивное разворачивание
        } else {
            qWarning() << "Main.qml is not a Window";
        }

        mainWindow = object;
    });



    engine.loadFromModule("FitCore", "Login");

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [&](QObject *obj, const QUrl &) {
        if (!obj)
            return;

        QWindow *window = qobject_cast<QWindow *>(obj);
        if (window) {
            window->setMinimumSize(QSize(1280, 720));
            window->resize(1280, 720);

        #if defined(Q_OS_WIN)
            window->setFlags(Qt::FramelessWindowHint | Qt::Window | Qt::MSWindowsFixedSizeDialogHint);
            window->winId(); // Обязательно вызвать для инициализации окна
        #endif
        }
    });

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);

    return app.exec();
}
