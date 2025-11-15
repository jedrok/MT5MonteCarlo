#ifndef STATUSBARMANAGER_H
#define STATUSBARMANAGER_H

#include <QObject>
#include <QString>


class StatusBarManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isActive READ isActive NOTIFY isActiveChanged)
    Q_PROPERTY(QString statusText READ statusText NOTIFY statusTextChanged)
    Q_PROPERTY(int progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(QString statusType READ statusType NOTIFY statusTypeChanged)

public:
    explicit StatusBarManager(QObject *parent = nullptr);

    bool isActive() const {
        return m_isActive;
    }
    QString statusText() const {
        return m_statusText;
    }
    int progress() const {
        return m_progress;
    }
    QString statusType() const {   // parsing, simulating, idle
        return m_statusType;
    }

public slots:
    void setIdle();
    void setParsingFile(const QString &fileName);
    void updateParsingProgress(int current, int total);
    void parsingComplete();
    void setSimulating(int numSimulations);
    void updateSimulationProgress(int current, int total);
    void simulationComplete(int numSimulations);
    void setError(const QString &errorMessage);

signals:
    void isActiveChanged();
    void statusTextChanged();
    void progressChanged();
    void statusTypeChanged();

private:
    void setStatus(const QString &text, int progress, const QString &type, bool active);

    bool m_isActive;
    QString m_statusText;
    int m_progress;
    QString m_statusType;
};

#endif
