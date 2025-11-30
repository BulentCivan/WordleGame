#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "WordOperator.h"
#include <QIcon>


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/wordle_logo.ico"));

    qmlRegisterType<WordOperator>("Game", 1, 0, "WordOperator");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/Main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
