#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "ExcelParser.h"
#include "StatusBarManager.h"
#include "MonteCarloSimulator.h"




int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    ExcelParser excelParser;
    StatusBarManager statusBarManager;
    MonteCarloSimulator monteCarloSimulator;

    // parser signals
    QObject::connect(&excelParser, &ExcelParser::parsingProgress,
    &statusBarManager, &StatusBarManager::updateParsingProgress);

    // sim progress
    QObject::connect(&monteCarloSimulator, &MonteCarloSimulator::simulationProgress,
                     &statusBarManager, &StatusBarManager::updateSimulationProgress);



    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("excelParser", &excelParser);
    engine.rootContext()->setContextProperty("statusBarManager", &statusBarManager);
    engine.rootContext()->setContextProperty("monteCarloSimulator", &monteCarloSimulator);


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
