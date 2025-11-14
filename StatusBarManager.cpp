#include "StatusBarManager.h"
#include <QTimer>


StatusBarManager::StatusBarManager(QObject *parent)
    : QObject(parent)
    , m_isActive(false)
    , m_progress(0)
    , m_statusType("idle")
{
}

void StatusBarManager::setIdle()
{
    setStatus("Ready", 0, "idle", false);
}

void StatusBarManager::setParsingFile(const QString &fileName)
{
    QString shortName = fileName;
    if (shortName.length() > 30) {
        shortName = "..." + shortName.right(27);
    }
    setStatus("Parsing " + shortName + "...", 0, "parsing", true);
}

void StatusBarManager::updateParsingProgress(int current, int total)
{
    if (total > 0) {
        int progressPercent = (current * 100) / total;
        m_progress = progressPercent;
        emit progressChanged();

        m_statusText = QString("Parsing file... %1%").arg(progressPercent);
        emit statusTextChanged();
    }
}

void StatusBarManager::parsingComplete()
{
    setStatus("Parsing complete", 100, "parsing", true);
}

void StatusBarManager::setSimulating(int numSimulations)
{
    setStatus(QString("Starting %1 simulations...").arg(numSimulations), 0, "simulating", true);
}

void StatusBarManager::updateSimulationProgress(int current, int total)
{
    if (total > 0) {
        int progressPercent = (current * 100) / total;
        m_progress = progressPercent;
        emit progressChanged();

        m_statusText = QString("Running simulation... %1%").arg(progressPercent);
        emit statusTextChanged();
    }
}

void StatusBarManager::simulationComplete()
{
    setStatus("Simulation complete", 100, "simulating", true);

    // auto hide after 2 secs
    QTimer::singleShot(2000, this, &StatusBarManager::setIdle);
}

void StatusBarManager::setError(const QString &errorMessage)
{
    setStatus("Error: " + errorMessage, 0, "error", true);
}

void StatusBarManager::setStatus(const QString &text, int progress, const QString &type, bool active)
{

    if (m_statusText != text) {
        m_statusText = text;
        emit statusTextChanged();
    }

    if (m_progress != progress) {
        m_progress = progress;
        emit progressChanged();
    }

    if (m_statusType != type) {
        m_statusType = type;
        emit statusTypeChanged();
    }

    if (m_isActive != active) {
        m_isActive = active;
        emit isActiveChanged();
    }
}
