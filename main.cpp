#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFont>
#include "radialbar.h"
#include "process.h"
#include "gsettings.h"
#include "qfile.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    app.setFont(QFont("Ubuntu"));

    qmlRegisterType<RadialBar>("CustomControls", 1, 0, "RadialBar");
    qmlRegisterType<Process>("Process", 1, 0, "Process");
    qmlRegisterType<Qgsettings>("Gsettings", 1, 0, "Qgsettings");
    qmlRegisterType<QmlFile>("QmlFile", 1, 0, "QmlFile");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
