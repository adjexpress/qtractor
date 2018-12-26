#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "radialbar.h"
#include "process.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    qmlRegisterType<RadialBar>("CustomControls", 1, 0, "RadialBar");
    qmlRegisterType<Process>("Process", 1, 0, "Process");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
