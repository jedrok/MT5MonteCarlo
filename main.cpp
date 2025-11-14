#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "ExcelParser.h"
#include "StatusBarManager.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    ExcelParser excelParser;
    StatusBarManager statusBarManager;


    // connect parser signals to status bar
    QObject::connect(&excelParser, &ExcelParser::parsingProgress,
    &statusBarManager, &StatusBarManager::updateParsingProgress);


    QQmlApplicationEngine engine;

    // expose the parser to QML
    engine.rootContext()->setContextProperty("excelParser", &excelParser);
    engine.rootContext()->setContextProperty("statusBarManager", &statusBarManager);


    const QUrl url(QStringLiteral("qrc:/MT5MonteCarlo/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
