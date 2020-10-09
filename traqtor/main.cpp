#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFont>
#include <QFontDatabase>
#include "radialbar.h"
#include "tractor.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    int fontId = QFontDatabase::addApplicationFont(":/fonts/Nunito_Sans/NunitoSans-Regular.ttf");
    if (fontId != -1) {
        QFont nunitoFont("Nunito Sans");
        app.setFont(nunitoFont);
    }

    qmlRegisterType<Tractor>("app.tractor", 1, 0, "Tractor");
    qmlRegisterType<RadialBar>("app.customControls", 1, 0, "RadialBar");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
