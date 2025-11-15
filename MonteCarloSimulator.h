#ifndef MONTECARLOSIMULATOR_H
#define MONTECARLOSIMULATOR_H

#include <QObject>
#include <QString>
#include <QVector>
#include <random>

class MonteCarloSimulator : public QObject
{
    Q_OBJECT

public:
    explicit MonteCarloSimulator(QObject *parent = nullptr);

    struct SimulationResult {
        double finalBalance;
        double returnPercent;
        double maxDrawdown;
        double maxDrawdownPercent;
        double sharpeRatio;
        double profitFactor;
        double calmarRatio;
        int maxConsecutiveLosses;
        double winRate;
        double avgWin;
        double avgLoss;
        double riskRewardRatio;
        QVector<double> equityCurve;  // balance at each trade
    };

    struct AggregatedMetrics {
        // overview
        int numSimulations;
        double medianReturn;
        double meanReturn;
        double medianMaxDrawdown;
        double medianSharpeRatio;
        double riskOfRuin;
        double medianCalmarRatio;

        // returns
        double bestReturn;      // 99th percentile
        double worstReturn;     // 1st percentile
        double medianProfitFactor;

        // risk
        double bestMaxDrawdown;
        double worstMaxDrawdown;    // 95th percentile
        double valueAtRisk95;       // 95% VaR

        // trades
        int totalTrades;
        double medianWinRate;
        double avgRiskReward;
        double expectancyPerTrade;
        double avgLoss;
        double largestWin;
    };

public slots:
    void runSimulation(const QVector<double> &outcomes,
                       double initialBalance,
                       int numSimulations,
                       bool randomizeOrder);
    void stopSimulation();

signals:
    void simulationProgress(int current, int total);
    void simulationComplete(const QVariantMap &metrics);
    void simulationFailed(const QString &error);
    void simulationStopped();

private:
    SimulationResult runSingleSimulation(const QVector<double> &outcomes,
                                         double initialBalance);
    AggregatedMetrics aggregateResults(const QVector<SimulationResult> &results,
                                       int totalTrades);
    QVariantMap metricsToVariantMap(const AggregatedMetrics &metrics);
    double calculatePercentile(QVector<double> values, double percentile);

    bool m_stopRequested;
    std::mt19937 m_generator;
};

#endif
